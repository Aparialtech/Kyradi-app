import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../core/repositories/luggage_repository.dart';
import '../../core/drop_locations.dart';
import '../../models/luggage.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/app_notification.dart';
import '../../utils/crash_log.dart';

class LuggageAddPage extends StatefulWidget {
  const LuggageAddPage({super.key});

  @override
  State<LuggageAddPage> createState() => _LuggageAddPageState();
}

class _LuggageAddPageState extends State<LuggageAddPage> {
  final _formKey = GlobalKey<FormState>();
  final _labelCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _size = 'medium';
  String _color = 'black';
  DateTime? _dropTime;
  DateTime? _pickupTime;
  bool _saving = false;
  String? _userId;
  final LuggageRepository _repo = const LuggageRepository();
  final Random _random = Random();
  List<DropLocation> _locations = [];
  DropLocation? _selectedLocation;
  bool _locationsReady = false;

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _loadLocations();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('userId');
    if (!mounted) return;
    setState(() => _userId = id);
  }

  void _loadLocations() {
    final locations = DropLocationsRepository.locations;
    _locations = locations;
    _selectedLocation = locations.isNotEmpty ? locations.first : null;
    _locationsReady = true;
  }

  String _generateQrCode() {
    final stamp = DateTime.now()
        .millisecondsSinceEpoch
        .toRadixString(36)
        .toUpperCase();
    final suffix = (_random.nextInt(9000) + 1000).toString();
    return 'BGO-$stamp-$suffix';
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
    setState(() {
      if (isDrop) {
        _dropTime = picked;
      } else {
        _pickupTime = picked;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final loc = AppLocalizations.of(context)!;
    if (_userId == null || _userId!.isEmpty) {
      AppNotification.show(
        context,
        message: loc.userIdMissing,
        type: AppNotificationType.warning,
      );
      return;
    }
    setState(() => _saving = true);
    try {
      if (_selectedLocation == null) {
        AppNotification.show(
          context,
          message: loc.mapNoLocations,
          type: AppNotificationType.warning,
        );
        setState(() => _saving = false);
        return;
      }
      final payload = <String, dynamic>{
        'qrCode': _generateQrCode(),
        'label': _labelCtrl.text.trim().isEmpty
          ? loc.quickAddLuggage
          : _labelCtrl.text.trim(),
        'weight': _weightCtrl.text.trim(),
        'size': _size,
        'color': _color,
        'note': _noteCtrl.text.trim(),
        'dropLocationId': _selectedLocation!.id,
        'dropLocationName': _selectedLocation!.name,
        if (_dropTime != null) 'scheduledDropTime': _dropTime,
        if (_pickupTime != null) 'scheduledPickupTime': _pickupTime,
      };
      final luggage = await _repo.createLuggage(_userId!, payload);
      if (!mounted) return;
      context.pop<LuggageModel>(luggage);
    } catch (e) {
      appLog('luggage', 'create failed $e', level: AppLogLevel.error);
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.luggageCreateFailed,
        type: AppNotificationType.error,
      );
      setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _weightCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.addLuggageTitle),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            if (_locationsReady)
              DropdownButtonFormField<DropLocation>(
                // ignore: deprecated_member_use
                value: _selectedLocation,
                items: _locations
                    .map(
                      (location) => DropdownMenuItem(
                        value: location,
                        child: Text(location.name),
                      ),
                    )
                    .toList(),
                onChanged: _saving
                    ? null
                    : (value) => setState(() => _selectedLocation = value),
                decoration: InputDecoration(
                  labelText: loc.findLocation,
                ),
              ),
            if (!_locationsReady)
              const Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: LinearProgressIndicator(minHeight: 2),
              ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _labelCtrl,
              decoration: InputDecoration(labelText: loc.luggageNameHint),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _weightCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: loc.luggageInfoWeight('')),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: _size,
              items: [
                DropdownMenuItem(value: 'small', child: Text(loc.small)),
                DropdownMenuItem(value: 'medium', child: Text(loc.medium)),
                DropdownMenuItem(value: 'large', child: Text(loc.large)),
              ],
              onChanged: (value) => setState(() => _size = value ?? _size),
              decoration: InputDecoration(labelText: loc.luggageInfoSize('')),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              // ignore: deprecated_member_use
              value: _color,
              items: [
                DropdownMenuItem(value: 'black', child: Text(loc.black)),
                DropdownMenuItem(value: 'grey', child: Text(loc.grey)),
                DropdownMenuItem(value: 'red', child: Text(loc.red)),
                DropdownMenuItem(value: 'blue', child: Text(loc.blue)),
                DropdownMenuItem(value: 'green', child: Text(loc.green)),
                DropdownMenuItem(value: 'other', child: Text(loc.other)),
              ],
              onChanged: (value) => setState(() => _color = value ?? _color),
              decoration: InputDecoration(labelText: loc.luggageInfoColor('')),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _noteCtrl,
              maxLines: 3,
              decoration: InputDecoration(labelText: loc.noteLabel('')),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(loc.howItWorksStep5Title),
              subtitle: Text(
                _dropTime == null
                    ? loc.deliverySectionSubtitle
                    : _dropTime!.toLocal().toString(),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _saving ? null : () => _pickDateTime(isDrop: true),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(loc.luggagePickupAction),
              subtitle: Text(
                _pickupTime == null
                    ? loc.deliverySectionSubtitle
                    : _pickupTime!.toLocal().toString(),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _saving ? null : () => _pickDateTime(isDrop: false),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(loc.saveLuggage),
            ),
          ],
        ),
      ),
    );
  }
}
