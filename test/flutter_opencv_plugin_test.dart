import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_opencv_plugin/flutter_opencv_plugin.dart';
import 'package:flutter_opencv_plugin/flutter_opencv_plugin_platform_interface.dart';
import 'package:flutter_opencv_plugin/flutter_opencv_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterOpencvPluginPlatform
    with MockPlatformInterfaceMixin
    implements FlutterOpencvPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterOpencvPluginPlatform initialPlatform = FlutterOpencvPluginPlatform.instance;

  test('$MethodChannelFlutterOpencvPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterOpencvPlugin>());
  });

  test('getPlatformVersion', () async {
    FlutterOpencvPlugin flutterOpencvPlugin = FlutterOpencvPlugin();
    MockFlutterOpencvPluginPlatform fakePlatform = MockFlutterOpencvPluginPlatform();
    FlutterOpencvPluginPlatform.instance = fakePlatform;

    expect(await flutterOpencvPlugin.getPlatformVersion(), '42');
  });
}
