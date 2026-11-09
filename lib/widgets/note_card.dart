import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onPin;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onPin,
  });

  String formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return '${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: const Color.fromARGB(255, 255, 250, 151),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF333333),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onPin,
                    icon: Icon(
                      note.isPinned
                          ? Icons.push_pin
                          : Icons.push_pin_outlined,
                      color: note.isPinned
                          ? Colors.orange
                          : Colors.grey,
                      size: 20,
                    ),
                    tooltip: note.isPinned
                        ? 'Unpin note'
                        : 'Pin note',
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Expanded(
                child: Text(
                  note.content.isEmpty
                      ? 'No additional content'
                      : note.content,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF666666),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                'Edited ${formatDate(note.updatedAt)}',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF888888),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}