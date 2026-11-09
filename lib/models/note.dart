import 'package:isar_community/isar.dart';

part 'note.g.dart';

@collection
class Note {
  Id id = Isar.autoIncrement;
  late String title;
  late String content;
  DateTime createdAt = DateTime.now();
  DateTime updatedAt = DateTime.now();
  bool isPinned = false;
}