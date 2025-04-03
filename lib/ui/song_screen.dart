import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/song.dart';
import '../providers/song_provider.dart';

class SongScreen extends StatelessWidget {
  const SongScreen({super.key});

  void _onAddPressed(BuildContext context) {
    final songProvider = context.read<SongProvider>();
    songProvider.addSong(
      title: "New Song",
      artist: "New Artist",
      releaseYear: 2023,
    );
  }

  @override
  Widget build(BuildContext context) {
    final songProvider = Provider.of<SongProvider>(context);
    
    Widget content = const Text('');

    if (songProvider.isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (songProvider.hasError) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            Text(
              'Error: ${songProvider.songsState?.error}',
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => songProvider.fetchSongs(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (songProvider.hasData) {
      List<Song> songs = songProvider.songsState!.data!;

      if (songs.isEmpty) {
        content = const Center(child: Text("No songs yet"));
      } else {
        content = ListView.builder(
          itemCount: songs.length,
          itemBuilder:
              (context, index) => ListTile(
                title: Text(songs[index].title),
                subtitle: Text(
                  "${songs[index].artist} • ${songs[index].releaseYear}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    songProvider.deleteSong(songs[index].id);
                  },
                ),
              ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Songs'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () => songProvider.fetchSongs(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(child: content),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _onAddPressed(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
