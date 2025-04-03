import 'package:week8_crud/data/models/song.dart';

class SongDto {
  //convert from json to song model
  static Song fromJson(String id, Map<String, dynamic> json) {
    return Song(
      id: id,
      title: json['title'],
      artist: json['artist'],
      releaseYear: json['releaseYear'],
    );
  }

  //convert from song model to json
  static Map<String, dynamic> toJson(Song song) {
    return {
      'title': song.title,
      'artist': song.artist,
      'releaseYear': song.releaseYear,
    };
  }
}
