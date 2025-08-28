#include "include/disk_usage/disk_usage_plugin.h"

#include <flutter_linux/flutter_linux.h>
#include <gtk/gtk.h>
#include <sys/utsname.h>
#include <sys/statvfs.h>

#include <cstring>

#include "disk_usage_plugin_private.h"

#define DISK_USAGE_PLUGIN(obj) \
  (G_TYPE_CHECK_INSTANCE_CAST((obj), disk_usage_plugin_get_type(), \
                              DiskUsagePlugin))

struct _DiskUsagePlugin {
  GObject parent_instance;
};

G_DEFINE_TYPE(DiskUsagePlugin, disk_usage_plugin, g_object_get_type())

// Called when a method call is received from Flutter.
static void disk_usage_plugin_handle_method_call(
    DiskUsagePlugin* self,
    FlMethodCall* method_call) {
  g_autoptr(FlMethodResponse) response = nullptr;

  const gchar* method = fl_method_call_get_name(method_call);

  if (strcmp(method, "getDiskSpace") == 0) {
    response = get_disk_space(method_call);
  } else {
    response = FL_METHOD_RESPONSE(fl_method_not_implemented_response_new());
  }

  fl_method_call_respond(method_call, response, nullptr);
}

FlMethodResponse* get_disk_space(FlMethodCall* method_call) {
  FlValue* args = fl_method_call_get_args(method_call);
  
  if (fl_value_get_type(args) != FL_VALUE_TYPE_MAP) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        "INVALID_ARGUMENTS", "Arguments must be a map", nullptr));
  }
  
  FlValue* type_value = fl_value_lookup_string(args, "type");
  if (!type_value || fl_value_get_type(type_value) != FL_VALUE_TYPE_STRING) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        "INVALID_ARGUMENTS", "Missing type argument", nullptr));
  }
  
  const gchar* type = fl_value_get_string(type_value);
  
  // Get path or use default
  const gchar* path = "/";
  FlValue* path_value = fl_value_lookup_string(args, "path");
  if (path_value && fl_value_get_type(path_value) == FL_VALUE_TYPE_STRING) {
    path = fl_value_get_string(path_value);
  }
  
  struct statvfs stat;
  if (statvfs(path, &stat) != 0) {
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        "SYSTEM_ERROR", "Failed to get disk space", nullptr));
  }
  
  int64_t disk_space;
  if (strcmp(type, "total") == 0) {
    disk_space = static_cast<int64_t>(stat.f_blocks) * stat.f_frsize;
  } else if (strcmp(type, "free") == 0) {
    disk_space = static_cast<int64_t>(stat.f_bavail) * stat.f_frsize;
  } else {
    g_autofree gchar* error_msg = g_strdup_printf("Invalid disk space type: %s", type);
    return FL_METHOD_RESPONSE(fl_method_error_response_new(
        "INVALID_TYPE", error_msg, nullptr));
  }
  
  g_autoptr(FlValue) result = fl_value_new_int(disk_space);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

FlMethodResponse* get_platform_version() {
  struct utsname uname_data = {};
  uname(&uname_data);
  g_autofree gchar *version = g_strdup_printf("Linux %s", uname_data.version);
  g_autoptr(FlValue) result = fl_value_new_string(version);
  return FL_METHOD_RESPONSE(fl_method_success_response_new(result));
}

static void disk_usage_plugin_dispose(GObject* object) {
  G_OBJECT_CLASS(disk_usage_plugin_parent_class)->dispose(object);
}

static void disk_usage_plugin_class_init(DiskUsagePluginClass* klass) {
  G_OBJECT_CLASS(klass)->dispose = disk_usage_plugin_dispose;
}

static void disk_usage_plugin_init(DiskUsagePlugin* self) {}

static void method_call_cb(FlMethodChannel* channel, FlMethodCall* method_call,
                           gpointer user_data) {
  DiskUsagePlugin* plugin = DISK_USAGE_PLUGIN(user_data);
  disk_usage_plugin_handle_method_call(plugin, method_call);
}

void disk_usage_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  DiskUsagePlugin* plugin = DISK_USAGE_PLUGIN(
      g_object_new(disk_usage_plugin_get_type(), nullptr));

  g_autoptr(FlStandardMethodCodec) codec = fl_standard_method_codec_new();
  g_autoptr(FlMethodChannel) channel =
      fl_method_channel_new(fl_plugin_registrar_get_messenger(registrar),
                            "disk_usage",
                            FL_METHOD_CODEC(codec));
  fl_method_channel_set_method_call_handler(channel, method_call_cb,
                                            g_object_ref(plugin),
                                            g_object_unref);

  g_object_unref(plugin);
}
