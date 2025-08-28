// This is a basic Flutter integration test.
//
// Since integration tests run in a full Flutter application, they can interact
// with the host side of a plugin implementation, unlike Dart unit tests.
//
// For more information about Flutter integration tests, please see
// https://flutter.dev/to/integration-testing

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:disk_usage/disk_usage.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('disk space test', (WidgetTester tester) async {
    // 测试获取总空间
    final int? totalSpace = await DiskUsage.totalSpace();
    // 总空间应该大于0
    expect(totalSpace, isNotNull);
    expect(totalSpace! > 0, true);

    // 测试获取可用空间
    final int? freeSpace = await DiskUsage.freeSpace();
    // 可用空间应该大于0且小于等于总空间
    expect(freeSpace, isNotNull);
    expect(freeSpace! > 0, true);
    expect(freeSpace <= totalSpace, true);

    // 测试使用枚举方式获取
    final int? totalSpaceEnum = await DiskUsage.space(DiskSpaceType.total);
    final int? freeSpaceEnum = await DiskUsage.space(DiskSpaceType.free);

    // 应该和便捷方法返回相同的值
    expect(totalSpaceEnum, equals(totalSpace));
    expect(freeSpaceEnum, equals(freeSpace));
  });
}
