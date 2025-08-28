import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'disk_usage_platform_interface.dart';
import 'disk_usage.dart';

/// An implementation of [DiskUsagePlatform] that uses method channels.
class MethodChannelDiskUsage extends DiskUsagePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('disk_usage');

  @override
  Future<int?> getDiskSpace(DiskSpaceType type, String? path) async {
    try {
      final result = await methodChannel.invokeMethod<int>('getDiskSpace', {
        'type': type.name,
        'path': path,
      });
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('DiskUsage: Failed to get disk space: $e');
      }
      return null;
    }
  }
}
