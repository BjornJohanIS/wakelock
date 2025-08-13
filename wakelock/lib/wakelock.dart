import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:wakelock/src/windows_stub.dart' 
    if (dart.library.io) 'package:wakelock/src/windows_stub.dart'; // fallback stub
import 'package:wakelock_macos/wakelock_macos.dart';
import 'package:wakelock_platform_interface/wakelock_platform_interface.dart';

/// The [WakelockPlatformInterface] that is used by [Wakelock].
@visibleForTesting
var wakelockPlatformInstance = _defaultPlatformInstance;

/// Workaround for configuring platform instances until flutter/flutter#52267
WakelockPlatformInterface get _defaultPlatformInstance {
  if (kIsWeb) return WakelockPlatformInterface.instance;

  if (Platform.isMacOS) return WakelockMacOS();

  if (Platform.isWindows) return WakelockPlatformInterface.instance; // fallback if no Windows dependency

  return WakelockPlatformInterface.instance;
}

/// Class providing all wakelock functionality using static members.
class Wakelock {
  static Future<void> enable() => toggle(enable: true);
  static Future<void> disable() => toggle(enable: false);

  static Future<void> toggle({required bool enable}) {
    return wakelockPlatformInstance.toggle(enable: enable);
  }

  static Future<bool> get enabled => wakelockPlatformInstance.enabled;
}
