import Flutter
import GoogleMaps
import GoogleSignIn
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  var engine: FlutterEngine?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let key = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String ?? ""
    if !key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      GMSServices.provideAPIKey(key)
    } else {
      NSLog("GMSApiKey missing in Info.plist")
    }
    if engine == nil {
      let newEngine = FlutterEngine(name: "default_engine")
      newEngine.run()
      GeneratedPluginRegistrant.register(with: newEngine)
      engine = newEngine
    }
    if let engine = engine {
      let channel = FlutterMethodChannel(name: "kyradi/ios_config", binaryMessenger: engine.binaryMessenger)
      channel.setMethodCallHandler { call, result in
        switch call.method {
        case "getUrlSchemes":
          let types = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]]
          var schemes: [String] = []
          types?.forEach { item in
            if let list = item["CFBundleURLSchemes"] as? [String] {
              schemes.append(contentsOf: list)
            }
          }
          result(schemes)
        case "hasGoogleServicePlist":
          let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
          result(path != nil)
        case "hasFirebasePlist":
          let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")
          result(path != nil)
        case "hasGmsApiKey":
          let key = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String ?? ""
          result(!key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        case "getGoogleReversedClientId":
          if let path = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
             let dict = NSDictionary(contentsOfFile: path),
             let reversed = dict["REVERSED_CLIENT_ID"] as? String {
            result(reversed)
          } else {
            result("")
          }
        default:
          result(FlutterMethodNotImplemented)
        }
      }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    let handled = GIDSignIn.sharedInstance.handle(url)
    if handled {
      NSLog("GIDSignIn handled URL: %@", url.absoluteString)
    }
    return handled || super.application(application, open: url, options: options)
  }
}
