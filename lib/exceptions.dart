class NoAnimationProperties implements Exception {
  final String message;

  NoAnimationProperties(this.message);

  @override
  String toString() => 'NoAnimationProperties: $message';
}

class NoGlyphChannels implements Exception {
  final String message;

  NoGlyphChannels(this.message);

  @override
  String toString() => 'NoGlyphChannels: $message';
}

class NoGlyphProgress implements Exception {
  final String message;

  NoGlyphProgress(this.message);

  @override
  String toString() => 'NoGlyphProgress: $message';
}

class GlyphChannelNotSupported implements Exception {
  final String message;

  GlyphChannelNotSupported(this.message);

  @override
  String toString() => 'GlyphChannelNotSupported: $message';
}

class InvalidGlyphProgressChannel implements Exception {
  final String message;

  InvalidGlyphProgressChannel(this.message);

  @override
  String toString() => 'InvalidGlyphProgressChannel: $message';
}
