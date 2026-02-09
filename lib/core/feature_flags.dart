class FeatureFlags {
  FeatureFlags._();

  static const bool ffNewUI = bool.fromEnvironment(
    'FF_NEW_UI',
    defaultValue: true,
  );
  static const bool ffTravelCompanion = bool.fromEnvironment(
    'FF_TRAVEL_COMPANION',
    defaultValue: true,
  );
  static const bool ffProNotifications = bool.fromEnvironment(
    'FF_PRO_NOTIFICATIONS',
    defaultValue: true,
  );
  static const bool ffNewPaymentsFlow = bool.fromEnvironment(
    'FF_NEW_PAYMENTS_FLOW',
    defaultValue: true,
  );

  static Map<String, bool> snapshot() {
    return {
      'ffNewUI': ffNewUI,
      'ffTravelCompanion': ffTravelCompanion,
      'ffProNotifications': ffProNotifications,
      'ffNewPaymentsFlow': ffNewPaymentsFlow,
    };
  }
}
