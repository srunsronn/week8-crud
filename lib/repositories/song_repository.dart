import 'package:week8_crud/data/models/song.dart';

abstract class SongRepository {
  Future<Song> addSong({
    required String title,
    required String artist,
    required int releaseYear,
  });

  Future<List<Song>> getSongs();

  Future<Song> updateSong(Song song);

  Future<void> deleteSong(String id);
}