import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyC5hxzVs-UwVR_M4l67OArsWsOteyVECnA")
    GeneratedPluginRegistrant.register(with: self)
//    if FirebaseApp.app() == nil {
//        FirebaseApp.configure()
//    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
