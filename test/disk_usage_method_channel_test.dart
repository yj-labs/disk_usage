import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:disk_usage/disk_usage_method_channel.dart';
import 'package:disk_usage/disk_usage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDiskUsage platform = MethodChannelDiskUsage();
  const MethodChannel channel = MethodChannel('disk_usage');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getDiskSpace') {
        final arguments = methodCall.arguments as Map<Object?, Object?>;
        final type = arguments['type'] as String;
        // 模拟返回不同的磁盘空间值
        return type == 'total'
            ? 1000000000
            : 500000000; // 1GB total, 500MB free
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('getDiskSpace total', () async {
    expect(await platform.getDiskSpace(DiskSpaceType.total, null), 1000000000);
  });

  test('getDiskSpace free', () async {
    expect(await platform.getDiskSpace(DiskSpaceType.free, null), 500000000);
  });

  test('getDiskSpace with path', () async {
    expect(
      await platform.getDiskSpace(DiskSpaceType.total, '/tmp'),
      1000000000,
    );
  });
}
