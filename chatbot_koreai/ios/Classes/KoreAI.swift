import Flutter
import UIKit

public class KoreAI: NSObject {
    public static var botId: String = ""
    public static var clientId: String = ""
    public static var clientSecret: String = ""
    public static var userId: String = ""
    public static var assertion: String = ""
    public static var chatBot: String = ""
    public static var userInfo: [String: Any]  = [:]
    
    private override init() {}
    
    public static func toJson() -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["botId"] = botId
        dictionary["clientId"] = clientId
        dictionary["clientSecret"] = clientSecret
        dictionary["userId"] = userId
        dictionary["assertion"] = assertion
        dictionary["chatBot"] = chatBot
        dictionary["userInfo"] = userInfo
        return dictionary
    }
    
    public static func configureChatbot(
        botId: String,
        clientId: String,
        clientSecret: String,
        userId: String,
        assertion: String,
        chatbot: String,
        userInfo: [String: Any]
    ) {
        self.botId = botId
        self.clientId = clientId
        self.clientSecret = clientSecret
        self.userId = userId
        self.assertion = assertion
        self.chatBot = chatbot
        self.userInfo = userInfo
    }
}
