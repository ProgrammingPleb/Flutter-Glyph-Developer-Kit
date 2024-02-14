class PlayingMediaSessions {
  final List<MediaSession?> sessions;

  PlayingMediaSessions({required this.sessions});

  factory PlayingMediaSessions.fromMap(List<Object?> map) {
    return PlayingMediaSessions(
      sessions: List<MediaSession>.from(
        map.map(
          (x) => MediaSession.fromMap(
            x as Map<dynamic, dynamic>,
          ),
        ),
      ),
    );
  }
}

class MediaSession {
  final int state;
  final int position;
  final int length;
  final String packageName;

  MediaSession(
      {required this.state,
      required this.position,
      required this.length,
      required this.packageName});

  factory MediaSession.fromMap(Map<dynamic, dynamic> map) {
    return MediaSession(
      state: map["state"],
      position: map["position"],
      length: map["length"],
      packageName: map["packageName"],
    );
  }
}

class MediaStates {
  static int playing = 3;
  static int paused = 2;
  static int buffering = 6;
}
