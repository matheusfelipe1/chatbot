#ifndef FLUTTER_PLUGIN_CHATBOT_KOREAI_PLUGIN_H_
#define FLUTTER_PLUGIN_CHATBOT_KOREAI_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace chatbot_koreai {

class ChatbotKoreaiPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  ChatbotKoreaiPlugin();

  virtual ~ChatbotKoreaiPlugin();

  // Disallow copy and assign.
  ChatbotKoreaiPlugin(const ChatbotKoreaiPlugin&) = delete;
  ChatbotKoreaiPlugin& operator=(const ChatbotKoreaiPlugin&) = delete;

 private:
  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace chatbot_koreai

#endif  // FLUTTER_PLUGIN_CHATBOT_KOREAI_PLUGIN_H_
