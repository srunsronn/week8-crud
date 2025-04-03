import 'package:flutter/material.dart';
import 'package:week8_crud/data/models/song.dart';
import 'package:week8_crud/repositories/song_repository.dart';
import 'package:week8_crud/utils/async_value.dart';

class SongProvider extends ChangeNotifier {
  final SongRepository _repository;
  AsyncValue<List<Song>>? songsState;

  SongProvider(this._repository) {
    fetchSongs();
  }

  bool get isLoading =>
      songsState != null && songsState!.state == AsyncValueState.loading;

  bool get hasData =>
      songsState != null && songsState!.state == AsyncValueState.success;

  bool get hasError =>
      songsState != null && songsState!.state == AsyncValueState.error;

  Future<void> fetchSongs() async {
    try {
      // Set loading state
      songsState = AsyncValue.loading();
      notifyListeners();

      // Fetch songs
      final songs = await _repository.getSongs();
      songsState = AsyncValue.success(songs);
      print("SUCCESS: fetched ${songs.length} songs");
    } catch (error) {
      print("ERROR fetching songs: $error");
      songsState = AsyncValue.error(error);
    }

    notifyListeners();
  }
}
