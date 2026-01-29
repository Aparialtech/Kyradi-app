import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/drop_locations.dart';
import '../../core/ios/ios_config_service.dart';
import '../../l10n/app_localizations.dart';
import '../../models/reservation_draft.dart';

class StepScheduleLocation extends StatefulWidget {
  const StepScheduleLocation({
    super.key,
    required this.draft,
    required this.locations,
    required this.onChanged,
  });

  final ReservationDraft draft;
  final List<DropLocation> locations;
  final ValueChanged<ReservationDraft> onChanged;

  @override
  State<StepScheduleLocation> createState() => _StepScheduleLocationState();
}

class _StepScheduleLocationState extends State<StepScheduleLocation> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _showMap = false;

  @override
  void initState() {
    super.initState();
    _prepareMap();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.draft.location == null && widget.locations.isNotEmpty) {
        _updateDraft((draft) => draft.location = widget.locations.first);
      }
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _prepareMap() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      setState(() => _showMap = true);
      return;
    }
    final hasKey = await IosConfigService.hasGmsApiKey();
    if (!mounted) return;
    setState(() => _showMap = hasKey);
  }

  void _updateDraft(void Function(ReservationDraft draft) apply) {
    final next = widget.draft.copy();
    apply(next);
    widget.onChanged(next);
  }

  Future<void> _pickDateTime({required bool isDrop}) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    final picked = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    _updateDraft((draft) {
      if (isDrop) {
        draft.dropAt = picked;
      } else {
        draft.pickupAt = picked;
      }
    });
  }

  String _formatDateTime(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day.$month.${value.year} $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final query = _searchCtrl.text.trim().toLowerCase();
    final filtered = widget.locations.where((location) {
      if (query.isEmpty) return true;
      return location.name.toLowerCase().contains(query) ||
          location.address.toLowerCase().contains(query);
    }).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          loc.stepScheduleTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _searchCtrl,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: loc.findLocation,
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 12),
        if (_showMap && filtered.isNotEmpty)
          SizedBox(
            height: 180,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: filtered.first.position,
                  zoom: 12.4,
                ),
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                markers: {
                  for (final location in filtered)
                    Marker(
                      markerId: MarkerId(location.id),
                      position: location.position,
                      onTap: () => _updateDraft((draft) {
                        draft.location = location;
                      }),
                    ),
                },
              ),
            ),
          )
        else
          Container(
            height: 120,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Text(loc.mapNoLocations),
          ),
        const SizedBox(height: 12),
        DropdownButtonFormField<DropLocation>(
          value: filtered.contains(widget.draft.location)
              ? widget.draft.location
              : null,
          decoration: InputDecoration(
            labelText: loc.findLocation,
            prefixIcon: const Icon(Icons.location_on_outlined),
          ),
          items: [
            for (final location in filtered)
              DropdownMenuItem(
                value: location,
                child: Text(location.name),
              ),
          ],
          onChanged: (value) => _updateDraft((draft) => draft.location = value),
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.login_rounded),
          title: Text(loc.dropTimeTitle),
          subtitle: Text(
            widget.draft.dropAt == null
                ? loc.dropTimePlaceholder
                : _formatDateTime(widget.draft.dropAt!),
          ),
          onTap: () => _pickDateTime(isDrop: true),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.logout_rounded),
          title: Text(loc.pickupTimeTitle),
          subtitle: Text(
            widget.draft.pickupAt == null
                ? loc.pickupTimePlaceholder
                : _formatDateTime(widget.draft.pickupAt!),
          ),
          onTap: () => _pickDateTime(isDrop: false),
        ),
      ],
    );
  }
}
