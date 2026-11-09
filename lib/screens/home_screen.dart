import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../providers/note_provider.dart';
import '../widgets/note_card.dart';
import 'add_note_screen.dart';
import 'edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController =
      TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const AddNoteScreen(),
      ),
    );
  }

  void _openEditNote(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditNoteScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NoteProvider>();

    final filteredNotes = provider.notes.where((note) {
      final title = note.title.toLowerCase();
      final content = note.content.toLowerCase();
      final query = _searchQuery.toLowerCase();

      return title.contains(query) ||
          content.contains(query);
    }).toList();

    final pinnedNotes = filteredNotes
        .where((note) => note.isPinned)
        .toList();

    final otherNotes = filteredNotes
        .where((note) => !note.isPinned)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFBF5),

      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFBF5),
        elevation: 0,
        title: const Text(
          'Notato',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Settings feature will be added later.
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: Color(0xFF333333),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your thoughts, organized.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 20),

            // SEARCH BAR
            TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search your notes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                        icon: const Icon(Icons.close),
                      )
                    : null,
                filled: true,
                fillColor: Colors.amber.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 25),

            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: provider.loadNotes,
                      child: filteredNotes.isEmpty
                          ? ListView(
                              physics:
                                  const AlwaysScrollableScrollPhysics(),
                              children: [
                                const SizedBox(height: 100),
                                Icon(
                                  Icons.note_alt_outlined,
                                  size: 65,
                                  color: Colors.grey.shade400,
                                ),
                                const SizedBox(height: 15),
                                Center(
                                  child: Text(
                                    _searchQuery.isNotEmpty
                                        ? 'No matching notes found'
                                        : 'No notes yet',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Center(
                                  child: Text(
                                    _searchQuery.isNotEmpty
                                        ? 'Try searching for something else.'
                                        : 'Tap + to create your first note.',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : ListView(
                              children: [
                                if (pinnedNotes.isNotEmpty) ...[
                                  const Text(
                                    'PINNED',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  ...pinnedNotes.map(
                                    (note) => SizedBox(
                                      height: 190,
                                      child: NoteCard(
                                        note: note,
                                        onTap: () =>
                                            _openEditNote(note),
                                        onPin: () {
                                          context
                                              .read<NoteProvider>()
                                              .togglePin(note.id);
                                        },
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),
                                ],

                                if (otherNotes.isNotEmpty) ...[
                                  const Text(
                                    'ALL NOTES',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  ...otherNotes.map(
                                    (note) => SizedBox(
                                      height: 190,
                                      child: NoteCard(
                                        note: note,
                                        onTap: () =>
                                            _openEditNote(note),
                                        onPin: () {
                                          context
                                              .read<NoteProvider>()
                                              .togglePin(note.id);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                    ),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddNote,
        backgroundColor: const Color(0xFF333333),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
    );
  }
}