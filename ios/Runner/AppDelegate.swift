import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  let controller = window?.rootViewController as! FlutterPluginRegistrar
  //let flutterViewController = FlutterViewController(project: nil, nibName: nil, bundle: nil)
          let bluetoothChannel = FlutterMethodChannel(name: "bluetooth_channel",  binaryMessenger: controller as! FlutterBinaryMessenger)
          BluetoothManager.register(with: controller)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
