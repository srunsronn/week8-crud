import 'package:week8_crud/data/models/song.dart';
import 'package:week8_crud/repositories/song_repository.dart';

class MockSongRepository implements SongRepository {
  final List<Song> _songs = [];
  int _nextId = 1;

  @override
  Future<Song> addSong({
    required String title,
    required String artist,
    required int releaseYear,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final newSong = Song(
      id: _nextId.toString(),
      title: title,
      artist: artist,
      releaseYear: releaseYear,
    );

    _nextId++;
    _songs.add(newSong);

    return newSong;
  }

  @override
  Future<void> deleteSong(String id) async {
    await Future.delayed(const Duration(seconds: 2));
    _songs.removeWhere((song) => song.id == id);
  }

  @override
  Future<List<Song>> getSongs() async {
    await Future.delayed(const Duration(seconds: 2));
    return _songs;
  }

  @override
  Future<Song> updateSong(Song song) async {
    await Future.delayed(const Duration(seconds: 2));

    final index = _songs.indexWhere((s) => s.id == song.id);

    if (index >= 0) {
      _songs[index] = song;
      return song;
    } else {
      throw Exception('Song not found');
    }
  }
}
