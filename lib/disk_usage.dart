import 'disk_usage_platform_interface.dart';

/// 磁盘空间类型枚举
enum DiskSpaceType {
  /// 总容量
  total,

  /// 可用容量
  free,
}

/// 磁盘使用量工具类
///
/// 支持获取全平台的磁盘空间信息，包括iOS、Android、macOS、Windows和Linux。
/// 提供简单易用的API来获取总磁盘空间和可用磁盘空间。
///
/// 使用示例：
/// ```dart
/// // 获取总容量
/// final totalSpace = await DiskUsage.space(DiskSpaceType.total);
///
/// // 获取可用容量
/// final freeSpace = await DiskUsage.space(DiskSpaceType.free);
///
/// // 使用便捷方法
/// final total = await DiskUsage.totalSpace();
/// final free = await DiskUsage.freeSpace();
/// ```
///
/// 所有方法在获取失败时返回null而不是抛出异常，确保异常安全。
class DiskUsage {
  /// 获取磁盘空间信息
  ///
  /// [type] 磁盘空间类型：总容量或可用容量
  /// [path] 要查询的路径，默认为根目录
  ///
  /// 返回字节数，获取失败时返回 null
  ///
  /// 使用示例：
  /// ```dart
  /// // 获取总容量
  /// final totalSpace = await DiskUsage.space(DiskSpaceType.total);
  ///
  /// // 获取可用容量
  /// final freeSpace = await DiskUsage.space(DiskSpaceType.free);
  /// ```
  static Future<int?> space(DiskSpaceType type, [String? path]) {
    return DiskUsagePlatform.instance.getDiskSpace(type, path);
  }

  /// 获取总磁盘空间（便捷方法）
  ///
  /// [path] 要查询的路径，默认为根目录
  /// 返回字节数，获取失败时返回 null
  static Future<int?> totalSpace([String? path]) {
    return space(DiskSpaceType.total, path);
  }

  /// 获取可用磁盘空间（便捷方法）
  ///
  /// [path] 要查询的路径，默认为根目录
  /// 返回字节数，获取失败时返回 null
  static Future<int?> freeSpace([String? path]) {
    return space(DiskSpaceType.free, path);
  }
}
