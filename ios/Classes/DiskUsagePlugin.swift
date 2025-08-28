import Flutter
import UIKit
import Foundation

public class DiskUsagePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "disk_usage", binaryMessenger: registrar.messenger())
    let instance = DiskUsagePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    if call.method == "getDiskSpace" {
      handleGetDiskSpace(call, result: result)
    } else {
      result(FlutterMethodNotImplemented)
    }
  }
  
  private func handleGetDiskSpace(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let args = call.arguments as? [String: Any],
          let typeString = args["type"] as? String else {
      result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing type argument", details: nil))
      return
    }
    
    let path = args["path"] as? String ?? NSHomeDirectory()
    
    do {
      let fileManager = FileManager.default
      let systemAttributes = try fileManager.attributesOfFileSystem(forPath: path)
      
      let diskSpace: Int64
      
      switch typeString {
      case "total":
        if let totalSpace = systemAttributes[.systemSize] as? NSNumber {
          diskSpace = totalSpace.int64Value
        } else {
          result(FlutterError(code: "UNAVAILABLE", message: "Total disk space unavailable", details: nil))
          return
        }
      case "free":
        if let freeSpace = systemAttributes[.systemFreeSize] as? NSNumber {
          diskSpace = freeSpace.int64Value
        } else {
          result(FlutterError(code: "UNAVAILABLE", message: "Free disk space unavailable", details: nil))
          return
        }
      default:
        result(FlutterError(code: "INVALID_TYPE", message: "Invalid disk space type: \(typeString)", details: nil))
        return
      }
      
      result(diskSpace)
    } catch {
      result(FlutterError(code: "SYSTEM_ERROR", message: "Failed to get disk space: \(error.localizedDescription)", details: nil))
    }
  }
}
