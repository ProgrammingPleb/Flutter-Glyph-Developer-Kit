import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:glyph_developer_kit_flutter/exceptions.dart';
import 'package:glyph_developer_kit_flutter/glyph_mappings/phone_1.dart';
import 'package:glyph_developer_kit_flutter/glyph_mappings/phone_2.dart';
import 'package:glyph_developer_kit_flutter/models/media_sessions.dart';

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

  Future<void> _toggleGlyphs(GlyphData glyphData) async {
    try {
      await _platform.invokeMethod<bool>("toggleGlyph", {
        "channels": glyphData.channels,
      });
    } on PlatformException catch (e) {
      _logger.e(e.message, error: e);
    }
  }

  Future<void> _animateGlyphs(GlyphData glyphData) async {
    try {
      await _platform.invokeMethod<bool>("animateGlyph", {
        "period": glyphData.period,
        "cycles": glyphData.cycles,
        "interval": glyphData.interval,
        "channels": glyphData.channels,
      });
    } on PlatformException catch (e) {
      _logger.e(e.message, error: e);
    }
  }

  Future<void> _displayGlyphProgress(GlyphData glyphData) async {
    try {
      await _platform.invokeMethod<bool>("displayGlyphProgress", {
        "progress": glyphData.progress,
        "reverse": glyphData.reverse,
        "channels": glyphData.channels,
      });
    } on PlatformException catch (e) {
      _logger.e(e.message, error: e);
    }
  }

  Future<PlayingMediaSessions> getMediaControls() async {
    List<Object?> result = [];
    try {
      result = await _platform.invokeMethod("getMediaControls");
    } on PlatformException catch (e) {
      _logger.e(e.message, error: e);
    }

    return PlayingMediaSessions.fromMap(result);
  }
}

class GlyphData {
  int? period;
  int? cycles;
  int? interval;
  int? progress;
  bool reverse;
  List<int> channels;
  final GlyphsPlatform _platform = GlyphsPlatform();

  GlyphData({
    required this.channels,
    this.period,
    this.cycles,
    this.interval,
    this.progress,
    this.reverse = false,
  });

  void toggleGlyphs() {
    _platform._toggleGlyphs(this);
  }

  void animateGlyphs() {
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

  void displayGlyphProgress() async {
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
      GlyphData(
        channels: supportedSelectedChannels,
        progress: progress,
        reverse: reverse,
      ),
    );
  }
}
