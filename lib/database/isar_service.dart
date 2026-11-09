import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/note.dart';

class IsarService {
  late final Isar db;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();

    db = await Isar.open(
      [NoteSchema],
      directory: directory.path,
    );
  }
}
