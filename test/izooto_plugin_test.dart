import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:izooto_plugin/iZootoPlugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('izooto_plugin');

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
    expect(await iZootoPlugin.platformVersion, '42');
  });
}
