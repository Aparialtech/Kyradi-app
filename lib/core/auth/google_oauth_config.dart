const String kIosGoogleClientId =
    '143197560587-inbditnleo9t3it24lfk49gg4s2v3r7h.apps.googleusercontent.com';
const String kAndroidGoogleClientId =
    '143197560587-du4ii0ou3l883ks15lofjc5r105aunn7.apps.googleusercontent.com';
const String kWebGoogleClientId =
    '143197560587-du4ii0ou3l883ks15lofjc5r105aunn7.apps.googleusercontent.com';

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

String maskClientId(String clientId) {
  if (clientId.isEmpty) return 'EMPTY';
  final tail = clientId.length <= 8 ? clientId : clientId.substring(clientId.length - 8);
  return '***$tail';
}
