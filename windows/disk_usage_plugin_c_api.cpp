#include "include/disk_usage/disk_usage_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "disk_usage_plugin.h"

void DiskUsagePluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  disk_usage::DiskUsagePlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
