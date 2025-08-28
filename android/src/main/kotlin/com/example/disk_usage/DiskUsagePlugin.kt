package com.example.disk_usage

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import android.os.StatFs
import android.os.Environment
import java.io.File

/** DiskUsagePlugin */
class DiskUsagePlugin :
    FlutterPlugin,
    MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "disk_usage")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(
        call: MethodCall,
        result: Result
    ) {
        if (call.method == "getDiskSpace") {
            handleGetDiskSpace(call, result)
        } else {
            result.notImplemented()
        }
    }

    private fun handleGetDiskSpace(call: MethodCall, result: Result) {
        try {
            val type = call.argument<String>("type")
            val path = call.argument<String>("path")
            
            if (type == null) {
                result.error("INVALID_ARGUMENTS", "Missing type argument", null)
                return
            }
            
            val targetPath = path ?: Environment.getDataDirectory().absolutePath
            val file = File(targetPath)
            
            if (!file.exists()) {
                result.error("PATH_NOT_EXISTS", "Path does not exist: $targetPath", null)
                return
            }
            
            val stat = StatFs(file.absolutePath)
            
            val diskSpace = when (type) {
                "total" -> {
                    stat.blockSizeLong * stat.blockCountLong
                }
                "free" -> {
                    stat.blockSizeLong * stat.availableBlocksLong
                }
                else -> {
                    result.error("INVALID_TYPE", "Invalid disk space type: $type", null)
                    return
                }
            }
            
            result.success(diskSpace)
        } catch (e: Exception) {
            result.error("SYSTEM_ERROR", "Failed to get disk space: ${e.message}", null)
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
