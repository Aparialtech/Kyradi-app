import Flutter
import UIKit

@available(iOS 13.0, *)
@objc class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    NSLog("SceneDelegate.willConnectTo called")
    guard let windowScene = scene as? UIWindowScene else { return }

    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    let engine: FlutterEngine
    if let existing = appDelegate?.engine {
      engine = existing
    } else {
      let newEngine = FlutterEngine(name: "default_engine")
      newEngine.run()
      GeneratedPluginRegistrant.register(with: newEngine)
      appDelegate?.engine = newEngine
      engine = newEngine
    }

    let flutterVC = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
    let window = UIWindow(windowScene: windowScene)
    window.rootViewController = flutterVC
    window.makeKeyAndVisible()
    self.window = window
    appDelegate?.window = window
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    NSLog("SceneDelegate.sceneDidBecomeActive")
  }
}
