# disk_usage

A Flutter plugin for getting disk space information on all platforms.

## Features

- ✅ Get total disk space
- ✅ Get free disk space
- ✅ Cross-platform support (iOS, Android, macOS, Windows, Linux)
- ✅ Simple and clean API
- ✅ Null-safe implementation

## Platforms Support

| Platform | Supported |
|----------|-----------|
| iOS      | ✅        |
| Android  | ✅        |
| macOS    | ✅        |
| Windows  | ✅        |
| Linux    | ✅        |

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  disk_usage: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:disk_usage/disk_usage.dart';

// Get total disk space
final totalSpace = await DiskUsage.space(DiskSpaceType.total);
print('Total space: $totalSpace bytes');

// Get free disk space
final freeSpace = await DiskUsage.space(DiskSpaceType.free);
print('Free space: $freeSpace bytes');
```

### Convenience Methods

```dart
// Get total space (convenience method)
final totalSpace = await DiskUsage.getTotalSpace();

// Get free space (convenience method)
final freeSpace = await DiskUsage.getFreeSpace();
```

### With Custom Path

```dart
// Get disk space for a specific path
final totalSpace = await DiskUsage.space(DiskSpaceType.total, '/custom/path');
final freeSpace = await DiskUsage.space(DiskSpaceType.free, '/custom/path');
```

### Error Handling

```dart
try {
  final totalSpace = await DiskUsage.space(DiskSpaceType.total);
  if (totalSpace != null) {
    print('Total space: $totalSpace bytes');
  } else {
    print('Failed to get disk space');
  }
} catch (e) {
  print('Error: $e');
}
```

## API Reference

### DiskSpaceType

An enum representing the type of disk space to retrieve:

- `DiskSpaceType.total` - Total disk capacity
- `DiskSpaceType.free` - Available free space

### DiskUsage

The main class for disk usage operations.

#### Methods

##### `static Future<int?> space(DiskSpaceType type, [String? path])`

Gets disk space information.

**Parameters:**
- `type` - The type of disk space to retrieve
- `path` - Optional path to query (defaults to root directory)

**Returns:**
- `Future<int?>` - The disk space in bytes, or `null` if the operation fails

##### `static Future<int?> getTotalSpace([String? path])`

Convenience method to get total disk space.

##### `static Future<int?> getFreeSpace([String? path])`

Convenience method to get free disk space.

## Example App

See the [example](example/) directory for a complete sample app that demonstrates how to use this plugin.

## Platform Implementation Details

### iOS/macOS
Uses `FileManager.default.attributesOfFileSystem(forPath:)` with `.systemSize` and `.systemFreeSize` keys.

### Android
Uses `StatFs` class to get disk space information.

### Windows
Uses `GetDiskFreeSpaceExW` Win32 API.

### Linux
Uses `statvfs` system call.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.