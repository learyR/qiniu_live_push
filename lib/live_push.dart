import 'dart:async';

import 'package:flutter/services.dart';

class LivePush {
  static const MethodChannel _channel =
      const MethodChannel('live_push');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
