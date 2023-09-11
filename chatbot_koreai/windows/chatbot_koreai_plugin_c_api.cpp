#include "include/chatbot_koreai/chatbot_koreai_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "chatbot_koreai_plugin.h"

void ChatbotKoreaiPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  chatbot_koreai::ChatbotKoreaiPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
