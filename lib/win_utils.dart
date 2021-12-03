
import 'dart:async';

import 'package:flutter/services.dart';

class WinUtils {
  static const MethodChannel _channel = MethodChannel('win_utils');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
