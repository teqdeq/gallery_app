import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_opencv_plugin_method_channel.dart';

abstract class FlutterOpencvPluginPlatform extends PlatformInterface {
  /// Constructs a FlutterOpencvPluginPlatform.
  FlutterOpencvPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterOpencvPluginPlatform _instance = MethodChannelFlutterOpencvPlugin();

  /// The default instance of [FlutterOpencvPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterOpencvPlugin].
  static FlutterOpencvPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterOpencvPluginPlatform] when
  /// they register themselves.
  static set instance(FlutterOpencvPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
