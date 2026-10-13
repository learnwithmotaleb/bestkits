import Flutter
import UIKit
import Firebase
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // 1. Initialize Firebase
    FirebaseApp.configure()

    // 2. Register for remote notifications (APNs) — required for FCM
    if #available(iOS 10.0, *) {
      // For iOS 10+ display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self

      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }

    // Register with APNs to receive a device token
    application.registerForRemoteNotifications()

    // 3. Register Flutter plugins
    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
