import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:win_utils/win_utils.dart';

void main() {
  const MethodChannel channel = MethodChannel('win_utils');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await WinUtils.platformVersion, '42');
  });
}
