const String kIosGoogleClientId =
    '257787138037-6deiuvca1572r0a2vi7ou1v1nk00e5kt.apps.googleusercontent.com';

String reversedClientIdFromClientId(String clientId) {
  final prefix = clientId.split('.apps.googleusercontent.com').first;
  return 'com.googleusercontent.apps.$prefix';
}

String get kIosReversedScheme =>
    reversedClientIdFromClientId(kIosGoogleClientId);

bool isValidIosGoogleClientId(String clientId) {
  return clientId.isNotEmpty &&
      clientId.endsWith('.apps.googleusercontent.com') &&
      clientId.length > '.apps.googleusercontent.com'.length;
}
