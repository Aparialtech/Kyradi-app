import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform, debugPrint;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'mock_server.dart';

class ApiService {
  ApiService._();

  static const String _envScheme =
      String.fromEnvironment('API_SCHEME', defaultValue: 'http');
  static const String _envHost =
      String.fromEnvironment('API_HOST', defaultValue: '');
  static const String _envPort =
      String.fromEnvironment('API_PORT', defaultValue: '8080');
  static const String _envBase =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'https://kyradi-app-production.up.railway.app');

  static SharedPreferences? _prefs;
  static bool _initialized = false;
  static String? _customBaseUrl;
  static String? _authToken;

  /// Host seçimi:
  /// - Web (Chrome): localhost
  /// - Android Emülatör: 10.0.2.2
  /// - iOS Sim / Desktop: localhost
  static String get _host {
    if (_envHost.trim().isNotEmpty) return _envHost.trim();
    // Chrome'da flutter run -d chrome kullanırken localhost yerine 127.0.0.1
    // kullanmak CORS/ayrı origin problemlerini azaltıyor.
    if (kIsWeb) return '127.0.0.1';
    if (defaultTargetPlatform == TargetPlatform.android) return '10.0.2.2';
    return 'localhost';
  }

  static String get _scheme {
    final scheme = _envScheme.trim().toLowerCase();
    return scheme.isEmpty ? 'http' : scheme;
  }

  static String get _port {
    final port = _envPort.trim();
    return port;
  }

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _customBaseUrl = _prefs?.getString(_PrefsKeys.baseUrl);
    _authToken = _prefs?.getString(_PrefsKeys.authToken);
    _initialized = true;
  }

  static Future<void> setCustomBaseUrl(String? value) async {
    await ensureInitialized();
    final normalized = _normalizeBaseUrl(value);
    _customBaseUrl = normalized;
    if (normalized == null) {
      await _prefs?.remove(_PrefsKeys.baseUrl);
    } else {
      await _prefs?.setString(_PrefsKeys.baseUrl, normalized);
    }
  }

  static Future<void> clearCustomBaseUrl() => setCustomBaseUrl(null);

  static Future<void> _storeAuthToken(String? value) async {
    await ensureInitialized();
    _authToken = value;
    if (value == null || value.isEmpty) {
      await _prefs?.remove(_PrefsKeys.authToken);
    } else {
      await _prefs?.setString(_PrefsKeys.authToken, value);
    }
  }

  static bool get hasCustomBaseUrl =>
      _customBaseUrl != null && _customBaseUrl!.isNotEmpty;

  static String? get customBaseUrl => _customBaseUrl;

  static String get baseUrlSource {
    if (_normalizeBaseUrl(_envBase) != null ||
        _envHost.trim().isNotEmpty ||
        _envScheme.trim().isNotEmpty ||
        _envPort.trim().isNotEmpty) {
      return 'environment';
    }
    if (hasCustomBaseUrl) return 'custom';
    return 'default';
  }

  static String get defaultBaseUrl {
    final port = _port;
    final portSection = port.isEmpty ? '' : ':$port';
    return '$_scheme://$_host$portSection';
  }

  static String get baseUrl {
    final envBase = _normalizeBaseUrl(_envBase);
    if (envBase != null) return envBase;
    if (hasCustomBaseUrl) return _customBaseUrl!;
    return defaultBaseUrl;
  }

  static String get apiBaseUrl => baseUrl;

  static bool get _usingMockBackend => baseUrl.startsWith('demo://');

  static Map<String, String> _jsonHeaders() {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_authToken?.isNotEmpty == true) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  static Map<String, String> _plainHeaders() {
    final headers = <String, String>{};
    if (_authToken?.isNotEmpty == true) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Ortak POST helper
  static Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body, {
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final uri = Uri.parse('${ApiService.apiBaseUrl}$path');
    debugPrint('[HTTP POST] $uri  body=${jsonEncode(body)}');
    try {
      final res = await http
          .post(uri, headers: _jsonHeaders(), body: jsonEncode(body))
          .timeout(timeout);
      return _handleResponse(res, uri);
    } on TimeoutException {
      return {'ok': false, 'error': 'İstek zaman aşımına uğradı', 'statusCode': 408};
    } catch (e) {
      final message = e.toString();
      final hint = message.contains('Failed host lookup') ||
              message.contains('Connection refused') ||
              message.contains('Failed to fetch')
          ? 'Sunucuya bağlanılamadı. Lütfen internetinizi ve API ayarlarını kontrol edin.'
          : 'İstek hatası: $message';
      return {
        'ok': false,
        'error': hint,
        'statusCode': 500,
        '_networkError': true,
      };
    }
  }

  // Ortak PUT helper
  static Future<Map<String, dynamic>> _put(
    String path,
    Map<String, dynamic> body, {
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final uri = Uri.parse('${ApiService.apiBaseUrl}$path');
    debugPrint('[HTTP PUT] $uri  body=${jsonEncode(body)}');
    try {
      final res = await http
          .put(uri, headers: _jsonHeaders(), body: jsonEncode(body))
          .timeout(timeout);
      return _handleResponse(res, uri);
    } on TimeoutException {
      return {'ok': false, 'error': 'İstek zaman aşımına uğradı', 'statusCode': 408};
    } catch (e) {
      final message = e.toString();
      final hint = message.contains('Failed host lookup') ||
              message.contains('Connection refused') ||
              message.contains('Failed to fetch')
          ? 'Sunucuya bağlanılamadı. Lütfen internetinizi ve API ayarlarını kontrol edin.'
          : 'İstek hatası: $message';
      return {
        'ok': false,
        'error': hint,
        'statusCode': 500,
        '_networkError': true,
      };
    }
  }

  // Ortak GET helper
  static Future<Map<String, dynamic>> _get(
    String path, {
    Duration timeout = const Duration(seconds: 12),
  }) async {
    final uri = Uri.parse('${ApiService.apiBaseUrl}$path');
    debugPrint('[HTTP GET]  $uri');
    try {
      final res = await http.get(uri, headers: _jsonHeaders()).timeout(timeout);
      return _handleResponse(res, uri);
    } on TimeoutException {
      return {'ok': false, 'error': 'İstek zaman aşımına uğradı', 'statusCode': 408};
    } catch (e) {
      final message = e.toString();
      final hint = message.contains('Failed host lookup') ||
              message.contains('Connection refused') ||
              message.contains('Failed to fetch')
          ? 'Sunucuya bağlanılamadı. Lütfen internetinizi ve API ayarlarını kontrol edin.'
          : 'İstek hatası: $message';
      return {
        'ok': false,
        'error': hint,
        'statusCode': 500,
        '_networkError': true,
      };
    }
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Sunucu yanıtını tek yerden ele al
  static Map<String, dynamic> _handleResponse(http.Response res, Uri uri) {
    debugPrint('[HTTP RES]  ${res.statusCode} <- $uri  body=${res.body}');
    dynamic decoded;
    if (res.body.isNotEmpty) {
      try {
        decoded = jsonDecode(res.body);
      } catch (_) {/* yoksay */}
    }

    Map<String, dynamic> map;
    if (decoded is Map<String, dynamic>) {
      map = Map<String, dynamic>.from(decoded);
    } else {
      map = {};
      if (decoded is List) {
        map['data'] = decoded;
      }
    }
    map['_httpStatus'] = res.statusCode;
    map['statusCode'] = res.statusCode;

    // başarılı yanıt
    if (res.statusCode >= 200 && res.statusCode < 300) {
      map['ok'] = true;
      return map;
    }

    // hata durumları
    map['ok'] = false;
    if (decoded is Map && decoded.containsKey('error')) {
      return map;
    }

    return {
      'ok': false,
      'error':
          'Sunucu hatası: ${res.statusCode}${res.body.isNotEmpty ? ' — ${res.body}' : ''}',
      'statusCode': res.statusCode,
    };
  }

  // ───────────────────────────────────────────────────────────────────────────
  // Endpoint'ler
  static Future<Map<String, dynamic>> health() async {
    if (_usingMockBackend) {
      return MockServer.health();
    }
    final result = await _get('/locations');
    result['statusCode'] ??= result['_httpStatus'];
    return result;
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    if (_usingMockBackend) {
      return MockServer.login(email, password);
    }
    final result = await _post('/auth/login', {
      'email': email,
      'password': password,
    });
    result['statusCode'] ??= result['_httpStatus'];
    if (result['ok'] == true) {
      await _storeAuthToken((result['accessToken'] ?? result['token'])?.toString());
      if (result['user'] is Map<String, dynamic>) {
        result['profile'] = _normalizeProfile(
          Map<String, dynamic>.from(result['user'] as Map),
        );
      }
    }
    return result;
  }

  /// ✅ Artık confirmPassword da gönderiliyor!
  static Future<Map<String, dynamic>> register(Map<String, dynamic> data) {
    if (_usingMockBackend) {
      return MockServer.register(data);
    }
    final payload = {
      'name': data['name'],
      'surname': data['surname'],
      'email': (data['email'] ?? '').toString().toLowerCase(),
      'password': data['password'],
      'phone': data['phone'],
    };
    return _post('/auth/register', payload).then((result) async {
      result['statusCode'] ??= result['_httpStatus'];
      if (result['ok'] == true) {
        await _storeAuthToken((result['accessToken'] ?? result['token'])?.toString());
        if (result['user'] is Map<String, dynamic>) {
          result['profile'] = _normalizeProfile(
            Map<String, dynamic>.from(result['user'] as Map),
          );
        }
      }
      return result;
    });
  }

  static Future<Map<String, dynamic>> verifyCode(String email, String code) {
    if (_usingMockBackend) return MockServer.verifyCode(email, code);
    return _post('/auth/verify', {
      'email': email,
      'code': code,
    }).then((result) {
      result['statusCode'] ??= result['_httpStatus'];
      return result;
    });
  }

  static Future<Map<String, dynamic>> resendVerify(String email) {
    if (_usingMockBackend) return MockServer.resendCode(email);
    return _post('/auth/resend-verify', {
      'email': email,
    }).then((result) {
      result['statusCode'] ??= result['_httpStatus'];
      return result;
    });
  }

  // ✅ Şifre sıfırlama kodu gönderme
  static Future<Map<String, dynamic>> forgot(String email) async {
    if (_usingMockBackend) return MockServer.forgot(email);
    final result = await _post('/auth/forgot', {'email': email});
    result['statusCode'] ??= result['_httpStatus'];
    return result;
  }

  // ✅ Şifre sıfırlama (code + newPassword)
  static Future<Map<String, dynamic>> reset(
    String email,
    String code,
    String newPassword,
  ) async {
    if (_usingMockBackend) return MockServer.reset(email, code, newPassword);
    final result = await _post('/auth/reset', {
      'email': email,
      'code': code,
      'newPassword': newPassword,
    });
    result['statusCode'] ??= result['_httpStatus'];
    return result;
  }

  // 🔒 Şifre değiştir (login sonrası)
  static Future<Map<String, dynamic>> changePassword(
    String userId,
    String oldPassword,
    String newPassword,
  ) async {
    if (_usingMockBackend) {
      return MockServer.changePassword(userId, oldPassword, newPassword);
    }
    final result = await _post('/auth/change-password', {
      'userId': userId,
      'oldPassword': oldPassword,
      'newPassword': newPassword,
    });
    result['statusCode'] ??= result['_httpStatus'];
    return result;
  }

  static Future<Map<String, dynamic>> getProfile(String userId) async {
    if (_usingMockBackend) return MockServer.getProfile(userId);
    final response = await _get('/users/$userId');
    response['statusCode'] ??= response['_httpStatus'];
    if (response['ok'] == true) {
      final raw = response['profile'] ??
          response['data'] ??
          _stripMeta(response);
      if (raw is Map<String, dynamic>) {
        response['profile'] =
            _normalizeProfile(Map<String, dynamic>.from(raw));
      }
    }
    return response;
  }

  static Future<Map<String, dynamic>> getLocations() async {
    if (_usingMockBackend) return MockServer.getLocations();
    final result = await _get('/locations');
    result['statusCode'] ??= result['_httpStatus'];
    if (result['locations'] == null && result['data'] is List) {
      result['locations'] = result['data'];
    }
    return result;
  }

  static Future<Map<String, dynamic>> getUserLuggages(String userId) async {
    if (_usingMockBackend) return MockServer.getUserLuggages(userId);
    final result = await _get('/users/$userId/luggages');
    result['statusCode'] ??= result['_httpStatus'];
    if (result['luggages'] == null && result['data'] is List) {
      result['luggages'] = result['data'];
    }
    return result;
  }

  static Future<Map<String, dynamic>> updateProfile(
    String userId,
    Map<String, dynamic> body,
  ) async {
    if (_usingMockBackend) return MockServer.updateProfile(userId, body);
    final payload = Map<String, dynamic>.from(body)
      ..removeWhere((key, value) => value == null);
    debugPrint('[HTTP PUT] /users/$userId body=${jsonEncode(payload)}');
    final result = await _put('/users/$userId', payload);
    result['statusCode'] ??= result['_httpStatus'];
    return result;
  }

  static Future<Map<String, dynamic>> createLuggage(
    String userId,
    Map<String, dynamic> payload,
  ) async {
    if (_usingMockBackend) return MockServer.createLuggage(userId, payload);
    final body = Map<String, dynamic>.from(payload);
    if (body['scheduledDropTime'] is DateTime) {
      body['scheduledDropTime'] =
          (body['scheduledDropTime'] as DateTime).toIso8601String();
    }
    if (body['scheduledPickupTime'] is DateTime) {
      body['scheduledPickupTime'] =
          (body['scheduledPickupTime'] as DateTime).toIso8601String();
    }
    final result = await _post('/users/$userId/luggages', body);
    result['statusCode'] ??= result['_httpStatus'];
    if (result['ok'] == true && result['luggage'] is! Map) {
      final doc = _stripMeta(result);
      if (doc.isNotEmpty) {
        result['luggage'] = doc;
      }
    }
    return result;
  }

  static Future<Map<String, dynamic>> updateLuggageStatus(
    String userId,
    String luggageId,
    String status,
  ) async {
    if (_usingMockBackend) {
      return MockServer.updateLuggageStatus(userId, luggageId, status);
    }
    final result = await _put(
      '/users/$userId/luggages/$luggageId/status',
      {'status': status},
    );
    result['statusCode'] ??= result['_httpStatus'];
    Map<String, dynamic>? payload;
    final direct = result['luggage'];
    if (direct is Map<String, dynamic>) {
      payload = Map<String, dynamic>.from(direct);
    } else if (result['data'] is Map) {
      payload = Map<String, dynamic>.from(result['data'] as Map);
    } else if (result['payload'] is Map) {
      payload = Map<String, dynamic>.from(result['payload'] as Map);
    } else if (result['success'] == true || result['ok'] == true) {
      final doc = _stripMeta(result);
      if (doc.isNotEmpty) payload = doc;
    }
    if (payload != null) {
      result['luggage'] = payload;
      result['ok'] = true;
    } else if (result['ok'] == null && result['success'] == true) {
      result['ok'] = true;
    }
    return result;
  }

  static Future<Map<String, dynamic>> updateLuggageMetadata(
    String userId,
    String luggageId,
    Map<String, dynamic> data,
  ) async {
    if (_usingMockBackend) {
      return MockServer.updateLuggageMetadata(userId, luggageId, data);
    }
    final payload = Map<String, dynamic>.from(data)
      ..removeWhere((key, value) => value == null);
    if (payload['scheduledDropTime'] is DateTime) {
      payload['scheduledDropTime'] =
          (payload['scheduledDropTime'] as DateTime).toIso8601String();
    }
    if (payload['scheduledPickupTime'] is DateTime) {
      payload['scheduledPickupTime'] =
          (payload['scheduledPickupTime'] as DateTime).toIso8601String();
    }
    final result = await _put(
      '/users/$userId/luggages/$luggageId',
      payload,
    );
    result['statusCode'] ??= result['_httpStatus'];
    if (result['ok'] == true && result['luggage'] is! Map) {
      final doc = _stripMeta(result);
      if (doc.isNotEmpty) result['luggage'] = doc;
    }
    return result;
  }

  static Future<Map<String, dynamic>> uploadIdentityDocument({
    required List<int> bytes,
    required String filename,
  }) async {
    if (_usingMockBackend) {
      return {
        'ok': true,
        'fileUrl': 'mock://identity/$filename',
        'filename': filename,
      };
    }
    final uri = Uri.parse('${ApiService.apiBaseUrl}/uploads/identity');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll(_plainHeaders())
      ..files.add(http.MultipartFile.fromBytes('file', bytes, filename: filename));
    try {
      final response = await request.send().timeout(const Duration(seconds: 20));
      final responseBody = await response.stream.bytesToString();
      final map = responseBody.isNotEmpty
          ? jsonDecode(responseBody) as Map<String, dynamic>
          : <String, dynamic>{};
      map['statusCode'] = response.statusCode;
      map['ok'] = response.statusCode >= 200 && response.statusCode < 300;
      return map;
    } catch (e) {
      return {
        'ok': false,
        'error': 'Yükleme başarısız: $e',
        'statusCode': 500,
      };
    }
  }

  static String? _normalizeBaseUrl(String? value) {
    if (value == null) return null;
    var candidate = value.trim();
    if (candidate.isEmpty) return null;
    if (candidate.toLowerCase() == 'offline' ||
        candidate.toLowerCase() == 'demo://offline') {
      return 'demo://offline';
    }
    if (!candidate.contains('://')) {
      candidate = 'http://$candidate';
    }
    try {
      final uri = Uri.parse(candidate);
      if (!uri.hasScheme || uri.host.isEmpty) return null;
      final buffer = StringBuffer()
        ..write(uri.scheme.toLowerCase())
        ..write('://')
        ..write(uri.host);
      if (uri.hasPort) {
        buffer.write(':${uri.port}');
      }
      final cleanedPath = uri.path.isEmpty || uri.path == '/'
          ? ''
          : uri.path.replaceFirst(RegExp(r'/+$'), '');
      if (cleanedPath.isNotEmpty) {
        buffer.write(cleanedPath.startsWith('/') ? cleanedPath : '/$cleanedPath');
      }
      return buffer.toString();
    } catch (_) {
      return null;
    }
  }

  static String? normalizeBaseUrl(String value) => _normalizeBaseUrl(value);
}

class _PrefsKeys {
  static const baseUrl = 'api_base_url';
  static const authToken = 'auth_token';
}

Map<String, dynamic> _normalizeProfile(Map<String, dynamic> profile) {
  final normalized = Map<String, dynamic>.from(profile);
  final rawId = normalized['_id'];
  if (!normalized.containsKey('id') && rawId != null) {
    normalized['id'] = rawId.toString();
  }
  return normalized;
}

Map<String, dynamic> _stripMeta(Map<String, dynamic> response) {
  final copy = Map<String, dynamic>.from(response);
  copy.removeWhere(
    (key, value) =>
        ((key.startsWith('_') && key != '_id') ||
            key == 'ok' ||
            key == 'statusCode' ||
            key == 'profile'),
  );
  return copy;
}
