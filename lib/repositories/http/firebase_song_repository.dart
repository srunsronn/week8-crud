import 'dart:convert';
import 'dart:io';

import 'package:week8_crud/data/dto/song_dto.dart';
import 'package:week8_crud/data/models/song.dart';
import 'package:week8_crud/repositories/song_repository.dart';
import 'package:http/http.dart' as http;

class FirebaseSongRepository implements SongRepository {
  static const String baseUrl = "https://week8-firebase-d580e-default-rtdb.asia-southeast1.firebasedatabase.app/";
  static const String songsPath = "songs";
  static const String allSongsUrl = "$baseUrl/$songsPath.json";

  //method to get url for a specific song
  String _getSongUrl(String songId) {
    return "$baseUrl/$songsPath/$songId.json";
  }

  @override
  Future<Song> addSong({
    required String title,
    required String artist,
    required int releaseYear,
  }) async {
    Uri uri = Uri.parse(allSongsUrl);

    final newSongData = {
      'title': title,
      'artist': artist,
      'releaseYear': releaseYear,
    };

    final http.Response response = await http.post(
      uri,
      body: json.encode(newSongData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == HttpStatus.ok) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return Song(
        id: responseData['name'],
        title: title,
        artist: artist,
        releaseYear: releaseYear,
      );
    } else {
      throw Exception('Failed to add song');
    }
  }

  @override
  Future<List<Song>> getSongs() async {
    Uri uri = Uri.parse(allSongsUrl);

    final http.Response response = await http.get(uri);

    if (response.statusCode == HttpStatus.ok) {
      final data = json.decode(response.body) as Map<String, dynamic>?;

      if (data == null) {
        return [];
      }
      return data.entries
          .map((entry) => SongDto.fromJson(entry.key, entry.value))
          .toList();
    } else {
      throw Exception('Failed to load songs');
    }
  }

  @override
  Future<void> deleteSong(String id) async {
    Uri uri = Uri.parse(_getSongUrl(id));
    final http.Response response = await http.delete(uri);

    if (response.statusCode != HttpStatus.ok) {
      throw Exception('Failed to delete song');
    }
  }

  @override
  Future<Song> updateSong(Song song) async {
    Uri uri = Uri.parse(_getSongUrl(song.id));

    final updateData = SongDto.toJson(song);

    final http.Response response = await http.put(
      uri,
      body: json.encode(updateData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == HttpStatus.ok) {
      return song;
    } else {
      throw Exception('Failed to update song');
    }
  }
}
