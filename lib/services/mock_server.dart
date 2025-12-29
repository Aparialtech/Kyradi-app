import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../core/drop_locations.dart';

class MockServer {
  MockServer._();

  static const _storageKey = 'mock_server_state_v1';
  static const _statusAwaitingDrop = 'awaiting_drop';
  static const _statusDropped = 'dropped';
  static const _statusPickedUp = 'picked_up';

  static Future<Map<String, dynamic>> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) {
      return {
        'nextUserId': 1,
        'users': <Map<String, dynamic>>[],
      };
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        final users = (decoded['users'] as List<dynamic>? ?? [])
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
        for (final user in users) {
          _ensureLuggageList(user);
        }
        decoded['users'] = users;
        decoded['nextUserId'] = decoded['nextUserId'] ?? 1;
        return decoded;
      }
    } catch (_) {/* ignore */}
    return {
      'nextUserId': 1,
      'users': <Map<String, dynamic>>[],
    };
  }

  static Future<void> _saveState(Map<String, dynamic> state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(state));
  }

  static Map<String, dynamic>? _findUser(
    List<Map<String, dynamic>> users,
    bool Function(Map<String, dynamic>) test,
  ) {
    for (final user in users) {
      if (test(user)) return user;
    }
    return null;
  }

  static List<Map<String, dynamic>> _ensureLuggageList(
    Map<String, dynamic> user,
  ) {
    final raw = user['luggages'];
    if (raw is List) {
      final list = raw
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
      user['luggages'] = list;
      return list;
    }
    final list = <Map<String, dynamic>>[];
    user['luggages'] = list;
    return list;
  }

  static Map<String, dynamic> _exposeUser(Map<String, dynamic> user) {
    final copy = Map<String, dynamic>.from(user);
    copy.remove('password');
    copy['luggages'] = _ensureLuggageList(user)
        .map((l) => _exposeLuggage(l))
        .toList();
    return copy;
  }

  static Map<String, dynamic> _exposeLuggage(Map<String, dynamic> luggage) {
    final copy = Map<String, dynamic>.from(luggage);
    return copy;
  }

  static Future<Map<String, dynamic>> register(
    Map<String, dynamic> data,
  ) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final email = (data['email'] ?? '').toString().trim().toLowerCase();

    final exists = _findUser(
      users,
      (u) => (u['email'] ?? '').toString().toLowerCase() == email,
    );
    if (exists != null) {
      return {
        'ok': false,
        'statusCode': 409,
        'error': 'Bu e-posta adresi zaten kayıtlı (demo)',
      };
    }

    final id = (state['nextUserId'] as int?) ?? 1;
    state['nextUserId'] = id + 1;

    final newUser = <String, dynamic>{
      'id': id.toString(),
      'name': data['name'] ?? '',
      'surname': data['surname'] ?? '',
      'email': email,
      'tc': data['tc'] ?? '',
      'phone': data['phone'] ?? '',
      'password': (data['password'] ?? '').toString(),
      'birthDate': data['birthDate'],
      'gender': data['gender'] ?? 'none',
      'verified': true,
      'address': '',
      'emergency': <String, dynamic>{
        'name': '',
        'surname': '',
        'phone': '',
        'email': '',
        'address': '',
      },
      'luggages': <Map<String, dynamic>>[],
    };

    users.add(newUser);
    state['users'] = users;
    await _saveState(state);

    return {
      'ok': true,
      'statusCode': 200,
      'profile': _exposeUser(newUser),
      'message': 'Demo ortamında kullanıcı kaydedildi.',
    };
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final normalized = email.trim().toLowerCase();

    final user = _findUser(
      users,
      (u) => (u['email'] ?? '').toString().toLowerCase() == normalized,
    );

    if (user == null) {
      return {
        'ok': false,
        'statusCode': 401,
        'error': 'Demo ortamında eşleşen kullanıcı bulunamadı',
      };
    }
    if ((user['password'] ?? '') != password) {
      return {
        'ok': false,
        'statusCode': 401,
        'error': 'Şifre hatalı (demo)',
      };
    }
    return {
      'ok': true,
      'statusCode': 200,
      'profile': _exposeUser(user),
      'message': 'Demo oturum açıldı',
    };
  }

  static Future<Map<String, dynamic>> socialLogin(
    String provider,
    String idToken,
  ) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final email = '${provider}_demo@kyradi.com';
    var user = _findUser(
      users,
      (u) => (u['email'] ?? '').toString().toLowerCase() == email,
    );
    if (user == null) {
      final id = (state['nextUserId'] as int?) ?? 1;
      state['nextUserId'] = id + 1;
      user = <String, dynamic>{
        'id': id.toString(),
        'name': 'KYRADI',
        'surname': 'Demo',
        'email': email,
        'phone': '',
        'password': '',
        'verified': true,
        'luggages': <Map<String, dynamic>>[],
      };
      users.add(user);
      state['users'] = users;
      await _saveState(state);
    }
    return {
      'ok': true,
      'statusCode': 200,
      'profile': _exposeUser(user),
      'message': 'Demo sosyal giriş',
    };
  }

  static Future<Map<String, dynamic>> verifyCode(
    String email,
    String code,
  ) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final user = _findUser(
      users,
      (u) => (u['email'] ?? '').toString().toLowerCase() == email.toLowerCase(),
    );
    if (user == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo kullanıcısı bulunamadı',
      };
    }
    user['verified'] = true;
    await _saveState(state);
    return {
      'ok': true,
      'statusCode': 200,
      'message': 'Demo ortamında kullanıcı doğrulandı',
    };
  }

  static Future<Map<String, dynamic>> resendCode(String email) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final user = _findUser(
      users,
      (u) => (u['email'] ?? '').toString().toLowerCase() == email.toLowerCase(),
    );
    if (user == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo kullanıcısı bulunamadı',
      };
    }
    return {
      'ok': true,
      'statusCode': 200,
      'message': 'Demo doğrulama kodu gönderildi (varsayılan 000000)',
    };
  }

  static Future<Map<String, dynamic>> forgot(String email) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final user = _findUser(
      users,
      (u) => (u['email'] ?? '').toString().toLowerCase() == email.toLowerCase(),
    );
    if (user == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo kullanıcısı bulunamadı',
      };
    }
    return {
      'ok': true,
      'statusCode': 200,
      'message': 'Demo ortamında sıfırlama kodu gönderildi (000000)',
    };
  }

  static Future<Map<String, dynamic>> reset(
    String email,
    String code,
    String newPassword,
  ) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final user = _findUser(
      users,
      (u) => (u['email'] ?? '').toString().toLowerCase() == email.toLowerCase(),
    );
    if (user == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo kullanıcısı bulunamadı',
      };
    }
    user['password'] = newPassword;
    await _saveState(state);
    return {
      'ok': true,
      'statusCode': 200,
      'message': 'Demo ortamında şifre güncellendi',
    };
  }

  static Future<Map<String, dynamic>> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final user = _findUser(users, (u) => u['id'].toString() == userId);
    if (user == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo kullanıcısı bulunamadı',
      };
    }
    if ((user['password'] ?? '') != oldPassword) {
      return {
        'ok': false,
        'statusCode': 403,
        'error': 'Mevcut şifre eşleşmiyor (demo)',
      };
    }
    user['password'] = newPassword;
    await _saveState(state);
    return {
      'ok': true,
      'statusCode': 200,
      'message': 'Demo ortamında şifre değiştirildi',
    };
  }

  static Future<Map<String, dynamic>> getLocations() async {
    final locations = DropLocationsRepository.locations
        .map(
          (loc) => {
            'id': loc.id,
            'name': loc.name,
            'address': loc.address,
            'latitude': loc.position.latitude,
            'longitude': loc.position.longitude,
            'totalSlots': loc.totalSlots,
            'availableSlots': loc.availableSlots,
            'usedSlots': loc.usedSlots,
            'maxCapacity': loc.maxCapacity,
            'currentOccupancy': loc.currentOccupancy,
            'openingHours': loc.openingHours.map(
              (key, value) => MapEntry(
                key,
                value.map((range) => range.toJson()).toList(),
              ),
            ),
            'timezone': loc.timezone,
            'isActive': loc.isActive,
          },
        )
        .toList();
    return {
      'ok': true,
      'statusCode': 200,
      'locations': locations,
    };
  }

  static Future<Map<String, dynamic>> getProfile(String userId) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final user = _findUser(users, (u) => u['id'].toString() == userId);
    if (user == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo kullanıcısı bulunamadı',
      };
    }
    return {
      'ok': true,
      'statusCode': 200,
      'profile': _exposeUser(user),
    };
  }

  static Future<Map<String, dynamic>> updateProfile(
    String userId,
    Map<String, dynamic> body,
  ) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final user = _findUser(users, (u) => u['id'].toString() == userId);
    if (user == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo kullanıcısı bulunamadı',
      };
    }

    user['name'] = body['name'] ?? user['name'];
    user['surname'] = body['surname'] ?? user['surname'];
    user['email'] = (body['email'] ?? user['email']).toString().toLowerCase();
    user['phone'] = body['phone'] ?? user['phone'];
    user['address'] = body['address'] ?? user['address'];
    user['gender'] = body['gender'] ?? user['gender'];
    user['emergency'] = Map<String, dynamic>.from(
      body['emergency'] as Map<String, dynamic>? ??
          (user['emergency'] as Map<String, dynamic>? ?? {}),
    );

    await _saveState(state);
    return {
      'ok': true,
      'statusCode': 200,
      'profile': _exposeUser(user),
      'message': 'Profil demo ortamında güncellendi',
    };
  }

  static Future<Map<String, dynamic>> getUserLuggages(String userId) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final user = _findUser(users, (u) => u['id'].toString() == userId);
    if (user == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo kullanıcısı bulunamadı',
      };
    }
    final luggages = _ensureLuggageList(user);
    return {
      'ok': true,
      'statusCode': 200,
      'luggages': luggages.map(_exposeLuggage).toList(),
    };
  }

  static Future<Map<String, dynamic>> health() async {
    return {
      'ok': true,
      'statusCode': 200,
      'message': 'Demo backend aktif',
    };
  }

  static Future<Map<String, dynamic>> createLuggage(
    String userId,
    Map<String, dynamic> payload,
  ) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final user = _findUser(users, (u) => u['id'].toString() == userId);
    if (user == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo kullanıcısı bulunamadı',
      };
    }

    final luggages = _ensureLuggageList(user);
    final now = DateTime.now().toIso8601String();
    final id = payload['id']?.toString().trim().isNotEmpty == true
        ? payload['id'].toString()
        : 'lg-${DateTime.now().millisecondsSinceEpoch}';
    final qr = (payload['qrCode'] ?? payload['qr'] ?? '').toString().trim();
    if (qr.isEmpty) {
      return {
        'ok': false,
        'statusCode': 400,
        'error': 'Demo: QR kodu boş olamaz',
      };
    }

    final exists = luggages.any(
      (l) => (l['qrCode'] ?? '').toString().toLowerCase() == qr.toLowerCase(),
    );
    if (exists) {
      return {
        'ok': false,
        'statusCode': 409,
        'error': 'Demo: Bu QR zaten kayıtlı',
      };
    }

    final newLuggage = <String, dynamic>{
      'id': id,
      'qrCode': qr,
      'label': (payload['label'] ?? 'Bavul').toString(),
      'weight': (payload['weight'] ?? '').toString(),
      'size': (payload['size'] ?? '').toString(),
      'color': (payload['color'] ?? '').toString(),
      'note': (payload['note'] ?? '').toString(),
      'status': payload['status']?.toString() ?? _statusAwaitingDrop,
      'dropLocationId': payload['dropLocationId'],
      'dropLocationName': payload['dropLocationName'] ?? '',
      'createdAt': now,
      'updatedAt': now,
      'dropConfirmedAt': null,
      'pickupConfirmedAt': null,
      'scheduledDropTime': payload['scheduledDropTime'],
      'scheduledPickupTime': payload['scheduledPickupTime'],
    };

    luggages.add(newLuggage);
    user['luggages'] = luggages;
    await _saveState(state);

    return {
      'ok': true,
      'statusCode': 200,
      'luggage': _exposeLuggage(newLuggage),
      'luggages': luggages.map(_exposeLuggage).toList(),
      'message': 'Demo ortamında bavul oluşturuldu',
    };
  }

  static Future<Map<String, dynamic>> updateLuggageStatus(
    String userId,
    String luggageId,
    String status,
  ) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final user = _findUser(users, (u) => u['id'].toString() == userId);
    if (user == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo kullanıcısı bulunamadı',
      };
    }
    final luggages = _ensureLuggageList(user);
    final luggage = _findUser(luggages, (l) => l['id'].toString() == luggageId);
    if (luggage == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo: Bavul bulunamadı',
      };
    }

    final now = DateTime.now().toIso8601String();
    luggage['status'] = status;
    luggage['updatedAt'] = now;
    if (status == _statusDropped) {
      luggage['dropConfirmedAt'] = now;
    }
    if (status == _statusPickedUp) {
      luggage['pickupConfirmedAt'] = now;
    }

    await _saveState(state);
    return {
      'ok': true,
      'statusCode': 200,
      'luggage': _exposeLuggage(luggage),
      'message': 'Demo ortamında bavul durumu güncellendi',
    };
  }

  static Future<Map<String, dynamic>> updateLuggageMetadata(
    String userId,
    String luggageId,
    Map<String, dynamic> data,
  ) async {
    final state = await _loadState();
    final users = (state['users'] as List).cast<Map<String, dynamic>>();
    final user = _findUser(users, (u) => u['id'].toString() == userId);
    if (user == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo kullanıcısı bulunamadı',
      };
    }
    final luggages = _ensureLuggageList(user);
    final luggage = _findUser(luggages, (l) => l['id'].toString() == luggageId);
    if (luggage == null) {
      return {
        'ok': false,
        'statusCode': 404,
        'error': 'Demo: Bavul bulunamadı',
      };
    }

    luggage['label'] = (data['label'] ?? luggage['label']).toString();
    luggage['weight'] = (data['weight'] ?? luggage['weight']).toString();
    luggage['size'] = (data['size'] ?? luggage['size']).toString();
    luggage['color'] = (data['color'] ?? luggage['color']).toString();
    luggage['note'] = (data['note'] ?? luggage['note']).toString();
    luggage['updatedAt'] = DateTime.now().toIso8601String();

    await _saveState(state);
    return {
      'ok': true,
      'statusCode': 200,
      'luggage': _exposeLuggage(luggage),
      'message': 'Demo ortamında bavul bilgileri güncellendi',
    };
  }
}
