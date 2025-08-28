import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'disk_usage_method_channel.dart';
import 'disk_usage.dart';

abstract class DiskUsagePlatform extends PlatformInterface {
  /// Constructs a DiskUsagePlatform.
  DiskUsagePlatform() : super(token: _token);

  static final Object _token = Object();

  static DiskUsagePlatform _instance = MethodChannelDiskUsage();

  /// The default instance of [DiskUsagePlatform] to use.
  ///
  /// Defaults to [MethodChannelDiskUsage].
  static DiskUsagePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DiskUsagePlatform] when
  /// they register themselves.
  static set instance(DiskUsagePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 获取磁盘空间信息
  ///
  /// [type] 磁盘空间类型
  /// [path] 要查询的路径
  ///
  /// 返回字节数，失败时返回 null
  Future<int?> getDiskSpace(DiskSpaceType type, String? path) {
    throw UnimplementedError('getDiskSpace() has not been implemented.');
  }
}
