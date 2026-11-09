import 'package:isar_community/isar.dart';

import '../models/note.dart';

class NoteRepository {
  final Isar isar;

  NoteRepository(this.isar);

  // CREATE
  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    final note = Note()
      ..title = title
      ..content = content
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..isPinned = false;

    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });
  }

  // READ
  Future<List<Note>> getAllNotes() async {
    final notes = await isar.notes.where().findAll();

    // Pinned notes first, then newest notes.
    notes.sort((a, b) {
      if (a.isPinned != b.isPinned) {
        return a.isPinned ? -1 : 1;
      }

      return b.updatedAt.compareTo(a.updatedAt);
    });

    return notes;
  }

  // UPDATE
  Future<void> updateNote({
    required int id,
    required String title,
    required String content,
  }) async {
    final note = await isar.notes.get(id);

    if (note == null) return;

    note
      ..title = title
      ..content = content
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });
  }

  // DELETE
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() async {
      await isar.notes.delete(id);
    });
  }

  // PIN / UNPIN
  Future<void> togglePin(int id) async {
    final note = await isar.notes.get(id);

    if (note == null) return;

    note.isPinned = !note.isPinned;

    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });
  }
}
