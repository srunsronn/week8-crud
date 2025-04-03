import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/song.dart';
import '../../providers/song_provider.dart';

class SongForm extends StatefulWidget {
  final Song? song; // null for adding, non-null for updating

  const SongForm({Key? key, this.song}) : super(key: key);

  @override
  State<SongForm> createState() => _SongFormState();
}

class _SongFormState extends State<SongForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _artistController;
  late TextEditingController _yearController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // If song is provided (edit mode), use its values, otherwise use empty values
    _titleController = TextEditingController(text: widget.song?.title ?? '');
    _artistController = TextEditingController(text: widget.song?.artist ?? '');
    _yearController = TextEditingController(
        text: widget.song?.releaseYear.toString() ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  // Handle form submission
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final songProvider = context.read<SongProvider>();
        final title = _titleController.text;
        final artist = _artistController.text;
        final releaseYear = int.parse(_yearController.text);

        if (widget.song == null) {
          // Add mode
          await songProvider.addSong(
            title: title,
            artist: artist,
            releaseYear: releaseYear,
          );
        } else {
          // Edit mode
          final updatedSong = Song(
            id: widget.song!.id,
            title: title,
            artist: artist,
            releaseYear: releaseYear,
          );
          await songProvider.updateSong(updatedSong);
        }

        if (mounted) {
          Navigator.pop(context, true); // Return success
        }
      } catch (error) {
        setState(() {
          _isLoading = false;
          _errorMessage = error.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.song != null;
    
    return AlertDialog(
      title: Text(isEditMode ? 'Edit Song' : 'Add New Song'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red.shade900),
                  ),
                ),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _artistController,
                decoration: const InputDecoration(
                  labelText: 'Artist',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an artist';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: 'Release Year',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a release year';
                  }
                  try {
                    final year = int.parse(value);
                    if (year < 1800 || year > DateTime.now().year) {
                      return 'Year must be between 1800 and ${DateTime.now().year}';
                    }
                  } catch (_) {
                    return 'Please enter a valid year';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submitForm,
          child: _isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(isEditMode ? 'Update' : 'Add'),
        ),
      ],
    );
  }
}