import Flutter
import UIKit

public class StartKoreAI: UIViewController {
    
    private var flutterEngine: FlutterEngine? = FlutterEngine(name: "chatbot_koreai")
    private var methodChannel: FlutterMethodChannel? = nil
    private var rootViewController: UIViewController? = nil
    private var flutterViewController: FlutterViewController? = nil
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @available(iOS 13.0, *)
    public func startFlutter() {
        let windowScene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive && $0 is UIWindowScene }) as? UIWindowScene
        let window = windowScene?.windows.first(where: \.isKeyWindow)
        rootViewController = window?.rootViewController
        flutterViewController = FlutterViewController(
        project: nil,
        nibName: nil,
        bundle: nil)
        flutterViewController!.modalPresentationStyle =  .overFullScreen
        flutterViewController!.isViewOpaque = false
        methodChannel = FlutterMethodChannel(name: "chatbot_koreai", binaryMessenger: flutterViewController!.binaryMessenger)
        flutterEngine!.run()
        ChatbotKoreaiPlugin.register(with: flutterEngine!.registrar(forPlugin: "chatbot_koreai")!)
        rootViewController?.present(flutterViewController!, animated: true)
        callMethods()
    }
    
    public func turnOff() {
        DispatchQueue.main.async {
            self.flutterViewController?.dismiss(animated: false, completion: {
                self.flutterEngine?.destroyContext()
                self.flutterEngine = nil
            })
            self.rootViewController?.dismiss(animated: false)
        }
    }
    
    private func callMethods() {
        methodChannel?.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                if call.method == "start" {
                    result(KoreAI.toJson())
                } else if call.method == "close" {
                    self.turnOff()
                } else {
                    result(FlutterMethodNotImplemented)
                }
            })
    }
    
}
