import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.petsmore.tele/clipboard", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler { (call, result) in
      if call.method == "copyImageToClipboard" {
        guard let args = call.arguments as? FlutterStandardTypedData else {
          result(FlutterError(code: "INVALID_ARGS", message: "Expected image bytes", details: nil))
          return
        }
        let image = UIImage(data: args.data)
        if let image = image {
          UIPasteboard.general.image = image
          result(true)
        } else {
          result(FlutterError(code: "INVALID_IMAGE", message: "Could not create image from bytes", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
