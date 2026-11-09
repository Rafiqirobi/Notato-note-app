import 'package:flutter/material.dart';
import 'package:isar_community/isar.dart';

import '../models/note.dart';
import '../repositories/note_repository.dart';

class NoteProvider extends ChangeNotifier {
  final NoteRepository _repository;

  NoteProvider(Isar isar)
      : _repository = NoteRepository(isar);

  List<Note> _notes = [];

  bool _isLoading = false;

  List<Note> get notes => _notes;

  bool get isLoading => _isLoading;

  // READ
  Future<void> loadNotes() async {
    _isLoading = true;
    notifyListeners();

    try {
      _notes = await _repository.getAllNotes();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // CREATE
  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    await _repository.addNote(
      title: title,
      content: content,
    );

    await loadNotes();
  }

  // UPDATE
  Future<void> updateNote({
    required int id,
    required String title,
    required String content,
  }) async {
    await _repository.updateNote(
      id: id,
      title: title,
      content: content,
    );

    await loadNotes();
  }

  // DELETE
  Future<void> deleteNote(int id) async {
    await _repository.deleteNote(id);

    await loadNotes();
  }

  // PIN / UNPIN
  Future<void> togglePin(int id) async {
    await _repository.togglePin(id);

    await loadNotes();
  }
}