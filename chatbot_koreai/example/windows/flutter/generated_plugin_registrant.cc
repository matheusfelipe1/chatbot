//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <chatbot_koreai/chatbot_koreai_plugin_c_api.h>
#include <file_selector_windows/file_selector_windows.h>
#include <url_launcher_windows/url_launcher_windows.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ChatbotKoreaiPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ChatbotKoreaiPluginCApi"));
  FileSelectorWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FileSelectorWindows"));
  UrlLauncherWindowsRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("UrlLauncherWindows"));
}
