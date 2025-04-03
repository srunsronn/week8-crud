import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/models/song.dart';
import '../providers/song_provider.dart';
import 'widget/form_widget.dart';

class SongScreen extends StatelessWidget {
  const SongScreen({super.key});

  // Show the form dialog for adding a song
  void _showAddForm(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const SongForm(),
    );

    if (result == true) {
      // If the form was submitted successfully, show a snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Song added successfully!')),
        );
      }
    }
  }

  // Show the form dialog for editing a song
  void _showEditForm(BuildContext context, Song song) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => SongForm(song: song),
    );

    if (result == true) {
      // If the form was submitted successfully, show a snackbar
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Song updated successfully!')),
        );
      }
    }
  }

  // Show confirmation dialog for deleting a song
  void _confirmDelete(BuildContext context, Song song) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Song'),
            content: Text('Are you sure you want to delete "${song.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<SongProvider>().deleteSong(song.id);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Song deleted')));
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
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
          itemBuilder: (context, index) {
            final song = songs[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ListTile(
                title: Text(song.title),
                subtitle: Text("${song.artist} • ${song.releaseYear}"),
                onTap: () => _showEditForm(context, song),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showEditForm(context, song),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _confirmDelete(context, song),
                    ),
                  ],
                ),
              ),
            );
          },
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
      body: content,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => _showAddForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
