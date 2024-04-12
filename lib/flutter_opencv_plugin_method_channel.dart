import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_opencv_plugin_platform_interface.dart';

/// An implementation of [FlutterOpencvPluginPlatform] that uses method channels.
class MethodChannelFlutterOpencvPlugin extends FlutterOpencvPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_opencv_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
