import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform, debugPrint;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'mock_server.dart';
import '../models/pricing_models.dart';

const String kApiBaseUrl = 'https://kyradi-app-production.up.railway.app';

class ApiService {
  ApiService._();

  static const String _envBase =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');
  static const String _envPort =
      String.fromEnvironment('API_PORT', defaultValue: '8080');
  static const bool _assumeIosSimulator =
      bool.fromEnvironment('IOS_SIMULATOR', defaultValue: false);
  static const String _defaultBaseUrl =
      'https://kyradi-app-production.up.railway.app';

  static SharedPreferences? _prefs;
  static bool _initialized = false;
  static String? _customBaseUrl;
  static String? _authToken;
  static const FlutterSecureStorage _secureStorage =
      FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));

  static Future<void> ensureInitialized() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _customBaseUrl = _prefs?.getString(_PrefsKeys.baseUrl);
    _authToken = await _secureStorage.read(key: _PrefsKeys.authToken);
    _authToken ??= _prefs?.getString(_PrefsKeys.authToken);
    if (_authToken != null && _authToken!.isNotEmpty) {
      await _secureStorage.write(key: _PrefsKeys.authToken, value: _authToken);
    }
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
      await _secureStorage.delete(key: _PrefsKeys.authToken);
      await _prefs?.remove(_PrefsKeys.authToken);
    } else {
      await _secureStorage.write(key: _PrefsKeys.authToken, value: value);
      await _prefs?.setString(_PrefsKeys.authToken, value);
    }
  }

  static bool get hasCustomBaseUrl =>
      _customBaseUrl != null && _customBaseUrl!.isNotEmpty;

  static String? get customBaseUrl => _customBaseUrl;

  static String get baseUrlSource {
    if (hasCustomBaseUrl) return 'custom';
    if (_normalizeBaseUrl(_envBase) != null) return 'environment';
    if (_defaultBaseUrl.isNotEmpty) return 'default';
    if (_fallbackBaseUrl != null) return 'fallback';
    return 'unset';
  }

  static bool get hasResolvedBaseUrl => _resolveBaseUrl() != null;

  static String get baseUrl {
    return _resolveBaseUrl() ?? '';
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
    final uri = _buildUri(path);
    if (uri == null) {
      return _missingBaseUrlError();
    }
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
    final uri = _buildUri(path);
    if (uri == null) {
      return _missingBaseUrlError();
    }
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
    final uri = _buildUri(path);
    if (uri == null) {
      return _missingBaseUrlError();
    }
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
    if (decoded is Map && (decoded.containsKey('error') || decoded.containsKey('message'))) {
      if (map['error'] == null && map['message'] != null) {
        map['error'] = map['message'];
      }
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

  static Future<Map<String, dynamic>> socialLogin({
    required String provider,
    required String idToken,
    String? authorizationCode,
  }) async {
    if (_usingMockBackend) {
      return MockServer.socialLogin(provider, idToken);
    }
    final result = await _post('/auth/social', {
      'provider': provider,
      'idToken': idToken,
      if (authorizationCode != null) 'authorizationCode': authorizationCode,
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

  static Future<PricingEstimateResponse> estimatePricing(
    PricingEstimateRequest req,
  ) async {
    final uri = Uri.parse('$kApiBaseUrl/pricing/estimate');

    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(req.toJson()),
    );

    final body = res.body.isNotEmpty ? jsonDecode(res.body) : null;

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return PricingEstimateResponse.fromJson(body as Map<String, dynamic>);
    }

    final msg = (body is Map && body['message'] != null)
        ? body['message'].toString()
        : res.body;
    throw Exception('Pricing estimate failed (${res.statusCode}): $msg');
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
    final path = '/users/$userId/luggages';
    final uri = _buildUri(path);
    print(
      '[PIN_FLOW] sending request: ${{
        'method': 'POST',
        'url': uri?.toString(),
        'body': body,
      }}',
    );
    Map<String, dynamic> result;
    try {
      result = await _post(path, body);
      print(
        '[PIN_FLOW] response: ${{
          'status': result['statusCode'],
          'body': result,
        }}',
      );
    } catch (e) {
      print('[PIN_FLOW] error: $e');
      rethrow;
    }
    result['statusCode'] ??= result['_httpStatus'];
    if (result['ok'] == true && result['luggage'] is! Map) {
      final doc = _stripMeta(result);
      if (doc.isNotEmpty) {
        result['luggage'] = doc;
      }
    }
    return result;
  }

  static Future<Map<String, dynamic>> startPaymentCheckout({
    required String reservationId,
    required String paymentMethod,
    int? installmentCount,
  }) async {
    if (_usingMockBackend) {
      return MockServer.startPaymentCheckout(
        reservationId: reservationId,
        paymentMethod: paymentMethod,
        installmentCount: installmentCount,
      );
    }
    final body = <String, dynamic>{
      'reservationId': reservationId,
      'paymentMethod': paymentMethod,
    };
    if (installmentCount != null) {
      body['installmentCount'] = installmentCount;
    }
    final result = await _post('/payments/checkout', body);
    result['statusCode'] ??= result['_httpStatus'];
    return result;
  }

  static Future<Map<String, dynamic>> getPaymentStatus(String reservationId) async {
    if (_usingMockBackend) {
      return MockServer.getPaymentStatus(reservationId);
    }
    final result = await _get('/payments/status?reservationId=$reservationId');
    result['statusCode'] ??= result['_httpStatus'];
    return result;
  }

  static Future<Map<String, dynamic>> sendPaymentWebhook({
    required String providerPaymentId,
    required String status,
    String? transactionId,
  }) async {
    if (_usingMockBackend) {
      return MockServer.sendPaymentWebhook(
        providerPaymentId: providerPaymentId,
        status: status,
        transactionId: transactionId,
      );
    }
    final body = <String, dynamic>{
      'providerPaymentId': providerPaymentId,
      'status': status,
    };
    if (transactionId != null && transactionId.isNotEmpty) {
      body['transactionId'] = transactionId;
    }
    final result = await _post('/payments/webhook', body);
    result['statusCode'] ??= result['_httpStatus'];
    return result;
  }

  static Future<Map<String, dynamic>> updateLuggageStatus(
    String userId,
    String luggageId,
    String status,
    String? pickupPin,
    String? delegateCode,
  ) async {
    if (_usingMockBackend) {
      return MockServer.updateLuggageStatus(userId, luggageId, status);
    }
    final body = <String, dynamic>{'status': status};
    if (pickupPin != null && pickupPin.trim().isNotEmpty) {
      body['pickupPin'] = pickupPin.trim();
    }
    if (delegateCode != null && delegateCode.trim().isNotEmpty) {
      body['delegateCode'] = delegateCode.trim();
    }
    final result = await _put(
      '/users/$userId/luggages/$luggageId/status',
      body,
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
    final uri = _buildUri('/uploads/identity');
    if (uri == null) {
      return _missingBaseUrlError();
    }
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
    final uri = Uri.tryParse(candidate);
    if (uri == null || uri.host.isEmpty) return null;
    final scheme = uri.scheme.toLowerCase();
    if (scheme != 'http' && scheme != 'https') return null;
    final cleanedPath =
        uri.path.isEmpty || uri.path == '/' ? '' : uri.path.replaceFirst(RegExp(r'/+$'), '');
    return uri.replace(path: cleanedPath, query: null, fragment: null).toString();
  }

  static String? normalizeBaseUrl(String value) => _normalizeBaseUrl(value);

  static String? _resolveBaseUrl() {
    final env = _normalizeBaseUrl(_envBase);
    if (env != null) return env;
    if (hasCustomBaseUrl) return _customBaseUrl!;
    if (_defaultBaseUrl.isNotEmpty) return _defaultBaseUrl;
    return _fallbackBaseUrl;
  }

  static Uri? _buildUri(String path) {
    final base = _resolveBaseUrl();
    if (base == null || base.isEmpty) return null;
    final baseUri = Uri.parse(base);
    final normalizedPath = _joinPaths(baseUri.path, path);
    return baseUri.replace(path: normalizedPath);
  }

  static String _joinPaths(String basePath, String path) {
    final trimmedBase = basePath.endsWith('/') && basePath.length > 1
        ? basePath.substring(0, basePath.length - 1)
        : basePath;
    final normalizedBase = trimmedBase == '/' ? '' : trimmedBase;
    final trimmedPath = path.startsWith('/') ? path.substring(1) : path;
    if (normalizedBase.isEmpty) return '/$trimmedPath';
    return '$normalizedBase/$trimmedPath';
  }

  static Map<String, dynamic> _missingBaseUrlError() {
    return {
      'ok': false,
      'error': 'API base URL ayarlı değil. Lütfen API ayarlarından bir adres girin.',
      'statusCode': 400,
      '_configurationError': true,
    };
  }

  static String? get _fallbackBaseUrl {
    final port = _envPort.trim().isEmpty ? '8080' : _envPort.trim();
    if (kIsWeb) {
      return 'http://127.0.0.1:$port';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:$port';
    }
    if (defaultTargetPlatform == TargetPlatform.iOS && _assumeIosSimulator) {
      return 'http://localhost:$port';
    }
    if (_isDesktopPlatform()) {
      return 'http://localhost:$port';
    }
    return null;
  }

  static bool _isDesktopPlatform() {
    if (kIsWeb) return false;
    if (defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.linux) {
      return true;
    }
    return false;
  }
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
