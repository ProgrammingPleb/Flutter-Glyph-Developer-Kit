import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:glyph_developer_kit_flutter/exceptions.dart';
import 'package:glyph_developer_kit_flutter/glyph_mappings/phone_1.dart';
import 'package:glyph_developer_kit_flutter/glyph_mappings/phone_2.dart';

class GlyphsPlatform {
  final _platform = const MethodChannel("com.nothing.ketchum/glyphs");
  final _logger = Logger();

  Future<bool> checkIfNothingPhone1() async {
    bool? result;

    try {
      result = await _platform.invokeMethod<bool>("isNothingPhone1");
    } on PlatformException catch (e) {
      _logger.e(e.message, error: e);
    }

    return result ?? false;
  }

  Future<bool> checkIfNothingPhone2() async {
    bool? result;

    try {
      result = await _platform.invokeMethod<bool>("isNothingPhone2");
    } on PlatformException catch (e) {
      _logger.e(e.message, error: e);
    }

    return result ?? false;
  }

  Future<void> _toggleGlyphs(GlyphFrame glyphFrame) async {
    try {
      await _platform.invokeMethod<bool>("toggleGlyph", {
        "channels": glyphFrame.channels,
      });
    } on PlatformException catch (e) {
      _logger.e(e.message, error: e);
    }
  }

  Future<void> _animateGlyphs(GlyphFrame glyphFrame) async {
    try {
      await _platform.invokeMethod<bool>("animateGlyph", {
        "period": glyphFrame.period,
        "cycles": glyphFrame.cycles,
        "interval": glyphFrame.interval,
        "channels": glyphFrame.channels,
      });
    } on PlatformException catch (e) {
      _logger.e(e.message, error: e);
    }
  }

  Future<void> _displayGlyphProgress(GlyphFrame glyphFrame) async {
    try {
      await _platform.invokeMethod<bool>("displayGlyphProgress", {
        "progress": glyphFrame.progress,
        "reverse": glyphFrame.reverse,
        "channels": glyphFrame.channels,
      });
    } on PlatformException catch (e) {
      _logger.e(e.message, error: e);
    }
  }

  Future<bool> _checkIfManagerInit() async {
    bool isInit = false;

    try {
      isInit = await _platform.invokeMethod<bool>("isManagerInit") ?? false;
    } on PlatformException catch (e) {
      _logger.e(e.message, error: e);
    }

    return isInit;
  }
}

class GlyphFrame {
  int? period;
  int? cycles;
  int? interval;
  int? progress;
  bool reverse;
  List<int> channels;
  final GlyphsPlatform _platform = GlyphsPlatform();

  GlyphFrame({
    required this.channels,
    this.period,
    this.cycles,
    this.interval,
    this.progress,
    this.reverse = false,
  });

  Future<String?> _checkChannelValidity() async {
    bool isPhone1 = await _platform.checkIfNothingPhone1();
    for (int channel in channels) {
      if (channel > 32) {
        String modelNum = isPhone1 ? "1" : "2";
        return "The Nothing Phone ($modelNum) does not support channel "
            "number $channel.\n"
            "Consider checking if the channels given are supported on the "
            "Nothing Phone $modelNum.\n"
            "A possible solution is to use the NP${modelNum}GlyphMappings "
            "class.";
      }
      if (channel > 14 && isPhone1) {
        return "The Nothing Phone (1) does not support channel "
            "number $channel.\n"
            "Consider checking if the channels given are supported on the "
            "Nothing Phone (1).";
      }
    }
    return null;
  }

  Future<void> toggleGlyphs() async {
    if (!await _platform._checkIfManagerInit()) {
      throw GlyphManagerNotInit("The Glyph Manager was not initialized.\n\n"
          "If you are the developer of this application, please report this to "
          "the issue tab for this plugin:\nhttps://github.com/ProgrammingPleb/"
          "Flutter-Glyph-Developer-Kit/issues\n"
          "Do not report this to the official Glyph Developer Kit repository.");
    }

    String? errorMsg = await _checkChannelValidity();
    if (errorMsg != null) {
      throw GlyphChannelNotSupported(errorMsg);
    }

    _platform._toggleGlyphs(this);
  }

