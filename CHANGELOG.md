## 1.0.0

* Initial release
* Cross-platform support for iOS, Android, macOS, Windows, and Linux
* Get total and free disk space
* Simple and clean API with enum-based approach
* Null-safe implementation
* Platform-specific implementations:
  - iOS/macOS: FileManager.attributesOfFileSystem
  - Android: StatFs class
  - Windows: GetDiskFreeSpaceExW Win32 API
  - Linux: statvfs system call
