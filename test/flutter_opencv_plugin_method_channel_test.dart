import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_opencv_plugin/flutter_opencv_plugin_method_channel.dart';

void main() {
  MethodChannelFlutterOpencvPlugin platform = MethodChannelFlutterOpencvPlugin();
  const MethodChannel channel = MethodChannel('flutter_opencv_plugin');

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
    expect(await platform.getPlatformVersion(), '42');
  });
}
