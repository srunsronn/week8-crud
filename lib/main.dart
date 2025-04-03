import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import your song-specific classes
import 'providers/song_provider.dart';
import 'repositories/song_repository.dart';
import 'repositories/http/firebase_song_repository.dart';
import 'ui/song_screen.dart';

void main() {
  // Ensure Flutter is initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();

  // Create repository
  final SongRepository songRepository = FirebaseSongRepository();

  // Run app
  runApp(
    ChangeNotifierProvider(
      create: (context) => SongProvider(songRepository),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Song CRUD Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SongScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
