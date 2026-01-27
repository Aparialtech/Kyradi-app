import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../utils/crash_log.dart';
import '../core/firebase/firebase_bootstrap.dart';
import '../core/auth/google_oauth_config.dart';

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
      final clientId = Platform.isIOS && isValidIosGoogleClientId(kIosGoogleClientId)
          ? kIosGoogleClientId
          : null;
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
      if ((idToken == null || idToken.isEmpty) &&
          (accessToken == null || accessToken.isEmpty)) {
        return AuthResult(ok: false, error: 'TOKEN_INVALID', statusCode: 400);
      }
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
    } catch (e) {
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
