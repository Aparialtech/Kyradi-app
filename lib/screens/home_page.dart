import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../models/luggage.dart';
import '../models/user.dart';
import 'change_password_page.dart';
import '../services/api_service.dart';
import '../services/luggage_service.dart';
import '../services/locations_service.dart';
import '../core/app_locale.dart';
import '../core/drop_locations.dart';
import '../l10n/app_localizations.dart';
import '../widgets/app_notification.dart';
import '../widgets/gradient_button.dart';
import '../widgets/section_card.dart';
import '../services/reminder_service.dart';

const _identityDocPathKey = 'identity_doc_path';
const _identityDocTypeKey = 'identity_doc_type';
const _identityDocBytesKey = 'identity_doc_bytes';
const _pickupPinStoragePrefix = 'pickup_pin_';

const String _googleMapsApiKey = String.fromEnvironment(
  'GOOGLE_MAPS_API_KEY',
  defaultValue: 'REMOVED_GOOGLE_KEY',
);
const _pushReminderPref = 'pref_push_reminder';
const _emailReminderPref = 'pref_email_reminder';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Random _random = Random();

  double? _lat;
  double? _lng;
  final _destCtrl = TextEditingController();
  final List<LuggageModel> _luggages = [];
  bool _luggageLoading = false;
  bool _qrNavigationPending = false;

  String? _userId;
  UserModel? _currentUser;
  final _userNameCtrl = TextEditingController();
  final _userSurnameCtrl = TextEditingController();
  final _userEmailCtrl = TextEditingController();
  final _userPhoneCtrl = TextEditingController();
  final _userAddressCtrl = TextEditingController();
  String? _gender;
  String? _identityDocUrl;

  final _emNameCtrl = TextEditingController();
  final _emSurnameCtrl = TextEditingController();
  final _emPhoneCtrl = TextEditingController();
  final _emEmailCtrl = TextEditingController();
  final _emAddressCtrl = TextEditingController();
  final _emRelationCtrl = TextEditingController();

  String _selectedLang = "tr";
  bool _inAppNotif = true;
  bool _notifSound = true;
  bool _notifVibrate = true;
  bool _savingProfile = false;
  bool _pushReminderEnabled = true;
  bool _emailReminderEnabled = true;

  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _identityDocPreview;
  IdentityDocumentType _identityDocType = IdentityDocumentType.idCard;
  String? _identityDocFileName;
  bool get _hasIdentityProof =>
      _identityDocPreview != null || (_identityDocUrl?.isNotEmpty ?? false);

  final List<DropLocation> _dropLocations =
      List<DropLocation>.from(DropLocationsRepository.locations);
  bool _locationsLoading = false;
  String? _selectedDeliveryId;
  DropLocation? _selectedMapLocation;
  Set<_LuggageFilter> _luggageFilter = const {_LuggageFilter.all};
  GoogleMapController? _googleMapController;
  Polyline? _activeRoute;
  _RouteMode? _activeRouteMode;
  bool _fetchingRoute = false;

  List<DropLocation> get _effectiveLocations =>
      _dropLocations.isNotEmpty ? _dropLocations : DropLocationsRepository.locations;

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _restoreUserIdThenLoad();
    _loadIdentityProof();
    _loadReminderPrefs();
  }

  Future<void> _loadLocations() async {
    setState(() => _locationsLoading = true);
    try {
      final remote = await LocationsService.fetchLocations();
      if (!mounted) return;
      setState(() {
        _dropLocations
          ..clear()
          ..addAll(remote.isNotEmpty
              ? remote
              : DropLocationsRepository.locations);
        _locationsLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _dropLocations
          ..clear()
          ..addAll(DropLocationsRepository.locations);
        _locationsLoading = false;
      });
    }
  }

  Future<void> _restoreUserIdThenLoad() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!mounted) return;
      final id = prefs.getString("userId");
      if (id == null || id.isEmpty) {
        final loc = AppLocalizations.of(context)!;
        _snack(loc.userIdMissing, type: AppNotificationType.warning);
        return;
      }
      _userId = id;
      await _loadProfile(id);
      await _loadUserLuggages(id);
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _snack(loc.userIdReadFailed('$e'), type: AppNotificationType.error);
    }
  }

  Future<void> _storePickupPin(String luggageId, String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_pickupPinStoragePrefix$luggageId', pin);
  }

  Future<String?> _loadPickupPin(String luggageId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('$_pickupPinStoragePrefix$luggageId');
  }

  Future<void> _loadIdentityProof() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_identityDocBytesKey);
    Uint8List? bytes;
    if (encoded != null && encoded.isNotEmpty) {
      try {
        bytes = base64Decode(encoded);
      } catch (_) {
        bytes = null;
      }
    }
    if (!mounted) return;
    setState(() {
      _identityDocPreview = bytes;
      _identityDocFileName = prefs.getString(_identityDocPathKey);
      final storedType = prefs.getString(_identityDocTypeKey);
      _identityDocType =
          IdentityDocumentTypeExtension.fromName(storedType) ??
              IdentityDocumentType.idCard;
    });
  }

  Future<void> _loadReminderPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final push = prefs.getBool(_pushReminderPref);
    final email = prefs.getBool(_emailReminderPref);
    if (!mounted) return;
    setState(() {
      if (push != null) _pushReminderEnabled = push;
      if (email != null) _emailReminderEnabled = email;
    });
    ReminderService.setPushEnabled(_pushReminderEnabled);
    ReminderService.setEmailEnabled(_emailReminderEnabled);
  }

  Future<void> _loadProfile(String userId) async {
    try {
      final result = await ApiService.getProfile(userId);
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      if (result['ok'] != true) {
        final rawMessage =
            (result['error'] ?? result['message'] ?? '').toString().trim();
        final message = rawMessage.isNotEmpty
            ? rawMessage
            : loc.profileLoadFailed(loc.unknownError);
        _snack(message, type: AppNotificationType.error);
        return;
      }
      final rawProfile = result['profile'] ?? result['data'] ?? result;
      if (rawProfile is! Map<String, dynamic>) {
        _snack(loc.profileDataMissing, type: AppNotificationType.error);
        return;
      }
      final user = UserModel.fromJson(Map<String, dynamic>.from(rawProfile));
      if (!mounted) return;
      setState(() {
        _currentUser = user;
        _userNameCtrl.text = user.name;
        _userSurnameCtrl.text = user.surname;
        _userEmailCtrl.text = user.email;
        _userPhoneCtrl.text = user.phone;
        _userAddressCtrl.text = user.address;
        _gender = user.gender;
        _identityDocUrl = user.identityDocumentUrl;
        _pushReminderEnabled = user.pushReminderEnabled;
        _emailReminderEnabled = user.emailReminderEnabled;

        final em = user.emergencyContact;
        if (em != null) {
          final parts = em.fullName.trim().split(RegExp(r'\s+'));
          _emNameCtrl.text = parts.isNotEmpty ? parts.first : '';
          _emSurnameCtrl.text =
              parts.length > 1 ? parts.sublist(1).join(' ') : '';
          _emPhoneCtrl.text = em.phone;
          _emEmailCtrl.text = em.email;
          _emAddressCtrl.text = em.address;
          _emRelationCtrl.text = em.relation;
        } else {
          _emNameCtrl.clear();
          _emSurnameCtrl.clear();
          _emPhoneCtrl.clear();
          _emEmailCtrl.clear();
          _emAddressCtrl.clear();
          _emRelationCtrl.clear();
        }
      });
    } catch (e) {
      final loc = AppLocalizations.of(context)!;
      _snack(loc.profileLoadFailed('$e'), type: AppNotificationType.error);
    }
  }

  Future<void> _loadUserLuggages(String userId) async {
    try {
      setState(() => _luggageLoading = true);
      final loaded = await LuggageService.getUserLuggages(userId);
      if (!mounted) return;
      setState(() {
        _luggages
          ..clear()
          ..addAll(loaded);
        _luggageLoading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _luggageLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_savingProfile) return;
    if (_userId == null || _userId!.isEmpty) {
      final loc = AppLocalizations.of(context)!;
      _snack(loc.loginRequired, type: AppNotificationType.warning);
      return;
    }
    setState(() => _savingProfile = true);
    final emergencyFullName = [
      _emNameCtrl.text.trim(),
      _emSurnameCtrl.text.trim()
    ].where((e) => e.isNotEmpty).join(' ').trim();
    final body = {
      "name": _userNameCtrl.text.trim(),
      "surname": _userSurnameCtrl.text.trim(),
      "email": _userEmailCtrl.text.trim(),
      "phone": _userPhoneCtrl.text.trim(),
      "address": _userAddressCtrl.text.trim(),
      "gender": _gender,
      "identityDocumentUrl": _identityDocUrl,
      "emergencyContact": {
        "fullName": emergencyFullName,
        "phone": _emPhoneCtrl.text.trim(),
        "email": _emEmailCtrl.text.trim(),
        "address": _emAddressCtrl.text.trim(),
        "relation": _emRelationCtrl.text.trim(),
      },
    };
    debugPrint('[PROFILE] sending body => ${jsonEncode(body)}');
    try {
      final result = await ApiService.updateProfile(_userId!, body);
      if (!mounted) return;
      if (result['ok'] == true) {
        final loc = AppLocalizations.of(context)!;
        _snack(loc.profileSaved, type: AppNotificationType.success);
      } else {
        final loc = AppLocalizations.of(context)!;
        final rawMessage = (result['error'] ?? '').toString().trim();
        _snack(
          rawMessage.isNotEmpty ? rawMessage : loc.saveProfileError,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _snack(loc.operationFailedWithDetails('$e'),
          type: AppNotificationType.error);
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _pickIdentityDocument(
    IdentityDocumentType type,
    ImageSource source,
  ) async {
    try {
      final file = await _imagePicker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (file == null) return;
      final bytes = await file.readAsBytes();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_identityDocBytesKey, base64Encode(bytes));
      await prefs.setString(_identityDocPathKey, file.name.isNotEmpty ? file.name : file.path);
      await prefs.setString(_identityDocTypeKey, type.name);

      String? remoteUrl;
      if (_userId != null) {
        final uploadResult = await ApiService.uploadIdentityDocument(
          bytes: bytes,
          filename: file.name.isNotEmpty ? file.name : 'identity_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        if (uploadResult['ok'] == true && uploadResult['fileUrl'] != null) {
          remoteUrl = uploadResult['fileUrl'].toString();
        } else {
          final error = (uploadResult['error'] ?? '').toString().trim();
          if (mounted) {
            final loc = AppLocalizations.of(context)!;
            _snack(
              error.isNotEmpty ? error : loc.identityUploadFailed(loc.unknownError),
              type: AppNotificationType.error,
            );
          }
        }
      }

      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      setState(() {
        _identityDocPreview = bytes;
        _identityDocFileName = file.name.isNotEmpty ? file.name : file.path;
        _identityDocType = type;
        if (remoteUrl != null) {
          _identityDocUrl = remoteUrl;
        }
      });
      _snack(
        loc.identityPhotoSaved(type.label(loc)),
        type: AppNotificationType.success,
      );
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _snack(
        loc.identityUploadFailed('$e'),
        type: AppNotificationType.error,
      );
    }
  }

  Future<void> _clearIdentityDocument() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_identityDocBytesKey);
    await prefs.remove(_identityDocPathKey);
    await prefs.remove(_identityDocTypeKey);
    if (!mounted) return;
    setState(() {
      _identityDocPreview = null;
      _identityDocFileName = null;
      _identityDocUrl = null;
    });
    final loc = AppLocalizations.of(context)!;
    _snack(loc.identityRemoved, type: AppNotificationType.info);
  }

  Future<void> _ensureLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _snack(loc.locationServiceDisabled, type: AppNotificationType.warning);
      return;
    }
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _snack(loc.locationPermissionPermanentlyDenied,
          type: AppNotificationType.warning);
    }
  }

  Future<bool> _ensureCurrentPosition({bool showSnackOnSuccess = true}) async {
    try {
      await _ensureLocationPermission();
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return false;
      setState(() {
        _lat = pos.latitude;
        _lng = pos.longitude;
      });
      if (_googleMapController != null) {
        await _googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(LatLng(pos.latitude, pos.longitude), 14.5),
        );
      }
      if (showSnackOnSuccess) {
        if (!mounted) return true;
        final loc = AppLocalizations.of(context)!;
        _snack(
          loc.locationReceived(
            pos.latitude.toStringAsFixed(5),
            pos.longitude.toStringAsFixed(5),
          ),
          type: AppNotificationType.success,
        );
      }
      return true;
    } catch (e) {
      if (!mounted) return false;
      final loc = AppLocalizations.of(context)!;
      _snack(loc.locationFailedWithDetails('$e'),
          type: AppNotificationType.error);
      return false;
    }
  }

  Future<void> _locateMe() async {
    await _ensureCurrentPosition();
  }

  String _generateQrCode() {
    final stamp = DateTime.now()
        .millisecondsSinceEpoch
        .toRadixString(36)
        .toUpperCase();
    final suffix = (_random.nextInt(9000) + 1000).toString();
    return 'BGO-$stamp-$suffix';
  }

  String _generatePickupPin() {
    return (_random.nextInt(9000) + 1000).toString();
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime.toLocal());
  }

  void _replaceLuggage(LuggageModel updated) {
    final index = _luggages.indexWhere((l) => l.id == updated.id);
    if (index >= 0) {
      final existing = _luggages[index];
      final next = updated.qrCode.isNotEmpty
          ? updated
          : updated.copyWith(qrCode: existing.qrCode);
      _luggages[index] = next;
    } else {
      _luggages.insert(0, updated);
    }
  }

  int get _awaitingCount =>
      _luggages.where((l) => l.isAwaitingDrop).length;
  int get _storedCount =>
      _luggages.where((l) => l.isDropped).length;
  int get _pickedCount =>
      _luggages.where((l) => l.isPickedUp).length;
  int get _cancelledCount =>
      _luggages.where((l) => l.isCancelled).length;

  List<LuggageModel> get _visibleLuggages {
    final filter = _luggageFilter.first;
    if (filter == _LuggageFilter.all) {
      return List<LuggageModel>.unmodifiable(_luggages);
    }
    return _luggages
        .where((l) => _matchesFilter(l, filter))
        .toList(growable: false);
  }

  bool _matchesFilter(LuggageModel luggage, _LuggageFilter filter) {
    return switch (filter) {
      _LuggageFilter.all => true,
      _LuggageFilter.awaiting => luggage.isAwaitingDrop,
      _LuggageFilter.stored => luggage.isDropped,
      _LuggageFilter.picked => luggage.isPickedUp,
    };
  }

  void _openLuggageListPage(String title, List<LuggageModel> items) {
    final loc = AppLocalizations.of(context)!;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: SafeArea(
            child: items.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      loc.luggageEmptyStateFiltered,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                    children: items.map(_buildLuggageCard).toList(),
                  ),
          ),
        ),
      ),
    );
  }

  List<_LuggageFilterOption> _luggageFilterOptions(
    AppLocalizations loc,
  ) {
    return [
      _LuggageFilterOption(
        value: _LuggageFilter.all,
        label: loc.luggageFilterAll,
        icon: Icons.all_inbox_outlined,
      ),
      _LuggageFilterOption(
        value: _LuggageFilter.awaiting,
        label: loc.luggageFilterAwaiting,
        icon: Icons.timer_outlined,
      ),
      _LuggageFilterOption(
        value: _LuggageFilter.stored,
        label: loc.luggageFilterStored,
        icon: Icons.inventory_2_outlined,
      ),
      _LuggageFilterOption(
        value: _LuggageFilter.picked,
        label: loc.luggageFilterPicked,
        icon: Icons.check_circle_outline,
      ),
    ];
  }

  Future<void> _openTransitRoute() async {
    if (_lat == null || _lng == null) {
      final loc = AppLocalizations.of(context)!;
      _snack(loc.routeNeedLocation, type: AppNotificationType.warning);
      return;
    }
    final dest = _destCtrl.text.trim();
    if (dest.isEmpty) {
      final loc = AppLocalizations.of(context)!;
      _snack(loc.routeNeedDestination, type: AppNotificationType.warning);
      return;
    }
    final url = Uri.parse(
      "https://www.google.com/maps/dir/?api=1"
      "&origin=$_lat,$_lng"
      "&destination=${Uri.encodeComponent(dest)}"
      "&travelmode=transit",
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _snack(loc.mapsOpenFailed, type: AppNotificationType.error);
    }
  }

  void _snack(String msg, {AppNotificationType type = AppNotificationType.info}) {
    if (!mounted) return;
    AppNotification.show(context, message: msg, type: type);
  }

  Future<void> _openExternalMaps(
    DropLocation location, {
    String travelMode = 'transit',
  }) async {
    final hasLocation = await _ensureCurrentPosition(showSnackOnSuccess: false);
    if (!hasLocation || _lat == null || _lng == null) return;

    final origin = '${_lat!},${_lng!}';
    final destination =
        '${location.position.latitude},${location.position.longitude}';
    final url = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&origin=$origin'
      '&destination=$destination'
      '&travelmode=$travelMode',
    );
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _snack(loc.mapsOpenFailed, type: AppNotificationType.error);
    }
  }

  DropLocation? _locationFor(LuggageModel luggage) {
    final source = _effectiveLocations;
    if (luggage.dropLocationId.isNotEmpty) {
      for (final loc in source) {
        if (loc.id == luggage.dropLocationId) return loc;
      }
    }
    if (luggage.dropLocationName.isNotEmpty) {
      final name = luggage.dropLocationName.toLowerCase();
      for (final loc in source) {
        if (loc.name.toLowerCase() == name) return loc;
      }
    }
    return DropLocationsRepository.byId(luggage.dropLocationId) ??
        DropLocationsRepository.byName(luggage.dropLocationName);
  }

  DropLocation? _dropLocationById(String? id) {
    if (id == null) return null;
    for (final loc in _effectiveLocations) {
      if (loc.id == id) return loc;
    }
    return DropLocationsRepository.byId(id);
  }

  void _openLocationForLuggage(LuggageModel luggage) {
    final location = _locationFor(luggage);
    if (location == null) {
      final loc = AppLocalizations.of(context)!;
      _snack(loc.luggageLocationMissing,
          type: AppNotificationType.warning);
      return;
    }
    _openExternalMaps(location, travelMode: 'walking');
  }

  Widget _buildLuggageCard(LuggageModel luggage) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final statusChipColor = luggage.statusColor(theme);
    final chipBackground = statusChipColor.withValues(alpha: 0.12);
    final infoItems = <String>[];
    if ((luggage.size ?? '').isNotEmpty) {
      infoItems.add(
        loc.luggageInfoSize(_localizedSizeLabel(luggage.size, loc)),
      );
    }
    if ((luggage.weight ?? '').isNotEmpty) {
      infoItems.add(loc.luggageInfoWeight(luggage.weight ?? ''));
    }
    if ((luggage.color ?? '').isNotEmpty) {
      infoItems.add(
        loc.luggageInfoColor(_localizedColorLabel(luggage.color, loc)),
      );
    }
    final DropLocation? dropLoc = _locationFor(luggage);
    final String locationLabel = dropLoc?.name.isNotEmpty == true
        ? dropLoc!.name
        : luggage.dropLocationName;

    return SectionCard(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                foregroundColor: theme.colorScheme.primary,
                child: const Icon(Icons.luggage),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      luggage.displayLabel,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SelectableText(
                      '${loc.qrCode}: ${luggage.qrCode}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Chip(
                label: Text(luggage.statusLabel),
                backgroundColor: chipBackground,
                labelStyle: theme.textTheme.labelSmall?.copyWith(
                  color: statusChipColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (infoItems.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              infoItems.join(' · '),
              style: theme.textTheme.bodyMedium,
            ),
          ],
          if (locationLabel.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    locationLabel,
                    style: theme.textTheme.bodyMedium,
                  ),
                ),
                TextButton(
                  onPressed: () => _openLocationForLuggage(luggage),
                  child: Text(loc.openInMaps),
                ),
              ],
            ),
          ],
          if ((luggage.note ?? '').isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              loc.noteLabel(luggage.note ?? ''),
              style: theme.textTheme.bodySmall,
            ),
          ],
          if (luggage.scheduledDropTime != null ||
              luggage.scheduledPickupTime != null) ...[
            const SizedBox(height: 8),
            if (luggage.scheduledDropTime != null)
              Text(
                loc.scheduledDropLabel(
                  _formatDateTime(luggage.scheduledDropTime),
                ),
                style: theme.textTheme.bodySmall,
              ),
            if (luggage.scheduledPickupTime != null)
              Text(
                loc.scheduledPickupLabel(
                  _formatDateTime(luggage.scheduledPickupTime),
                ),
                style: theme.textTheme.bodySmall,
              ),
          ],
          if (luggage.isCancelled) ...[
            const SizedBox(height: 12),
            Text(
              loc.reservationCancelledLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ActionTextButton(
                icon: Icons.qr_code_2,
                label: loc.luggageShowQr,
                onPressed: () => _showQrDialog(luggage),
              ),
                if (luggage.status == LuggageStatus.awaitingDrop)
                  _ActionFilledButton(
                    icon: Icons.inventory_2_outlined,
                    label: loc.luggageDropAction,
                    onPressed: () => _handleLuggageAction(luggage, _QrAction.drop),
                  )
                else if (luggage.status == LuggageStatus.dropped)
                  _ActionFilledButton(
                    icon: Icons.check_circle_outline,
                    label: loc.luggagePickupAction,
                    onPressed: () => _handleLuggageAction(luggage, _QrAction.pickup),
                  ),
                if (!luggage.isPickedUp && !luggage.isCancelled)
                  _ActionTextButton(
                    icon: Icons.person_outline,
                    label: loc.luggageDelegateAction,
                    onPressed: () => _openDelegateDialog(luggage),
                  ),
                if (luggage.isAwaitingDrop && !luggage.isCancelled)
                  _ActionTextButton(
                    icon: Icons.cancel_outlined,
                    label: loc.luggageCancelAction,
                    onPressed: () => _cancelReservation(luggage),
                  ),
                if (locationLabel.isNotEmpty)
                  _ActionTextButton(
                    icon: Icons.map_outlined,
                    label: loc.luggageOpenLocation,
                    onPressed: () => _openLocationForLuggage(luggage),
                  ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.2)),
          const SizedBox(height: 8),
          Text(
            loc.createdAtLabel(_formatDateTime(luggage.createdAt)),
            style: theme.textTheme.bodySmall,
          ),
          if (luggage.dropConfirmedAt != null)
            Text(
              loc.dropConfirmedAtLabel(
                _formatDateTime(luggage.dropConfirmedAt),
              ),
              style: theme.textTheme.bodySmall,
            ),
          if (luggage.pickupConfirmedAt != null)
            Text(
              loc.pickupConfirmedAtLabel(
                _formatDateTime(luggage.pickupConfirmedAt),
              ),
              style: theme.textTheme.bodySmall,
            ),
        ],
      ),
    );
  }

  Future<void> _openAddLuggage() async {
    if (_userId == null) {
      final loc = AppLocalizations.of(context)!;
      _snack(loc.loginRequired, type: AppNotificationType.warning);
      return;
    }
    final newLuggage = await Navigator.push<LuggageModel?>(
      context,
      MaterialPageRoute(
        builder: (_) => AddLuggagePage(
          userId: _userId!,
          qrGenerator: _generateQrCode,
          pickupPinGenerator: _generatePickupPin,
        ),
      ),
    );

    if (newLuggage != null) {
      if (!mounted) return;
      setState(() {
        _luggages.removeWhere((l) => l.id == newLuggage.id);
        _luggages.insert(0, newLuggage);
      });
      ReminderService.scheduleReminders(
        context,
        label: newLuggage.displayLabel,
        dropTime: newLuggage.scheduledDropTime,
        pickupTime: newLuggage.scheduledPickupTime,
      );
      final loc = AppLocalizations.of(context)!;
      _snack(loc.luggageCreated, type: AppNotificationType.success);
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 200);
      }
    }
  }

  Future<void> _showQrDialog(LuggageModel luggage) async {
    if (_qrNavigationPending || !mounted) return;
    _qrNavigationPending = true;
    final pin = await _loadPickupPin(luggage.id);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        _qrNavigationPending = false;
        return;
      }
      Navigator.of(context)
          .push(
            MaterialPageRoute<void>(
              builder: (_) => QrPreviewPage(
                luggage: luggage,
                pickupPin: pin,
              ),
              fullscreenDialog: true,
            ),
          )
          .whenComplete(() {
        _qrNavigationPending = false;
      });
    });
  }

  Future<String?> _requestPickupCredential(LuggageModel luggage) async {
    final loc = AppLocalizations.of(context)!;
    final isDelegate = luggage.isDelegateActive;
    final controller = TextEditingController();
    final title =
        isDelegate ? loc.delegateCodeTitle : loc.pickupPinTitle;
    final label =
        isDelegate ? loc.delegateCodeLabel : loc.pickupPinLabel;
    final hint =
        isDelegate ? loc.delegateCodeHint : loc.pickupPinHint;

    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(loc.dialogDismiss),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx, controller.text.trim());
            },
            child: Text(loc.dialogConfirm),
          ),
        ],
      ),
    );
    return result?.trim().isNotEmpty == true ? result : null;
  }

  Future<void> _handleLuggageAction(
    LuggageModel luggage,
    _QrAction action,
  ) async {
    if (_userId == null) {
      final loc = AppLocalizations.of(context)!;
      _snack(loc.loginRequired, type: AppNotificationType.warning);
      return;
    }

    final verified = await _verifyQrCode(luggage, action);
    if (!verified) return;

    final status = action == _QrAction.drop
        ? luggageStatusDropped
        : luggageStatusPickedUp;
    String? pickupPin;
    String? delegateCode;
    if (action == _QrAction.pickup) {
      final credential = await _requestPickupCredential(luggage);
      if (credential == null || credential.isEmpty) return;
      if (luggage.isDelegateActive) {
        delegateCode = credential;
      } else {
        pickupPin = credential;
      }
    }
    try {
      final result = await LuggageService.updateStatus(
        _userId!,
        luggage.id,
        status,
        pickupPin,
        delegateCode,
      );
      if (result['ok'] == true && result['luggage'] is Map<String, dynamic>) {
        final updated = LuggageModel.fromJson(
          Map<String, dynamic>.from(result['luggage'] as Map),
        );
        if (!mounted) return;
        setState(() {
          _replaceLuggage(updated);
        });
        final loc = AppLocalizations.of(context)!;
        _snack(
          action == _QrAction.drop
              ? loc.dropConfirmedMessage
              : loc.pickupConfirmedMessage,
          type: AppNotificationType.success,
        );
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 220);
        }
        await _loadLocations();
        await _loadUserLuggages(_userId!);
      } else {
        if (!mounted) return;
        final loc = AppLocalizations.of(context)!;
        final rawMessage =
            (result['error'] ?? result['message'] ?? '').toString().trim();
        final message = switch (rawMessage) {
          'PICKUP_PIN_REQUIRED' => loc.pickupPinRequiredMessage,
          'PICKUP_CREDENTIAL_REQUIRED' => loc.pickupPinRequiredMessage,
          'PICKUP_PIN_INVALID' => loc.pickupPinInvalidMessage,
          'DELEGATE_CODE_REQUIRED' => loc.delegateCodeRequiredMessage,
          'DELEGATE_CODE_INVALID' => loc.delegateCodeInvalidMessage,
          _ => rawMessage,
        };
        _snack(
          message.isNotEmpty ? message : loc.operationFailed,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _snack(loc.operationFailedWithDetails('$e'),
          type: AppNotificationType.error);
    }
  }

  Future<void> _openDelegateDialog(LuggageModel luggage) async {
    final loc = AppLocalizations.of(context)!;
    final nameCtrl = TextEditingController(
      text: luggage.pickupDelegate?.fullName ?? '',
    );
    final phoneCtrl = TextEditingController(
      text: luggage.pickupDelegate?.phone ?? '',
    );
    final emailCtrl = TextEditingController(
      text: luggage.pickupDelegate?.email ?? '',
    );

    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(loc.delegateSetupTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(labelText: loc.delegateNameLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: loc.delegatePhoneLabel),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: loc.delegateEmailLabel),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(loc.dialogDismiss),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(loc.save),
          ),
        ],
      ),
    );

    if (result != true) return;
    final payload = {
      'pickupDelegateFullName': nameCtrl.text.trim(),
      'pickupDelegatePhone': phoneCtrl.text.trim(),
      'pickupDelegateEmail': emailCtrl.text.trim(),
    };
    try {
      final res = await ApiService.updateLuggageMetadata(
        _userId!,
        luggage.id,
        payload,
      );
      if (!mounted) return;
      final delegateCode = res['delegateCode']?.toString();
      if (res['ok'] == true && res['luggage'] is Map<String, dynamic>) {
        final updated = LuggageModel.fromJson(
          Map<String, dynamic>.from(res['luggage'] as Map),
        );
        setState(() => _replaceLuggage(updated));
      }
      if (delegateCode != null && delegateCode.isNotEmpty) {
        await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text(loc.delegateCodeTitle),
            content: SelectableText(
              loc.delegateCodeGenerated(delegateCode),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(loc.dialogDismiss),
              ),
            ],
          ),
        );
      } else {
        _snack(loc.delegateSavedMessage, type: AppNotificationType.success);
      }
    } catch (e) {
      if (!mounted) return;
      _snack(loc.genericErrorWithDetails('$e'),
          type: AppNotificationType.error);
    }
  }

  Future<void> _cancelReservation(LuggageModel luggage) async {
    if (_userId == null) {
      final loc = AppLocalizations.of(context)!;
      _snack(loc.loginRequired, type: AppNotificationType.warning);
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.cancelReservationTitle),
        content: Text(
          AppLocalizations.of(context)!
              .cancelReservationMessage(luggage.displayLabel),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(AppLocalizations.of(context)!.dialogDismiss),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(AppLocalizations.of(context)!.dialogConfirmCancel),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    try {
      final result = await LuggageService.updateStatus(
        _userId!,
        luggage.id,
        luggageStatusCancelled,
        null,
        null,
      );
      if (result['ok'] == true && result['luggage'] is Map<String, dynamic>) {
        final updated = LuggageModel.fromJson(
          Map<String, dynamic>.from(result['luggage'] as Map),
        );
        if (!mounted) return;
        setState(() {
          _replaceLuggage(updated);
        });
        final loc = AppLocalizations.of(context)!;
        _snack(loc.reservationCancelledMessage,
            type: AppNotificationType.info);
        await _loadLocations();
        await _loadUserLuggages(_userId!);
      } else {
        if (!mounted) return;
        final loc = AppLocalizations.of(context)!;
        final rawMessage = (result['error'] ?? '').toString().trim();
        _snack(
          rawMessage.isNotEmpty ? rawMessage : loc.cancelFailed,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _snack(loc.cancelFailedWithDetails('$e'),
          type: AppNotificationType.error);
    }
  }

  Future<bool> _verifyQrCode(
    LuggageModel luggage,
    _QrAction action,
  ) async {
    final expected = luggage.qrCode.trim();
    final loc = AppLocalizations.of(context)!;
    final title =
        action == _QrAction.drop ? loc.qrDropTitle : loc.qrPickupTitle;
    final manualHint = loc.qrManualEntryHint;
    final codeLabel = loc.qrCode;
    final dismissLabel = loc.dialogDismiss;
    final verifyLabel = loc.qrVerifyButton;
    String? scanned;

    if (kIsWeb) {
      scanned = await showDialog<String>(
        context: context,
        builder: (dialogContext) {
          final controller = TextEditingController();
          return AlertDialog(
            title: Text(title),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(manualHint),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: codeLabel,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: Text(dismissLabel),
              ),
              FilledButton(
                onPressed: () =>
                    Navigator.of(dialogContext).pop(controller.text.trim()),
                child: Text(verifyLabel),
              ),
            ],
          );
        },
      );
    } else {
      scanned = await Navigator.push<String?>(
        context,
        MaterialPageRoute(
          builder: (_) => _QrScanPage(
            expectedCode: expected,
            title: title,
          ),
        ),
      );
    }

    if (scanned == null) {
      return false;
    }

    if (scanned.trim() != expected) {
      if (!mounted) return false;
      final mismatchLoc = AppLocalizations.of(context)!;
      _snack(mismatchLoc.qrMismatchMessage,
          type: AppNotificationType.warning);
      return false;
    }
    return true;
  }

  Future<void> _drawRoute(DropLocation location, _RouteMode mode) async {
    if (_googleMapsApiKey.isEmpty) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _snack(loc.mapsMissingApiKey, type: AppNotificationType.error);
      return;
    }
    final hasLocation = await _ensureCurrentPosition(showSnackOnSuccess: false);
    if (!hasLocation || _lat == null || _lng == null) return;

    setState(() {
      _fetchingRoute = true;
      _activeRouteMode = mode;
      _selectedMapLocation = location;
    });

    final modeParam = switch (mode) {
      _RouteMode.walking => 'walking',
      _RouteMode.transit => 'transit',
      _RouteMode.driving => 'driving',
    };

    final origin = '${_lat!},${_lng!}';
    final destination =
        '${location.position.latitude},${location.position.longitude}';

    final buffer = StringBuffer(
      'https://maps.googleapis.com/maps/api/directions/json'
      '?origin=$origin&destination=$destination'
      '&mode=$modeParam&key=$_googleMapsApiKey',
    );
    if (mode == _RouteMode.transit) {
      final departure = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      buffer.write('&departure_time=$departure');
    }

    final uri = Uri.parse(buffer.toString());

    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 15));
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      if (res.statusCode != 200) {
        _snack(
          loc.routeFetchFailedWithDetails('${res.statusCode}'),
          type: AppNotificationType.error,
        );
        return;
      }

      final body = jsonDecode(res.body) as Map<String, dynamic>;
      final status = (body['status'] ?? '').toString();
      if (status.isNotEmpty && status != 'OK') {
        final message = body['error_message']?.toString();
        final hint = message?.isNotEmpty == true
            ? message!
            : loc.directionsApiError(status);
        _snack(hint, type: AppNotificationType.error);
        return;
      }

      final routes = body['routes'] as List<dynamic>?;
      if (routes == null || routes.isEmpty) {
        _snack(loc.routeNotFound, type: AppNotificationType.warning);
        return;
      }

      final overview = routes.first['overview_polyline']?['points'] as String?;
      if (overview == null || overview.isEmpty) {
        _snack(loc.routeDataMissing, type: AppNotificationType.error);
        return;
      }

      final points = _decodePolyline(overview);
      if (!mounted) return;
      final theme = Theme.of(context);
      final polyline = Polyline(
        polylineId: PolylineId('route_${mode.name}_${location.id}'),
        color: _routeColorFor(mode, theme),
        width: 6,
        points: points,
      );

      if (!mounted) return;
      setState(() {
        _activeRoute = polyline;
        _selectedMapLocation = location;
      });

      final controller = _googleMapController;
      if (controller != null && points.isNotEmpty) {
        final bounds = _boundsFromPoints(points);
        try {
          await controller.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 64),
          );
        } catch (_) {
          await controller.animateCamera(
            CameraUpdate.newLatLngZoom(points.first, 13.5),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      _snack(
        loc.routeFetchFailedWithDetails('$e'),
        type: AppNotificationType.error,
      );
    } finally {
      if (mounted) {
        setState(() => _fetchingRoute = false);
      }
    }
  }

  Future<void> _focusOnLocation(DropLocation location) async {
    final controller = _googleMapController;
    if (controller == null) return;
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(location.position, 14.5),
    );
  }

  void _clearRoute() {
    if (_activeRoute == null && _activeRouteMode == null) return;
    setState(() {
      _activeRoute = null;
      _activeRouteMode = null;
    });
  }

  Color _routeColorFor(_RouteMode mode, ThemeData theme) {
    return switch (mode) {
      _RouteMode.walking => theme.colorScheme.primary,
      _RouteMode.transit => theme.colorScheme.tertiary,
      _RouteMode.driving => theme.colorScheme.secondary,
    };
  }

  List<LatLng> _decodePolyline(String encoded) {
    final List<LatLng> points = [];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int b;
      int shift = 0;
      int result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      final dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }
    return points;
  }

  LatLngBounds _boundsFromPoints(List<LatLng> points) {
    double south = points.first.latitude;
    double north = points.first.latitude;
    double west = points.first.longitude;
    double east = points.first.longitude;

    for (final point in points.skip(1)) {
      if (point.latitude < south) south = point.latitude;
      if (point.latitude > north) north = point.latitude;
      if (point.longitude < west) west = point.longitude;
      if (point.longitude > east) east = point.longitude;
    }

    if (south == north) {
      south -= 0.001;
      north += 0.001;
    }
    if (west == east) {
      west -= 0.001;
      east += 0.001;
    }

    return LatLngBounds(
      southwest: LatLng(south, west),
      northeast: LatLng(north, east),
    );
  }

  Widget _buildMapTab() {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final locations = _effectiveLocations;
    if (_locationsLoading && locations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (locations.isEmpty) {
      return Center(child: Text(loc.mapNoLocations));
    }
    final markers = locations.map((location) {
      return Marker(
        markerId: MarkerId(location.id),
        position: location.position,
        infoWindow: InfoWindow(
          title: location.name,
          snippet: location.address,
          onTap: () => _showLocationSheet(location),
        ),
        onTap: () {
          setState(() => _selectedMapLocation = location);
          _focusOnLocation(location);
        },
      );
    }).toSet();

    final polylines = <Polyline>{};
    if (_activeRoute != null) {
      polylines.add(_activeRoute!);
    }

    final initialTarget =
        _selectedMapLocation?.position ?? locations.first.position;

    final googleMap = GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialTarget,
        zoom: 12.5,
      ),
      myLocationEnabled: _lat != null && _lng != null,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      markers: markers,
      polylines: polylines,
      onMapCreated: (controller) => _googleMapController = controller,
      onTap: (_) => setState(() => _selectedMapLocation = null),
    );

    final mapSurface = _buildMapSurface(googleMap);

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          mapSurface,
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Card(
                  color: theme.colorScheme.surface.withValues(alpha: 0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      loc.mapIntro,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (_fetchingRoute)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: LinearProgressIndicator(
                  minHeight: 3,
                  color: theme.colorScheme.primary,
                  backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
            ),
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'map-my-location',
                    onPressed: () =>
                        _ensureCurrentPosition(showSnackOnSuccess: false),
                    child: const Icon(Icons.my_location),
                  ),
                  if (_activeRoute != null) ...[
                    const SizedBox(height: 12),
                    FloatingActionButton.small(
                      heroTag: 'map-clear-route',
                      backgroundColor: theme.colorScheme.surface,
                      foregroundColor: theme.colorScheme.onSurface,
                      onPressed: _clearRoute,
                      child: const Icon(Icons.clear),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 140,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  final isActive = _selectedMapLocation?.id == location.id;
                  return _buildLocationCard(location, isActive);
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: locations.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSurface(Widget map) {
    final borderRadius = BorderRadius.circular(24);
    if (kIsWeb) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: map,
      );
    }
    return ClipRRect(
      borderRadius: borderRadius,
      child: map,
    );
  }

  Widget _buildIdentityPreview() {
    final borderRadius = BorderRadius.circular(16);
    if (_identityDocPreview != null) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.memory(
          _identityDocPreview!,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    if (_identityDocUrl?.isNotEmpty == true) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: Image.network(
          _identityDocUrl!,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return SizedBox(
              height: 160,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) =>
              _buildIdentityPlaceholder(),
        ),
      );
    }
    return _buildIdentityPlaceholder();
  }

  Widget _buildIdentityPlaceholder() {
    final loc = AppLocalizations.of(context)!;
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.4),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: Center(
        child: Text(loc.identityPreviewHint),
      ),
    );
  }

  String _identityDocLabel(AppLocalizations loc) {
    if ((_identityDocFileName ?? '').isNotEmpty) {
      return _identityDocFileName!;
    }
    if (_identityDocUrl?.isNotEmpty == true) {
      final uri = Uri.tryParse(_identityDocUrl!);
      if (uri != null && uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.last;
      }
      return _identityDocUrl!;
    }
    return _identityDocType.label(loc);
  }

  String _languageNameFor(String code, AppLocalizations loc) {
    switch (code) {
      case 'tr':
        return loc.languageNameTr;
      case 'de':
        return loc.languageNameDe;
      case 'es':
        return loc.languageNameEs;
      case 'ru':
        return loc.languageNameRu;
      case 'en':
      default:
        return loc.languageNameEn;
    }
  }

  String _permissionLabel(String code, AppLocalizations loc) {
    switch (code) {
      case 'camera':
        return loc.permissionNameCamera;
      case 'location':
        return loc.permissionNameLocation;
      case 'notification':
      default:
        return loc.permissionNameNotifications;
    }
  }

  Widget _buildLocationCard(DropLocation location, bool isActive) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 220,
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: isActive
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surface,
        child: InkWell(
          onTap: () {
            setState(() => _selectedMapLocation = location);
            _focusOnLocation(location);
            _showLocationSheet(location);
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  location.address,
                  style: theme.textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.place, size: 18),
                    Icon(
                      Icons.route,
                      color: isActive
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReservationStatusTile(DropLocation location) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final fmt = DateFormat('dd MMM HH:mm', Localizations.localeOf(context).toLanguageTag());
    final nextReservations = location.reservations.take(2).toList();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  location.name,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                loc.availableSlotsLabel(
                  location.availableSlots,
                  location.totalSlots,
                ),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: location.occupancyRate,
            backgroundColor: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.5),
            minHeight: 4,
          ),
          const SizedBox(height: 6),
          if (nextReservations.isEmpty)
            Text(
              loc.reservationEmptyState,
              style: theme.textTheme.bodySmall,
            )
          else
            Column(
              children: nextReservations
                  .map(
                    (slot) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: const Icon(Icons.event_available_rounded, size: 20),
                      title: Text(loc.reservationTileTitle(slot.code)),
                      subtitle: Text(
                        loc.reservationTileSubtitle(
                          slot.code,
                          fmt.format(slot.time),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
        ],
      ),
    );
  }

  void _showLocationSheet(DropLocation location) {
    final loc = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(location.name, style: theme.textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(location.address, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 16),
                Text(loc.routeOptions, style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _drawRoute(location, _RouteMode.walking);
                      },
                      icon: const Icon(Icons.directions_walk),
                      label: Text(loc.walkingRoute),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _drawRoute(location, _RouteMode.transit);
                      },
                      icon: const Icon(Icons.directions_transit),
                      label: Text(loc.transitRoute),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _drawRoute(location, _RouteMode.driving);
                      },
                      icon: const Icon(Icons.directions_car),
                      label: Text(loc.drivingRoute),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        _openExternalMaps(location, travelMode: 'transit');
                      },
                      icon: const Icon(Icons.open_in_new),
                      label: Text(loc.openInMaps),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final luggageCount = _luggages.length;
    final displayName = _userNameCtrl.text.trim().isEmpty
        ? loc.travelerPlaceholder
        : _userNameCtrl.text.trim();
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.appTitle),
          actions: [
            IconButton(
              tooltip: loc.notificationsTooltip,
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.dashboard_outlined),
                text: AppLocalizations.of(context)!.dashboard,
              ),
              Tab(
                icon: const Icon(Icons.map),
                text: AppLocalizations.of(context)!.map,
              ),
              Tab(
                icon: const Icon(Icons.person),
                text: AppLocalizations.of(context)!.profile,
              ),
              Tab(
                icon: const Icon(Icons.settings),
                text: AppLocalizations.of(context)!.settings,
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // === Dashboard ===
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              children: [
                SectionCard(
                  backgroundColor: const Color(0xFFFFC27A),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: loc.dashboardGreeting(displayName),
                        subtitle: loc.dashboardSubtitle,
                        icon: Icons.dashboard_customize_outlined,
                        action: Chip(
                          label: Text(loc.dashboardTotalCount(luggageCount)),
                          backgroundColor: const Color(0xFFFF7A00),
                          labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: const Color(0xFF4B2400),
                              ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          QuickActionTile(
                            label: loc.findLocation,
                            icon: Icons.my_location,
                            onTap: _locateMe,
                          ),
                          QuickActionTile(
                            label: loc.quickAddLuggage,
                            icon: Icons.qr_code_2,
                            onTap: _openAddLuggage,
                          ),
                          QuickActionTile(
                            label: loc.quickTransit,
                            icon: Icons.directions_transit,
                            onTap: _openTransitRoute,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final metrics = [
                            _DashboardMetricTile(
                              label: loc.dashboardMetricAwaiting,
                              value: _awaitingCount,
                              icon: Icons.timer_outlined,
                              color: Theme.of(context).colorScheme.secondary,
                              onTap: () => _openLuggageListPage(
                                loc.dashboardMetricAwaiting,
                                _luggages
                                    .where((luggage) =>
                                        luggage.isAwaitingDrop)
                                    .toList(),
                              ),
                            ),
                            _DashboardMetricTile(
                              label: loc.dashboardMetricStored,
                              value: _storedCount,
                              icon: Icons.inventory_2_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              onTap: () => _openLuggageListPage(
                                loc.dashboardMetricStored,
                                _luggages
                                    .where((luggage) => luggage.isDropped)
                                    .toList(),
                              ),
                            ),
                            _DashboardMetricTile(
                              label: loc.dashboardMetricPicked,
                              value: _pickedCount,
                              icon: Icons.check_circle_outline,
                              color: Theme.of(context).colorScheme.tertiary,
                              onTap: () => _openLuggageListPage(
                                loc.dashboardMetricPicked,
                                _luggages
                                    .where((luggage) => luggage.isPickedUp)
                                    .toList(),
                              ),
                            ),
                            _DashboardMetricTile(
                              label: loc.dashboardMetricCancelled,
                              value: _cancelledCount,
                              icon: Icons.cancel_schedule_send_outlined,
                              color: Theme.of(context).colorScheme.error,
                              onTap: () => _openLuggageListPage(
                                loc.dashboardMetricCancelled,
                                _luggages
                                    .where((luggage) => luggage.isCancelled)
                                    .toList(),
                              ),
                            ),
                          ];
                          if (constraints.maxWidth < 520) {
                            return Column(
                              children: [
                                for (int i = 0; i < metrics.length; i++) ...[
                                  metrics[i],
                                  if (i != metrics.length - 1)
                                    const SizedBox(height: 12),
                                ],
                              ],
                            );
                          }
                          return Row(
                            children: [
                              for (int i = 0; i < metrics.length; i++) ...[
                                Expanded(child: metrics[i]),
                                if (i != metrics.length - 1)
                                  const SizedBox(width: 12),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: loc.deliverySectionTitle,
                        subtitle: loc.deliverySectionSubtitle,
                        icon: Icons.route_outlined,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        key: ValueKey(_selectedDeliveryId),
                        initialValue: _selectedDeliveryId,
                        decoration: InputDecoration(
                          labelText: loc.deliveryPointLabel,
                          prefixIcon: const Icon(Icons.location_on_outlined),
                        ),
                        isExpanded: true,
                        items: _effectiveLocations
                            .map(
                              (location) => DropdownMenuItem<String>(
                                value: location.id,
                                child: Text(
                                  loc.deliveryPointOption(
                                    location.name,
                                    location.availableSlots,
                                    location.totalSlots,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          DropLocation? selected;
                          setState(() {
                            _selectedDeliveryId = val;
                            selected = _dropLocationById(val);
                            if (selected != null) {
                              _destCtrl.text = selected!.address;
                            }
                          });
                          if (selected != null) {
                            _snack(
                              loc.deliveryPointSelected(selected!.name),
                              type: AppNotificationType.success,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _destCtrl,
                        decoration: InputDecoration(
                          labelText: loc.destination,
                          prefixIcon: const Icon(Icons.directions_transit),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GradientButton(
                        text: loc.transitRoute,
                        onPressed: _openTransitRoute,
                        leading: const Icon(Icons.directions_transit),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: loc.reservationSectionTitle,
                        subtitle: loc.reservationSectionSubtitle,
                        icon: Icons.apartment_outlined,
                      ),
                      const SizedBox(height: 8),
                      ..._effectiveLocations.map(_buildReservationStatusTile),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: loc.myLuggages,
                        subtitle: loc.luggagesSectionSubtitle,
                        icon: Icons.wallet_travel,
                        action: FilledButton.icon(
                          onPressed: _openAddLuggage,
                          icon: const Icon(Icons.add),
                          label: Text(loc.newLuggageButton),
                        ),
                      ),
                      const SizedBox(height: 16),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          const compactBreakpoint = 520.0;
                          final filterOptions =
                              _luggageFilterOptions(loc);
                          if (constraints.maxWidth <
                              compactBreakpoint) {
                            return Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: filterOptions.map((option) {
                                final isSelected =
                                    _luggageFilter.contains(option.value);
                                return ChoiceChip(
                                  label: Text(option.label),
                                  avatar: Icon(
                                    option.icon,
                                    size: 18,
                                  ),
                                  selected: isSelected,
                                  showCheckmark: false,
                                  onSelected: (_) {
                                    setState(() => _luggageFilter = {
                                          option.value,
                                        });
                                  },
                                );
                              }).toList(),
                            );
                          }
                          return SegmentedButton<_LuggageFilter>(
                            segments: filterOptions
                                .map(
                                  (option) => ButtonSegment(
                                    value: option.value,
                                    label: Text(option.label),
                                    icon: Icon(option.icon),
                                  ),
                                )
                                .toList(),
                            selected: _luggageFilter,
                            onSelectionChanged: (value) {
                              setState(() => _luggageFilter = value);
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _luggageLoading
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 32),
                                child: Center(child: CircularProgressIndicator()),
                              )
                            : _visibleLuggages.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 24),
                                    child: Text(
                                      _luggages.isEmpty
                                          ? loc.luggageEmptyStateNoItems
                                          : loc.luggageEmptyStateFiltered,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                          ),
                                    ),
                                  )
                                : Column(
                                    children: _visibleLuggages
                                        .map(_buildLuggageCard)
                                        .toList(),
                                  ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            _buildMapTab(),
            // === Profil ===
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              child: Column(
                children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        SectionHeader(
                          title: loc.userInfo,
                          subtitle: loc.profileInfoSubtitle,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _userNameCtrl,
                          decoration: InputDecoration(
                            labelText: loc.firstName,
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _userSurnameCtrl,
                          decoration: InputDecoration(
                            labelText: loc.lastName,
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _userPhoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: loc.phone,
                            prefixIcon: const Icon(Icons.phone),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _userEmailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: loc.email,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _userAddressCtrl,
                          decoration: InputDecoration(
                            labelText: loc.address,
                            prefixIcon: const Icon(Icons.home_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          key: ValueKey(_gender),
                          initialValue: _gender,
                          decoration: InputDecoration(
                            labelText: loc.gender,
                            prefixIcon: const Icon(Icons.wc),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: "male",
                              child: Text(loc.genderMale),
                            ),
                            DropdownMenuItem(
                              value: "female",
                              child: Text(loc.genderFemale),
                            ),
                            DropdownMenuItem(
                              value: "none",
                              child: Text(loc.genderUndisclosed),
                            ),
                          ],
                          onChanged: (v) => setState(() => _gender = v ?? 'none'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: loc.emergencyContact,
                          subtitle: loc.emergencySectionSubtitle,
                          icon: Icons.shield_outlined,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _emNameCtrl,
                          decoration: InputDecoration(
                            labelText: loc.firstName,
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _emSurnameCtrl,
                          decoration: InputDecoration(
                            labelText: loc.lastName,
                            prefixIcon: const Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _emPhoneCtrl,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: loc.phone,
                            prefixIcon: const Icon(Icons.phone),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _emEmailCtrl,
                          decoration: InputDecoration(
                            labelText: loc.email,
                            prefixIcon: const Icon(Icons.email_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _emAddressCtrl,
                          decoration: InputDecoration(
                            labelText: loc.address,
                            prefixIcon: const Icon(Icons.home_outlined),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _emRelationCtrl,
                          decoration: InputDecoration(
                            labelText: loc.relationLabel,
                            prefixIcon: const Icon(Icons.handshake_outlined),
                          ),
                        ),
                        if (_currentUser?.emergencyContact != null &&
                            _currentUser!.emergencyContact!.fullName.trim().isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Divider(color: theme.colorScheme.outlineVariant),
                          const SizedBox(height: 12),
                          _InfoRow(
                            icon: Icons.person_outline,
                            label: loc.emergencyRegisteredPerson,
                            value: _currentUser!.emergencyContact!.fullName,
                          ),
                          _InfoRow(
                            icon: Icons.call,
                            label: loc.phone,
                            value: _currentUser!.emergencyContact!.phone,
                          ),
                          _InfoRow(
                            icon: Icons.mail_outline,
                            label: loc.email,
                            value: _currentUser!.emergencyContact!.email,
                          ),
                          _InfoRow(
                            icon: Icons.home_outlined,
                            label: loc.address,
                            value: _currentUser!.emergencyContact!.address,
                          ),
                          _InfoRow(
                            icon: Icons.group_work_outlined,
                            label: loc.relationLabel,
                            value: _currentUser!.emergencyContact!.relation,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: loc.identitySectionTitle,
                          subtitle: loc.identitySectionSubtitle,
                          icon: Icons.verified_user_outlined,
                        ),
                        const SizedBox(height: 12),
                        SegmentedButton<IdentityDocumentType>(
                          segments: IdentityDocumentType.values
                              .map(
                                (type) => ButtonSegment<IdentityDocumentType>(
                                  value: type,
                                  label: Text(type.label(loc)),
                                ),
                              )
                              .toList(),
                          selected: {_identityDocType},
                          onSelectionChanged: (value) {
                            setState(() => _identityDocType = value.first);
                          },
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _hasIdentityProof
                              ? loc.identityUploaded(_identityDocLabel(loc))
                              : loc.identityMissing,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 12),
                        _buildIdentityPreview(),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton.icon(
                              onPressed: () =>
                                  _pickIdentityDocument(_identityDocType, ImageSource.camera),
                              icon: const Icon(Icons.camera_alt),
                              label: Text(loc.identityTakePhoto),
                            ),
                            OutlinedButton.icon(
                              onPressed: () =>
                                  _pickIdentityDocument(_identityDocType, ImageSource.gallery),
                              icon: const Icon(Icons.photo_library_outlined),
                              label: Text(loc.identityPickFromGallery),
                            ),
                            if (_hasIdentityProof)
                              TextButton.icon(
                                onPressed: _clearIdentityDocument,
                                icon: const Icon(Icons.delete_outline),
                                label: Text(loc.identityDelete),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  GradientButton(
                    text: loc.save,
                    onPressed: _savingProfile ? null : _saveProfile,
                    loading: _savingProfile,
                    leading: const Icon(Icons.save_alt),
                  ),
                ],
              ),
            ),

            // === Ayarlar ===
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
              children: [
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: loc.settingsPermissionsTitle,
                        subtitle: loc.settingsPermissionsSubtitle,
                        icon: Icons.verified_user_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildPermissionTile(
                        icon: Icons.camera_alt_outlined,
                        title: loc.cameraPermission,
                        subtitle: loc.cameraPermissionDesc,
                        onRequest: () async {
                          final status = await Permission.camera.request();
                          _handlePermission(
                            _permissionLabel('camera', loc),
                            status,
                          );
                        },
                      ),
                      _buildPermissionTile(
                        icon: Icons.location_on_outlined,
                        title: loc.locationPermission,
                        subtitle: loc.locationPermissionDesc,
                        onRequest: () async {
                          final status = await Permission.location.request();
                          _handlePermission(
                            _permissionLabel('location', loc),
                            status,
                          );
                        },
                      ),
                      _buildPermissionTile(
                        icon: Icons.notifications_active_outlined,
                        title: loc.notificationPermission,
                        subtitle: loc.notificationPermissionDesc,
                        onRequest: () async {
                          final status = await Permission.notification.request();
                          _handlePermission(
                            _permissionLabel('notification', loc),
                            status,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: loc.privacySectionTitle,
                        subtitle: loc.privacySectionSubtitle,
                        icon: Icons.lock_outline,
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(loc.inAppNotifications),
                        value: _inAppNotif,
                        onChanged: (v) => setState(() => _inAppNotif = v),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(loc.notificationSound),
                        value: _notifSound,
                        onChanged: (v) => setState(() => _notifSound = v),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(loc.notificationVibrate),
                        value: _notifVibrate,
                        onChanged: (v) => setState(() => _notifVibrate = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: loc.remindersSectionTitle,
                        subtitle: loc.remindersSectionSubtitle,
                        icon: Icons.notifications_active_outlined,
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(loc.pushRemindersLabel),
                        value: _pushReminderEnabled,
                        onChanged: (value) async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool(_pushReminderPref, value);
                          if (!mounted) return;
                          setState(() => _pushReminderEnabled = value);
                          ReminderService.setPushEnabled(value);
                        },
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(loc.emailRemindersLabel),
                        value: _emailReminderEnabled,
                        onChanged: (value) async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool(_emailReminderPref, value);
                          if (!mounted) return;
                          setState(() => _emailReminderEnabled = value);
                          ReminderService.setEmailEnabled(value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: loc.languageSectionTitle,
                        subtitle: loc.languageSectionSubtitle,
                        icon: Icons.language,
                      ),
                      DropdownButtonFormField<String>(
                        key: ValueKey(_selectedLang),
                        initialValue: _selectedLang,
                        items: [
                          DropdownMenuItem(value: "tr", child: Text(loc.languageNameTr)),
                          DropdownMenuItem(value: "en", child: Text(loc.languageNameEn)),
                          DropdownMenuItem(value: "de", child: Text(loc.languageNameDe)),
                          DropdownMenuItem(value: "es", child: Text(loc.languageNameEs)),
                          DropdownMenuItem(value: "ru", child: Text(loc.languageNameRu)),
                        ],
                        onChanged: (langCode) {
                          if (langCode != null) {
                            setState(() => _selectedLang = langCode);
                            Locale newLocale;
                            switch (langCode) {
                              case "en":
                                newLocale = const Locale("en");
                                break;
                              case "de":
                                newLocale = const Locale("de");
                                break;
                              case "es":
                                newLocale = const Locale("es");
                                break;
                              case "ru":
                                newLocale = const Locale("ru");
                                break;
                              default:
                                newLocale = const Locale("tr");
                            }
                            AppLocale.notifier.value = newLocale;
                            final languageName = _languageNameFor(langCode, loc);
                            _snack(
                              loc.languageChangedTo(languageName),
                              type: AppNotificationType.info,
                            );
                          }
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.translate_outlined),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: loc.account,
                        subtitle: loc.accountSectionSubtitle,
                        icon: Icons.manage_accounts_outlined,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.lock_reset),
                        title: Text(loc.changePassword),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ChangePasswordPage(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.logout),
                        title: Text(loc.logout),
                        onTap: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(loc.logoutDialogTitle),
                              content: Text(loc.logoutDialogMessage),
                              actions: [
                                TextButton(
                                  child: Text(loc.dialogDismiss),
                                  onPressed: () => Navigator.pop(context, false),
                                ),
                                TextButton(
                                  child: Text(loc.dialogConfirm),
                                  onPressed: () => Navigator.pop(context, true),
                                ),
                              ],
                            ),
                          );

                          if (confirm == true) {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.remove("userId");
                            _snack(loc.logoutSuccess,
                                type: AppNotificationType.success);

                            if (context.mounted) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                '/login',
                                (Route<dynamic> route) => false,
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Column(
                    children: [
                      Text(
                        loc.footerCopyright,
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== Permission Helper =====
  Widget _buildPermissionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onRequest,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: ElevatedButton(
        onPressed: onRequest,
        child: Text(AppLocalizations.of(context)!.permissionManageButton),
      ),
    );
  }

  void _handlePermission(String name, PermissionStatus status) {
    final loc = AppLocalizations.of(context)!;
    if (status.isGranted) {
      _snack(loc.permissionGranted(name), type: AppNotificationType.success);
    } else if (status.isDenied) {
      _snack(loc.permissionDenied(name), type: AppNotificationType.error);
    } else if (status.isPermanentlyDenied) {
      _snack(loc.permissionDeniedForever(name),
          type: AppNotificationType.warning);
      openAppSettings();
    }
  }
}

// ==== Helperlar ====
enum _RouteMode { walking, transit, driving }

enum _QrAction { drop, pickup }

enum _LuggageFilter { all, awaiting, stored, picked }

class _LuggageFilterOption {
  const _LuggageFilterOption({
    required this.value,
    required this.label,
    required this.icon,
  });

  final _LuggageFilter value;
  final String label;
  final IconData icon;
}

enum IdentityDocumentType { idCard, passport }

extension IdentityDocumentTypeExtension on IdentityDocumentType {
  String label(AppLocalizations loc) {
    switch (this) {
      case IdentityDocumentType.idCard:
        return loc.identityDocIdCard;
      case IdentityDocumentType.passport:
        return loc.identityDocPassport;
    }
  }

  static IdentityDocumentType? fromName(String? name) {
    if (name == null) return null;
    for (final type in IdentityDocumentType.values) {
      if (type.name == name) return type;
    }
    return null;
  }
}

class _DashboardMetricTile extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const _DashboardMetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: theme.colorScheme.surface.withValues(alpha: 0.9),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$value',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  Text(
                    label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===== QR ve Luggage Ekranları =====
class QrPreviewPage extends StatelessWidget {
  final LuggageModel luggage;
  final String? pickupPin;

  const QrPreviewPage({
    super.key,
    required this.luggage,
    this.pickupPin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final infoItems = <String>[];
    if ((luggage.size ?? '').isNotEmpty) {
      infoItems.add(
        loc.luggageInfoSize(_localizedSizeLabel(luggage.size, loc)),
      );
    }
    if ((luggage.weight ?? '').isNotEmpty) {
      infoItems.add(loc.luggageInfoWeight(luggage.weight ?? ''));
    }
    if ((luggage.color ?? '').isNotEmpty) {
      infoItems.add(
        loc.luggageInfoColor(_localizedColorLabel(luggage.color, loc)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(luggage.displayLabel),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: 260,
                  height: 260,
                  child: QrImageView(
                    data: luggage.qrCode,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SelectableText(
                luggage.qrCode,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              if (infoItems.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(infoItems.join(' · '), style: theme.textTheme.bodyMedium),
              ],
              if ((luggage.note ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(loc.noteLabel(luggage.note ?? ''),
                    style: theme.textTheme.bodySmall),
              ],
              if ((pickupPin ?? '').isNotEmpty) ...[
                const SizedBox(height: 20),
                SectionCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loc.pickupPinTitle,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SelectableText(
                        pickupPin!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        loc.pickupPinSafetyWarning,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: pickupPin!));
                          AppNotification.show(
                            context,
                            message: loc.pickupPinCopiedMessage,
                            type: AppNotificationType.success,
                          );
                        },
                        icon: const Icon(Icons.copy),
                        label: Text(loc.copy),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: luggage.qrCode));
                  AppNotification.show(
                    context,
                    message: loc.qrCopied,
                    type: AppNotificationType.success,
                  );
                },
                icon: const Icon(Icons.copy),
                label: Text(loc.qrCopyCode),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  final text = 'Bavul QR Kodu: ${luggage.qrCode}';
                  Clipboard.setData(ClipboardData(text: text));
                  AppNotification.show(
                    context,
                    message: loc.qrTextCopied,
                    type: AppNotificationType.success,
                  );
                },
                icon: const Icon(Icons.print_outlined),
                label: Text(loc.qrCopyPrintable),
              ),
              const SizedBox(height: 24),
              _InfoRow(
                icon: Icons.info_outline,
                label: loc.statusLabel,
                value: luggage.statusLabel,
              ),
              const SizedBox(height: 8),
              Text(
                loc.createdAtLabel(
                  DateFormat('dd.MM.yyyy HH:mm').format(luggage.createdAt.toLocal()),
                ),
                style: theme.textTheme.bodySmall,
              ),
              if (luggage.dropConfirmedAt != null)
                Text(
                  loc.dropConfirmedAtLabel(
                    DateFormat('dd.MM.yyyy HH:mm')
                        .format(luggage.dropConfirmedAt!.toLocal()),
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              if (luggage.pickupConfirmedAt != null)
                Text(
                  loc.pickupConfirmedAtLabel(
                    DateFormat('dd.MM.yyyy HH:mm')
                        .format(luggage.pickupConfirmedAt!.toLocal()),
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              const SizedBox(height: 12),
              Text(
                loc.qrShareInstructions,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddLuggagePage extends StatefulWidget {
  final String userId;
  final String Function() qrGenerator;
  final String Function() pickupPinGenerator;
  const AddLuggagePage({
    required this.userId,
    required this.qrGenerator,
    required this.pickupPinGenerator,
    super.key,
  });

  @override
  State<AddLuggagePage> createState() => _AddLuggagePageState();
}

class _AddLuggagePageState extends State<AddLuggagePage> {
  late String _qrCode;
  late String _pickupPin;
  final _labelCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _size = 'Orta';
  String _color = 'Siyah';
  bool _saving = false;
  late DropLocation _selectedLocation;
  final List<DropLocation> _availableLocations = DropLocationsRepository.locations;
  final List<DropLocation> _nearbySuggestions = [];
  bool _loadingNearby = false;
  String? _nearbyError;
  DateTime? _dropTime;
  DateTime? _pickupTime;
  bool _scheduleError = false;


  List<DropLocation> _nearestLocations(LatLng target, {int limit = 3}) {
    final sorted = List<DropLocation>.from(_availableLocations)
      ..sort((a, b) =>
          _distanceBetween(a.position, target).compareTo(_distanceBetween(b.position, target)));
    return sorted.take(limit).toList();
  }

  double _distanceBetween(LatLng a, LatLng b) {
    const earthRadius = 6371;
    final dLat = _degToRad(b.latitude - a.latitude);
    final dLon = _degToRad(b.longitude - a.longitude);
    final lat1 = _degToRad(a.latitude);
    final lat2 = _degToRad(b.latitude);
    final hav = (sin(dLat / 2) * sin(dLat / 2)) +
        (sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2));
    final c = 2 * atan2(sqrt(hav), sqrt(1 - hav));
    return earthRadius * c;
  }

  double _degToRad(double deg) => deg * (pi / 180);

  @override
  void initState() {
    super.initState();
    _qrCode = widget.qrGenerator();
    _pickupPin = widget.pickupPinGenerator();
    _selectedLocation = _availableLocations.first;
    _loadNearbySuggestions();
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _weightCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _storePickupPin(String luggageId, String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_pickupPinStoragePrefix$luggageId', pin);
  }

  Future<void> _loadNearbySuggestions() async {
    setState(() {
      _loadingNearby = true;
      _nearbyError = null;
    });
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        if (!mounted) return;
        final loc = AppLocalizations.of(context)!;
        setState(() {
          _nearbyError = loc.locationPermissionDenied;
          _loadingNearby = false;
        });
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final latLng = LatLng(position.latitude, position.longitude);
      final nearest = _nearestLocations(latLng, limit: 2);
      if (!mounted) return;
      setState(() {
        _nearbySuggestions
          ..clear()
          ..addAll(nearest);
        _loadingNearby = false;
      });
    } catch (e) {
      if (!mounted) return;
      final loc = AppLocalizations.of(context)!;
      setState(() {
        _loadingNearby = false;
        _nearbyError = loc.locationFailedWithDetails('$e');
      });
    }
  }

  void _regenerateQr() {
    setState(() => _qrCode = widget.qrGenerator());
  }

  Future<void> _pickSchedule({required bool isDrop}) async {
    final loc = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final initial = isDrop
        ? (_dropTime ?? now.add(const Duration(hours: 2)))
        : (_pickupTime ?? now.add(const Duration(hours: 6)));
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      helpText: isDrop ? loc.dropDatePickerHelp : loc.pickupDatePickerHelp,
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    if (!mounted) return;
    final scheduled = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    setState(() {
      if (isDrop) {
        _dropTime = scheduled;
      } else {
        _pickupTime = scheduled;
      }
      _scheduleError = false;
    });
  }

  Future<void> _submit() async {
    final loc = AppLocalizations.of(context)!;
    if (_dropTime == null || _pickupTime == null) {
      setState(() => _scheduleError = true);
      AppNotification.show(
        context,
        message: loc.scheduleTimesRequired,
        type: AppNotificationType.warning,
      );
      return;
    }
    if (_saving) return;
    setState(() {
      _saving = true;
      _scheduleError = false;
    });
    try {
      final payload = {
        'qrCode': _qrCode,
        'label': _labelCtrl.text.trim(),
        'weight': _weightCtrl.text.trim(),
        'size': _size,
        'color': _color,
        'note': _noteCtrl.text.trim(),
        'status': luggageStatusAwaitingDrop,
        'dropLocationId': _selectedLocation.id,
        'dropLocationName': _selectedLocation.name,
        'scheduledDropTime': _dropTime?.toIso8601String(),
        'scheduledPickupTime': _pickupTime?.toIso8601String(),
      };

      final result = await ApiService.createLuggage(widget.userId, payload);
      if (!mounted) return;
      if (result['ok'] == true && result['luggage'] is Map<String, dynamic>) {
        final luggage = LuggageModel.fromJson(
          Map<String, dynamic>.from(result['luggage'] as Map),
        );
        final pickupPin = (result['pickupPin'] ?? '').toString().trim();
        final effectivePin = pickupPin.isNotEmpty ? pickupPin : _pickupPin;
        if (effectivePin.isNotEmpty && mounted) {
          final id = luggage.id?.toString();
if (id == null || id.isEmpty) {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Valiz ID bulunamadı, PIN kaydedilemedi.')),
    );
  }
  return;
}
await _storePickupPin(id, effectivePin);

          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(loc.pickupPinTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    loc.pickupPinGenerated(effectivePin),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.pickupPinSafetyWarning,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant,
                        ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: effectivePin));
                    AppNotification.show(
                      context,
                      message: loc.pickupPinCopiedMessage,
                      type: AppNotificationType.success,
                    );
                  },
                  child: Text(loc.copy),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text(loc.dialogDismiss),
                ),
              ],
            ),
          );
        }
        final enriched = luggage.copyWith(
          qrCode: _qrCode,
          dropLocationId: luggage.dropLocationId.isNotEmpty
              ? luggage.dropLocationId
              : _selectedLocation.id,
          dropLocationName: luggage.dropLocationName.isNotEmpty
              ? luggage.dropLocationName
              : _selectedLocation.name,
        );
        Navigator.pop(context, enriched);
      } else {
        final message = (result['error'] ?? '').toString().trim();
        final statusCode = (result['statusCode'] ?? 0) as int;
        final lower = message.toLowerCase();
        if (statusCode == 409 || lower.contains('duplicate') || lower.contains('qr')) {
          _regenerateQr();
          AppNotification.show(
            context,
            message: loc.qrDuplicateWarning,
            type: AppNotificationType.warning,
          );
        } else {
          AppNotification.show(
            context,
            message: message.isNotEmpty ? message : loc.luggageCreateFailed,
            type: AppNotificationType.error,
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.genericErrorWithDetails('$e'),
        type: AppNotificationType.error,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.addLuggageTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      QrImageView(
                        data: _qrCode,
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 12),
                      SelectableText(
                        _qrCode,
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: _saving
                                ? null
                                : () {
                                    Clipboard.setData(
                                      ClipboardData(text: _qrCode),
                                    );
                                    AppNotification.show(
                                      context,
                                      message: loc.qrCopied,
                                      type: AppNotificationType.success,
                                    );
                                  },
                            icon: const Icon(Icons.copy),
                            label: Text(loc.qrCopyCode),
                          ),
                          OutlinedButton.icon(
                            onPressed: _saving ? null : _regenerateQr,
                            icon: const Icon(Icons.refresh),
                            label: Text(loc.qrRegenerate),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _labelCtrl,
                decoration: InputDecoration(
                  labelText: loc.luggageNameHint,
                  prefixIcon: const Icon(Icons.badge_outlined),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _weightCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText: loc.weight,
                  prefixIcon: const Icon(Icons.scale),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey('size_$_size'),
                initialValue: _size,
                items: ['Küçük', 'Orta', 'Büyük']
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_localizedSizeLabel(value, loc)),
                      ),
                    )
                    .toList(),
                onChanged:
                    _saving ? null : (v) => setState(() => _size = v ?? 'Orta'),
                decoration: InputDecoration(
                  labelText: loc.size,
                  prefixIcon: const Icon(Icons.luggage_outlined),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey('color_$_color'),
                initialValue: _color,
                items: ['Siyah', 'Gri', 'Kırmızı', 'Mavi', 'Yeşil', 'Diğer']
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_localizedColorLabel(value, loc)),
                      ),
                    )
                    .toList(),
                onChanged: _saving
                    ? null
                    : (v) => setState(() => _color = v ?? 'Siyah'),
                decoration: InputDecoration(
                  labelText: loc.color,
                  prefixIcon: const Icon(Icons.palette_outlined),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                key: ValueKey(_selectedLocation.id),
                initialValue: _selectedLocation.id,
                decoration: InputDecoration(
                  labelText: loc.deliveryPointLabel,
                  prefixIcon: const Icon(Icons.location_on_outlined),
                ),
                items: _availableLocations
                    .map(
                      (location) => DropdownMenuItem<String>(
                        value: location.id,
                        child: Text(
                          loc.deliveryPointOption(
                            location.name,
                            location.availableSlots,
                            location.totalSlots,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: _saving
                    ? null
                    : (value) {
                        final match = DropLocationsRepository.byId(value);
                        if (match != null) {
                          setState(() => _selectedLocation = match);
                        }
                      },
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _selectedLocation.address,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              if (_nearbyError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _nearbyError!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ],
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: _loadingNearby ? null : _loadNearbySuggestions,
                  icon: _loadingNearby
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.my_location),
                  label: Text(
                    _loadingNearby
                        ? loc.locationFetching
                        : loc.refreshNearbyButton,
                  ),
                ),
              ),
              if (_nearbySuggestions.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              loc.nearbyLocationsTitle,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: _loadingNearby ? null : _loadNearbySuggestions,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ..._nearbySuggestions.map(
                          (location) => ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(location.name),
                            subtitle: Text(
                              loc.availableSlotsLabel(
                                location.availableSlots,
                                location.totalSlots,
                              ),
                            ),
                            trailing: TextButton(
                              onPressed: () {
                                setState(() => _selectedLocation = location);
                              },
                              child: Text(loc.commonSelect),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.event_available),
                      title: Text(
                        _dropTime == null
                            ? loc.dropTimePending
                            : loc.dropTimeLabel(
                                DateFormat('dd MMM HH:mm')
                                    .format(_dropTime!.toLocal()),
                              ),
                      ),
                      trailing: TextButton(
                        onPressed: () => _pickSchedule(isDrop: true),
                        child: Text(loc.commonSelect),
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.event),
                      title: Text(
                        _pickupTime == null
                            ? loc.pickupTimePending
                            : loc.pickupTimeLabel(
                                DateFormat('dd MMM HH:mm')
                                    .format(_pickupTime!.toLocal()),
                              ),
                      ),
                      trailing: TextButton(
                        onPressed: () => _pickSchedule(isDrop: false),
                        child: Text(loc.commonSelect),
                      ),
                    ),
                  ],
                ),
              ),
              if (_scheduleError) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.redAccent, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        loc.scheduleTimesRequired,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              TextField(
                controller: _noteCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: loc.note,
                  hintText: loc.notesHint,
                  prefixIcon: const Icon(Icons.sticky_note_2_outlined),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _saving ? null : _submit,
                icon: _saving
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_alt),
                label: Text(_saving ? loc.savingInProgress : loc.save),
              ),
              const SizedBox(height: 12),
              Text(
                loc.luggageRegistrationNote,
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrScanPage extends StatefulWidget {
  final String expectedCode;
  final String title;

  const _QrScanPage({
    required this.expectedCode,
    required this.title,
  });

  @override
  State<_QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<_QrScanPage> {
  bool _processing = false;
  final TextEditingController _manualController = TextEditingController();
  String? _manualError;

  @override
  void dispose() {
    _manualController.dispose();
    super.dispose();
  }

  void _submitManualCode() {
    final loc = AppLocalizations.of(context)!;
    final expected = widget.expectedCode.trim();
    final value = _manualController.text.trim();
    if (value.isEmpty) {
      setState(() => _manualError = loc.qrEmptyError);
      return;
    }
    if (value != expected) {
      setState(() => _manualError = loc.qrMismatchMessage);
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final manualHint = loc.qrManualEntryHint;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: MobileScannerController(returnImage: false),
            onDetect: (capture) async {
              if (_processing) return;
              final navigator = Navigator.of(context);
              final expected = widget.expectedCode.trim();
              final overlayContext = context;
              for (final barcode in capture.barcodes) {
                final code = barcode.rawValue;
                if (code == null) continue;
                _processing = true;
                final trimmed = code.trim();
                if (trimmed == expected) {
                  if (await Vibration.hasVibrator() ?? false) {
                    await Vibration.vibrate(duration: 150);
                  }
                  if (!mounted) return;
                  navigator.pop(trimmed);
                  return;
                } else {
                  if (!mounted) return;
                  AppNotification.show(overlayContext,
                      message: loc.qrMismatchMessage,
                      type: AppNotificationType.warning);
                  _processing = false;
                }
              }
            },
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: theme.colorScheme.surface,
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            manualHint,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _manualController,
                            decoration: InputDecoration(
                              labelText: loc.qrCode,
                              errorText: _manualError,
                              filled: true,
                            ),
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.done,
                            onChanged: (_) {
                              if (_manualError != null) {
                                setState(() => _manualError = null);
                              }
                            },
                            onSubmitted: (_) => _submitManualCode(),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              onPressed: _submitManualCode,
                              icon: const Icon(Icons.check_circle_outline),
                              label: Text(loc.qrVerifyButton),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    loc.qrScanTip,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).pop(),
        label: Text(loc.dialogDismiss),
        icon: const Icon(Icons.close),
      ),
    );
  }
}
class _ActionTextButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _ActionTextButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _ActionFilledButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const _ActionFilledButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

String _localizedSizeLabel(String? raw, AppLocalizations loc) {
  final normalized = raw?.toLowerCase().trim();
  switch (normalized) {
    case 'küçük':
    case 'kucuk':
    case 'small':
      return loc.small;
    case 'orta':
    case 'medium':
      return loc.medium;
    case 'büyük':
    case 'buyuk':
    case 'large':
      return loc.large;
    default:
      return raw ?? '';
  }
}

String _localizedColorLabel(String? raw, AppLocalizations loc) {
  final normalized = raw?.toLowerCase().trim();
  switch (normalized) {
    case 'siyah':
    case 'black':
      return loc.black;
    case 'gri':
    case 'gray':
    case 'grey':
      return loc.grey;
    case 'kırmızı':
    case 'kirmizi':
    case 'red':
      return loc.red;
    case 'mavi':
    case 'blue':
      return loc.blue;
    case 'yeşil':
    case 'yesil':
    case 'green':
      return loc.green;
    case 'diğer':
    case 'diger':
    case 'other':
      return loc.other;
    default:
      return raw ?? '';
  }
}
