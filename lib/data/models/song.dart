class Song {
  final String id;
  final String title;
  final String artist;
  final int releaseYear;

  Song({
    required this.id,
    required this.title,
    required this.artist,
    required this.releaseYear,
  });

  @override
  bool operator ==(Object other) {
    return other is Song && other.id == id;
  }

  @override
  int get hashCode => super.hashCode ^ id.hashCode;
}