  Future<void> animateGlyphs() async {
    if (!await _platform._checkIfManagerInit()) {
      throw GlyphManagerNotInit("The Glyph Manager was not initialized.\n\n"
          "If you are the developer of this application, please report this to "
          "the issue tab for this plugin:\nhttps://github.com/ProgrammingPleb/"
          "Flutter-Glyph-Developer-Kit/issues\n"
          "Do not report this to the official Glyph Developer Kit repository.");
    }

    String? errorMsg = await _checkChannelValidity();
    if (errorMsg != null) {
      throw GlyphChannelNotSupported(errorMsg);
    }

    if (period == null && cycles == null && interval == null) {
      throw NoAnimationProperties(
          "There are no animation properties for this glyph.\n"
          "Consider setting the value for `period`, `cycles` or `interval` "
          "in the GlyphData object.");
    }
    if (channels == []) {
      throw NoGlyphChannels("There are no glyph channels to be animated.\n"
          "Consider setting the glyph channels in the GlyphData object.");
    }

    _platform._animateGlyphs(this);
  }

  Future<void> displayGlyphProgress() async {
    if (!await _platform._checkIfManagerInit()) {
      throw GlyphManagerNotInit("The Glyph Manager was not initialized.\n\n"
          "If you are the developer of this application, please report this to "
          "the issue tab for this plugin:\nhttps://github.com/ProgrammingPleb/"
          "Flutter-Glyph-Developer-Kit/issues\n"
          "Do not report this to the official Glyph Developer Kit repository.");
    }

    bool nothingPhone1 = await _platform.checkIfNothingPhone1();
    bool nothingPhone2 = await _platform.checkIfNothingPhone2();

    // Check if no channels are provided.
    if (channels == []) {
      throw NoGlyphChannels("There are no glyph channels to be animated.\n"
          "Consider setting the glyph channels in the GlyphData object.");
    }
    // Check if no progress value is provided.
    if (progress == null) {
      throw NoGlyphProgress("There is no glyph progress that is set.\n"
          "Consider setting the glyph's `progress` in the GlyphData object.");
    }

    // Check if `C1_1` channel is used on the Nothing Phone (1).
    if (channels.contains(NP2GlyphMappings.C1_1) &&
        await _platform.checkIfNothingPhone1()) {
      throw GlyphChannelNotSupported(
        "The Nothing Phone (1) does not support the C1 channel.\n"
        "Consider using the D1 channel in the GlyphData object.",
      );
    }
    // Check if the channels do not contain `C1_1` (for Nothing Phone (2) only)
    // and/or `D1_1` (for both devices).
    if (!channels.contains(NP1GlyphMappings.D1_1) && nothingPhone1) {
      throw InvalidGlyphProgressChannel(
          "The glyph channels provided are invalid for "
          "the use of `displayGlyphProgress()`.\n"
          "Consider using the `D1_1` channel instead in the GlyphData object.");
    }
    if (!channels.contains(NP2GlyphMappings.C1_1) &&
        !channels.contains(NP2GlyphMappings.D1_1) &&
        nothingPhone2) {
      throw InvalidGlyphProgressChannel(
          "The glyph channels provided are invalid for "
          "the use of `displayGlyphProgress()`.\n"
          "Consider using the `C1_1` or `D1_1` channel instead in the "
          "GlyphData object.");
    }

    // Filter the channels so that only supported channels (`C1_1`/`D1_1`) are
    // passed to `displayProgress()`.
    List<int> supportedSelectedChannels = [];
    if (nothingPhone1) {
      supportedSelectedChannels.add(NP1GlyphMappings.D1_1);
    }
    if (nothingPhone2) {
      if (channels.contains(NP2GlyphMappings.C1_1)) {
        supportedSelectedChannels.add(NP2GlyphMappings.C1_1);
      }
      if (channels.contains(NP2GlyphMappings.D1_1)) {
        supportedSelectedChannels.add(NP2GlyphMappings.D1_1);
      }
    }

    _platform._displayGlyphProgress(
      GlyphFrame(
        channels: supportedSelectedChannels,
        progress: progress,
        reverse: reverse,
      ),
    );
  }
}
