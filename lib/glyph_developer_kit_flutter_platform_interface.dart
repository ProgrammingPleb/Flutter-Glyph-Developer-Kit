import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'glyph_developer_kit_flutter_method_channel.dart';

abstract class GlyphDeveloperKitFlutterPlatform extends PlatformInterface {
  /// Constructs a GlyphDeveloperKitFlutterPlatform.
  GlyphDeveloperKitFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static GlyphDeveloperKitFlutterPlatform _instance = MethodChannelGlyphDeveloperKitFlutter();

  /// The default instance of [GlyphDeveloperKitFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelGlyphDeveloperKitFlutter].
  static GlyphDeveloperKitFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GlyphDeveloperKitFlutterPlatform] when
  /// they register themselves.
  static set instance(GlyphDeveloperKitFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
