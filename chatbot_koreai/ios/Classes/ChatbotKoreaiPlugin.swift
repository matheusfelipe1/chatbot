import Flutter
import UIKit


public class ChatbotKoreaiPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "chatbot_koreai", binaryMessenger: registrar.messenger())
    let instance = ChatbotKoreaiPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
    
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {  
  }
}
