// ignore_for_file: public_member_api_docs

import 'platform_web.dart' if (dart.library.io) 'platform_io.dart';

abstract class Platform {
  static bool get isWeb => currentPlatform == PlatformType.web;

  static bool get isMacOS => currentPlatform == PlatformType.macOS;

  static bool get isWindows => currentPlatform == PlatformType.windows;

  static bool get isLinux => currentPlatform == PlatformType.linux;

  static bool get isAndroid => currentPlatform == PlatformType.android;

  static bool get isIOS => currentPlatform == PlatformType.iOS;

  static bool get isFuchsia => currentPlatform == PlatformType.fuchsia;
}

enum PlatformType { web, windows, linux, macOS, android, fuchsia, iOS }
