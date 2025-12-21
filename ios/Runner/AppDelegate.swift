import Flutter
import GoogleMaps
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  var engine: FlutterEngine?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("REMOVED_GOOGLE_KEY")
    if engine == nil {
      let newEngine = FlutterEngine(name: "default_engine")
      newEngine.run()
      GeneratedPluginRegistrant.register(with: newEngine)
      engine = newEngine
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
