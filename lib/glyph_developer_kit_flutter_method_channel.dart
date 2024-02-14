import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'glyph_developer_kit_flutter_platform_interface.dart';

/// An implementation of [GlyphDeveloperKitFlutterPlatform] that uses method channels.
class MethodChannelGlyphDeveloperKitFlutter extends GlyphDeveloperKitFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('glyph_developer_kit_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
