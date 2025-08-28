import 'package:flutter_test/flutter_test.dart';
import 'package:disk_usage/disk_usage.dart';
import 'package:disk_usage/disk_usage_platform_interface.dart';
import 'package:disk_usage/disk_usage_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDiskUsagePlatform
    with MockPlatformInterfaceMixin
    implements DiskUsagePlatform {
  @override
  Future<int?> getDiskSpace(DiskSpaceType type, String? path) async {
    // 根据类型返回不同的模拟值
    if (type == DiskSpaceType.total) {
      return 1000000000; // 1GB
    } else {
      return 500000000; // 500MB
    }
  }
}

void main() {
  final DiskUsagePlatform initialPlatform = DiskUsagePlatform.instance;

  test('$MethodChannelDiskUsage is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDiskUsage>());
  });

  test('getDiskSpace returns correct values', () async {
    MockDiskUsagePlatform fakePlatform = MockDiskUsagePlatform();
    DiskUsagePlatform.instance = fakePlatform;

    // 测试获取总空间
    final int? totalSpace = await DiskUsage.totalSpace();
    expect(totalSpace, 1000000000);

    // 测试获取可用空间
    final int? freeSpace = await DiskUsage.freeSpace();
    expect(freeSpace, 500000000);

    // 测试使用枚举方式
    final int? totalSpaceEnum = await DiskUsage.space(DiskSpaceType.total);
    final int? freeSpaceEnum = await DiskUsage.space(DiskSpaceType.free);
    expect(totalSpaceEnum, 1000000000);
    expect(freeSpaceEnum, 500000000);
  });

  test('getDiskSpace with path', () async {
    MockDiskUsagePlatform fakePlatform = MockDiskUsagePlatform();
    DiskUsagePlatform.instance = fakePlatform;

    final int? totalSpace = await DiskUsage.totalSpace('/tmp');
    expect(totalSpace, 1000000000);
  });
}
