
import 'glyph_developer_kit_flutter_platform_interface.dart';

class GlyphDeveloperKitFlutter {
  Future<String?> getPlatformVersion() {
    return GlyphDeveloperKitFlutterPlatform.instance.getPlatformVersion();
  }
}
