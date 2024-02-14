import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glyph_developer_kit_flutter/glyph_developer_kit_flutter_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelGlyphDeveloperKitFlutter platform = MethodChannelGlyphDeveloperKitFlutter();
  const MethodChannel channel = MethodChannel('glyph_developer_kit_flutter');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
