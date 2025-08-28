//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <disk_usage/disk_usage_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) disk_usage_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DiskUsagePlugin");
  disk_usage_plugin_register_with_registrar(disk_usage_registrar);
}
