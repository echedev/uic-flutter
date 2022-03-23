// ignore_for_file: public_member_api_docs

import 'dart:io' as io;

import 'platform.dart';

PlatformType get currentPlatform {
  if (io.Platform.isWindows) return PlatformType.windows;
  if (io.Platform.isFuchsia) return PlatformType.fuchsia;
  if (io.Platform.isMacOS) return PlatformType.macOS;
  if (io.Platform.isLinux) return PlatformType.linux;
  if (io.Platform.isIOS) return PlatformType.iOS;
  return PlatformType.android;
}
