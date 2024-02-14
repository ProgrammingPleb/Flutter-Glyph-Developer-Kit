import 'package:flutter_test/flutter_test.dart';
import 'package:glyph_developer_kit_flutter/glyph_developer_kit_flutter.dart';
import 'package:glyph_developer_kit_flutter/glyph_developer_kit_flutter_platform_interface.dart';
import 'package:glyph_developer_kit_flutter/glyph_developer_kit_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGlyphDeveloperKitFlutterPlatform
    with MockPlatformInterfaceMixin
    implements GlyphDeveloperKitFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GlyphDeveloperKitFlutterPlatform initialPlatform = GlyphDeveloperKitFlutterPlatform.instance;

  test('$MethodChannelGlyphDeveloperKitFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGlyphDeveloperKitFlutter>());
  });

  test('getPlatformVersion', () async {
    GlyphDeveloperKitFlutter glyphDeveloperKitFlutterPlugin = GlyphDeveloperKitFlutter();
    MockGlyphDeveloperKitFlutterPlatform fakePlatform = MockGlyphDeveloperKitFlutterPlatform();
    GlyphDeveloperKitFlutterPlatform.instance = fakePlatform;

    expect(await glyphDeveloperKitFlutterPlugin.getPlatformVersion(), '42');
  });
}
