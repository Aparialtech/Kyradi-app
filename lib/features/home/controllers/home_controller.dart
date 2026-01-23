import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kyradi_app/models/user.dart';
import 'package:kyradi_app/models/luggage.dart';
import 'package:kyradi_app/core/drop_locations.dart';
import 'package:kyradi_app/services/api_service.dart';
import 'package:kyradi_app/services/luggage_service.dart';
import 'package:kyradi_app/services/locations_service.dart';
import 'package:kyradi_app/services/reminder_service.dart';
import 'package:kyradi_app/features/home/models/identity_document_type.dart';

class HomeController extends ChangeNotifier {
  HomeController();

  String? userId;
  UserModel? currentUser;
  final List<LuggageModel> luggages = [];
  final List<DropLocation> locations =
      List<DropLocation>.from(DropLocationsRepository.locations);

  bool locationsLoading = false;
  bool luggageLoading = false;
  bool savingProfile = false;

  Uint8List? identityDocPreview;
  String? identityDocFileName;
  String? identityDocUrl;
  IdentityDocumentType identityDocType = IdentityDocumentType.idCard;

  bool pushReminderEnabled = true;
  bool emailReminderEnabled = true;

  final ImagePicker imagePicker = ImagePicker();

  Future<void> loadLocations() async {
    locationsLoading = true;
    notifyListeners();
    try {
      final remote = await LocationsService.fetchLocations();
      locations
        ..clear()
        ..addAll(remote.isNotEmpty
            ? remote
            : DropLocationsRepository.locations);
    } finally {
      locationsLoading = false;
      notifyListeners();
    }
  }

  Future<void> restoreUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
  }

  Future<Map<String, dynamic>> loadProfile(String userId) async {
    final result = await ApiService.getProfile(userId);
    if (result['ok'] == true) {
      final rawProfile = result['profile'] ?? result['data'] ?? result;
      if (rawProfile is Map<String, dynamic>) {
        currentUser = UserModel.fromJson(Map<String, dynamic>.from(rawProfile));
        identityDocUrl = currentUser?.identityDocumentUrl;
        pushReminderEnabled = currentUser?.pushReminderEnabled ?? true;
        emailReminderEnabled = currentUser?.emailReminderEnabled ?? true;
      }
    }
    notifyListeners();
    return result;
  }

  Future<void> loadUserLuggages(String userId) async {
    luggageLoading = true;
    notifyListeners();
    try {
      final loaded = await LuggageService.getUserLuggages(userId);
      luggages
        ..clear()
        ..addAll(loaded);
    } finally {
      luggageLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> saveProfile(String userId, Map<String, dynamic> body) async {
    savingProfile = true;
    notifyListeners();
    try {
      return await ApiService.updateProfile(userId, body);
    } finally {
      savingProfile = false;
      notifyListeners();
    }
  }

  Future<void> loadIdentityProof() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString('identity_doc_bytes');
    Uint8List? bytes;
    if (encoded != null && encoded.isNotEmpty) {
      try {
        bytes = base64Decode(encoded);
      } catch (_) {
        bytes = null;
      }
    }
    identityDocPreview = bytes;
    identityDocFileName = prefs.getString('identity_doc_path');
    final storedType = prefs.getString('identity_doc_type');
    identityDocType =
        IdentityDocumentTypeExtension.fromName(storedType) ??
            IdentityDocumentType.idCard;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> pickIdentityDocument({
    required IdentityDocumentType type,
    required ImageSource source,
  }) async {
    final file = await imagePicker.pickImage(
      source: source,
      imageQuality: 70,
    );
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('identity_doc_bytes', base64Encode(bytes));
    await prefs.setString(
      'identity_doc_path',
      file.name.isNotEmpty ? file.name : file.path,
    );
    await prefs.setString('identity_doc_type', type.name);

    identityDocPreview = bytes;
    identityDocFileName = file.name.isNotEmpty ? file.name : file.path;
    identityDocType = type;
    notifyListeners();

    if (userId == null || userId!.isEmpty) return null;
    final uploadResult = await ApiService.uploadIdentityDocument(
      bytes: bytes,
      filename: file.name.isNotEmpty
          ? file.name
          : 'identity_${DateTime.now().millisecondsSinceEpoch}.jpg',
    );
    if (uploadResult['ok'] == true && uploadResult['fileUrl'] != null) {
      identityDocUrl = uploadResult['fileUrl'].toString();
      notifyListeners();
    }
    return uploadResult;
  }

  Future<void> clearIdentityDocument() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('identity_doc_bytes');
    await prefs.remove('identity_doc_path');
    await prefs.remove('identity_doc_type');
    identityDocPreview = null;
    identityDocFileName = null;
    identityDocUrl = null;
    notifyListeners();
  }

  Future<void> loadReminderPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final push = prefs.getBool('pref_push_reminder');
    final email = prefs.getBool('pref_email_reminder');
    if (push != null) pushReminderEnabled = push;
    if (email != null) emailReminderEnabled = email;
    ReminderService.setPushEnabled(pushReminderEnabled);
    ReminderService.setEmailEnabled(emailReminderEnabled);
    notifyListeners();
  }

  Future<void> updatePushReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_push_reminder', value);
    pushReminderEnabled = value;
    ReminderService.setPushEnabled(value);
    notifyListeners();
  }

  Future<void> updateEmailReminder(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pref_email_reminder', value);
    emailReminderEnabled = value;
    ReminderService.setEmailEnabled(value);
    notifyListeners();
  }

  void setIdentityDocType(IdentityDocumentType type) {
    identityDocType = type;
    notifyListeners();
  }

  void upsertLuggage(LuggageModel luggage) {
    luggages.removeWhere((item) => item.id == luggage.id);
    luggages.insert(0, luggage);
    notifyListeners();
  }
}
