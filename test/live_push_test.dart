import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:live_push/live_push.dart';

void main() {
  const MethodChannel channel = MethodChannel('live_push');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await LivePush.platformVersion, '42');
  });
}
