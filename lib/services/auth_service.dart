import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kDebugMode, kProfileMode, kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../core/firebase/firebase_bootstrap.dart';
import '../core/auth/google_oauth_config.dart';
import '../utils/crash_log.dart';

class AuthResult {
  AuthResult({
    required this.ok,
    this.providerIdToken,
    this.accessToken,
    this.authorizationCode,
    this.firebaseIdToken,
    this.error,
    this.statusCode,
  });

  final bool ok;
  final String? providerIdToken;
  final String? accessToken;
  final String? authorizationCode;
  final String? firebaseIdToken;
  final String? error;
  final int? statusCode;
}

class AuthService {
  AuthService._();

  static bool get _firebaseReady => FirebaseBootstrap.isReady;
  static bool get _isDebugLike => kDebugMode || kProfileMode;

  static String _platformLabel() {
    if (kIsWeb) return 'web';
    if (Platform.isIOS) return 'ios';
    if (Platform.isAndroid) return 'android';
    return 'other';
  }

  static String? _extractAud(String idToken) {
    try {
      final parts = idToken.split('.');
      if (parts.length < 2) return null;
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      final jsonMap = jsonDecode(payload);
      if (jsonMap is Map && jsonMap['aud'] is String) {
        return jsonMap['aud'] as String;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<bool> isAppleAvailable() async {
    if (!Platform.isIOS) return false;
    try {
      return await SignInWithApple.isAvailable();
    } catch (_) {
      return false;
    }
  }

  static Future<AuthResult> signInWithGoogle() async {
    if (!_firebaseReady) {
      return AuthResult(ok: false, error: 'Firebase yapılandırması eksik.', statusCode: 500);
    }
    try {
      final clientId = kIsWeb
          ? (kWebGoogleClientId.isNotEmpty ? kWebGoogleClientId : null)
          : (Platform.isIOS && isValidIosGoogleClientId(kIosGoogleClientId)
              ? kIosGoogleClientId
              : (Platform.isAndroid && kAndroidGoogleClientId.isNotEmpty
                  ? kAndroidGoogleClientId
                  : null));
      appLog(
        'auth',
        'AUTH_GOOGLE_CLIENT platform=${_platformLabel()} clientId_used=${maskClientId(clientId ?? '')}',
        level: AppLogLevel.info,
      );
      final googleSignIn = GoogleSignIn(
        clientId: clientId,
        scopes: ['email', 'profile', 'openid'],
      );
      final account = await googleSignIn.signIn();
      if (account == null) {
        return AuthResult(ok: false, error: 'Login cancelled', statusCode: 400);
      }
      final auth = await account.authentication;
      final idToken = auth.idToken;
      final accessToken = auth.accessToken;
      final serverAuthCode = account.serverAuthCode;
      appLog(
        'auth',
        'AUTH_GOOGLE_TOKEN idToken_present=${idToken != null && idToken.isNotEmpty} accessToken_present=${accessToken != null && accessToken.isNotEmpty} serverAuthCode_present=${serverAuthCode != null && serverAuthCode.isNotEmpty}',
        level: AppLogLevel.info,
      );
      if ((idToken == null || idToken.isEmpty) &&
          (accessToken == null || accessToken.isEmpty)) {
        return AuthResult(ok: false, error: 'TOKEN_INVALID', statusCode: 400);
      }
      if (_isDebugLike && Platform.isIOS && idToken != null && idToken.isNotEmpty) {
        final aud = _extractAud(idToken);
        if (aud != null && aud != kIosGoogleClientId) {
          appLog(
            'auth',
            'AUTH_GOOGLE_AUD_MISMATCH aud=$aud expected=$kIosGoogleClientId',
            level: AppLogLevel.warn,
          );
          return AuthResult(
            ok: false,
            error:
                'Google token audience uyuşmuyor: iOS clientId yerine başka clientId ile token üretildi.',
            statusCode: 400,
          );
        }
      }
      appLog('auth', 'AUTH_GOOGLE_FIREBASE_SIGNIN_START', level: AppLogLevel.info);
      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accessToken,
      );
      final userCred = await FirebaseAuth.instance.signInWithCredential(credential);
      final firebaseToken = await userCred.user?.getIdToken();
      return AuthResult(
        ok: true,
        providerIdToken: idToken,
        accessToken: accessToken,
        firebaseIdToken: firebaseToken,
      );
    } on FirebaseAuthException catch (e) {
      appLog(
        'auth',
        'AUTH_GOOGLE_FIREBASE_SIGNIN_ERROR code=${e.code} message=${e.message}',
        level: AppLogLevel.error,
      );
      return AuthResult(ok: false, error: e.code, statusCode: 401);
    } catch (e) {
      appLog('auth', 'AUTH_GOOGLE_FIREBASE_SIGNIN_ERROR code=$e', level: AppLogLevel.error);
      return AuthResult(ok: false, error: e.toString(), statusCode: 500);
    }
  }

  static Future<AuthResult> signInWithApple() async {
    if (!_firebaseReady) {
      return AuthResult(ok: false, error: 'Firebase yapılandırması eksik.', statusCode: 500);
    }
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email, AppleIDAuthorizationScopes.fullName],
      );
      final idToken = credential.identityToken;
      if (idToken == null || idToken.isEmpty) {
        return AuthResult(ok: false, error: 'TOKEN_INVALID', statusCode: 400);
      }
      final oauth = OAuthProvider('apple.com').credential(
        idToken: idToken,
        accessToken: credential.authorizationCode,
      );
      final userCred = await FirebaseAuth.instance.signInWithCredential(oauth);
      final firebaseToken = await userCred.user?.getIdToken();
      return AuthResult(
        ok: true,
        providerIdToken: idToken,
        authorizationCode: credential.authorizationCode,
        firebaseIdToken: firebaseToken,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        return AuthResult(ok: false, error: 'Login cancelled', statusCode: 400);
      }
      return AuthResult(ok: false, error: e.toString(), statusCode: 500);
    } catch (e) {
      return AuthResult(ok: false, error: e.toString(), statusCode: 500);
    }
  }

  static Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    } catch (_) {}
  }
}
