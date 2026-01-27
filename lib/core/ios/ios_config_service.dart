import 'dart:io';
import 'package:flutter/services.dart';
import '../../utils/crash_log.dart';

class IosConfigService {
  static const MethodChannel _channel = MethodChannel('kyradi/ios_config');

  static Future<List<String>> getUrlSchemes() async {
    if (!Platform.isIOS) return const [];
    try {
      final schemes = await _channel.invokeMethod<List<Object?>>('getUrlSchemes');
      return schemes
              ?.whereType<String>()
              .where((value) => value.trim().isNotEmpty)
              .toList() ??
          const [];
    } catch (e) {
      appLog('ios_config', 'getUrlSchemes failed: $e',
          level: AppLogLevel.warn);
      return const [];
    }
  }

  static Future<bool> hasGoogleServicePlist() async {
    if (!Platform.isIOS) return false;
    try {
      final value = await _channel.invokeMethod<bool>('hasGoogleServicePlist');
      return value == true;
    } catch (e) {
      appLog('ios_config', 'hasGoogleServicePlist failed: $e',
          level: AppLogLevel.warn);
      return false;
    }
  }

  static Future<bool> hasFirebasePlist() async {
    if (!Platform.isIOS) return false;
    try {
      final value = await _channel.invokeMethod<bool>('hasFirebasePlist');
      return value == true;
    } catch (e) {
      appLog('ios_config', 'hasFirebasePlist failed: $e',
          level: AppLogLevel.warn);
      return false;
    }
  }

  static Future<bool> hasGmsApiKey() async {
    if (!Platform.isIOS) return false;
    try {
      final value = await _channel.invokeMethod<bool>('hasGmsApiKey');
      return value == true;
    } catch (e) {
      appLog('ios_config', 'hasGmsApiKey failed: $e',
          level: AppLogLevel.warn);
      return false;
    }
  }

  static Future<String> getGoogleReversedClientId() async {
    if (!Platform.isIOS) return '';
    try {
      final value =
          await _channel.invokeMethod<String>('getGoogleReversedClientId');
      return value?.trim() ?? '';
    } catch (e) {
      appLog('ios_config', 'getGoogleReversedClientId failed: $e',
          level: AppLogLevel.warn);
      return '';
    }
  }

  static Future<bool> hasGoogleReversedClientId() async {
    final schemes = await getUrlSchemes();
    return schemes.any((scheme) => scheme.startsWith('com.googleusercontent.apps'));
  }

  static Future<bool> hasUrlScheme(String scheme) async {
    final schemes = await getUrlSchemes();
    return schemes.contains(scheme);
  }
}
