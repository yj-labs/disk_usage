#ifndef FLUTTER_PLUGIN_DISK_USAGE_PLUGIN_H_
#define FLUTTER_PLUGIN_DISK_USAGE_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace disk_usage {

class DiskUsagePlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  DiskUsagePlugin();

  virtual ~DiskUsagePlugin();

  // Disallow copy and assign.
  DiskUsagePlugin(const DiskUsagePlugin&) = delete;
  DiskUsagePlugin& operator=(const DiskUsagePlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

 private:
  // Handle getDiskSpace method call
  void HandleGetDiskSpace(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace disk_usage

#endif  // FLUTTER_PLUGIN_DISK_USAGE_PLUGIN_H_
