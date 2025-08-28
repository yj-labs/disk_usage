import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:disk_usage/disk_usage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int? _totalSpace;
  int? _freeSpace;
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    int? totalSpace;
    int? freeSpace;

    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      totalSpace = await DiskUsage.space(DiskSpaceType.total);
      freeSpace = await DiskUsage.space(DiskSpaceType.free);
    } on PlatformException {
      totalSpace = null;
      freeSpace = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _totalSpace = totalSpace;
      _freeSpace = freeSpace;
      _platformVersion = Platform.operatingSystem;
    });
  }

  Future<void> _refreshDiskSpace() async {
    await initPlatformState();
  }

  String _formatBytes(int? bytes) {
    if (bytes == null) return 'Unknown';
    if (bytes == 0) return '0 B';

    // 根据平台使用不同的计算方式
    // iOS和macOS使用十进制，其他平台使用二进制
    bool useDecimal = Platform.isIOS || Platform.isMacOS;

    List<String> suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    double divider = useDecimal ? 1000.0 : 1024.0;
    int i = 0;
    double size = bytes.toDouble();

    while (size >= divider && i < suffixes.length - 1) {
      size /= divider;
      i++;
    }

    return '${size.toStringAsFixed(i == 0 ? 0 : 1)} ${suffixes[i]}';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Disk Usage Plugin Example')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Platform: $_platformVersion',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Disk Space Information',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Space:'),
                          Text(
                            _formatBytes(_totalSpace),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Free Space:'),
                          Text(
                            _formatBytes(_freeSpace),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      if (_totalSpace != null && _freeSpace != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Used Space:'),
                            Text(
                              _formatBytes(_totalSpace! - _freeSpace!),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _refreshDiskSpace,
                  child: const Text('Refresh Disk Space'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
