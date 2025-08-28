#include "disk_usage_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <sstream>

namespace disk_usage {

// static
void DiskUsagePlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  auto channel =
      std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
          registrar->messenger(), "disk_usage",
          &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<DiskUsagePlugin>();

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

DiskUsagePlugin::DiskUsagePlugin() {}

DiskUsagePlugin::~DiskUsagePlugin() {}

void DiskUsagePlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("getDiskSpace") == 0) {
    HandleGetDiskSpace(method_call, std::move(result));
  } else {
    result->NotImplemented();
  }
}

void DiskUsagePlugin::HandleGetDiskSpace(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  
  const auto* arguments = std::get_if<flutter::EncodableMap>(method_call.arguments());
  if (!arguments) {
    result->Error("INVALID_ARGUMENTS", "Arguments must be a map");
    return;
  }

  auto type_it = arguments->find(flutter::EncodableValue("type"));
  if (type_it == arguments->end() || !std::holds_alternative<std::string>(type_it->second)) {
    result->Error("INVALID_ARGUMENTS", "Missing type argument");
    return;
  }

  std::string type = std::get<std::string>(type_it->second);
  
  // Get path argument or use default
  std::string path = "C:\\";
  auto path_it = arguments->find(flutter::EncodableValue("path"));
  if (path_it != arguments->end() && std::holds_alternative<std::string>(path_it->second)) {
    path = std::get<std::string>(path_it->second);
  }

  ULARGE_INTEGER freeBytesToCaller, totalBytes, freeBytes;
  std::wstring wpath(path.begin(), path.end());
  
  if (!GetDiskFreeSpaceExW(wpath.c_str(), &freeBytesToCaller, &totalBytes, &freeBytes)) {
    result->Error("SYSTEM_ERROR", "Failed to get disk space");
    return;
  }

  int64_t diskSpace;
  if (type == "total") {
    diskSpace = static_cast<int64_t>(totalBytes.QuadPart);
  } else if (type == "free") {
    diskSpace = static_cast<int64_t>(freeBytes.QuadPart);
  } else {
    result->Error("INVALID_TYPE", "Invalid disk space type: " + type);
    return;
  }

  result->Success(flutter::EncodableValue(diskSpace));
}

}  // namespace disk_usage
