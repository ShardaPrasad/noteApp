
import 'package:flutter/material.dart';
import '../model/note.dart';

/// ------------------
/// Note Card Widget
/// ------------------
class NoteCard extends StatelessWidget {
  final NoteItem note;
  final VoidCallback onDelete;

  const NoteCard({super.key,
    required this.note,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: note.color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  note.title.capitalizeFirst(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // _confirmDelete(context);
                  onDelete();
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: const SizedBox(
                  width: 32,
                  height: 32,
                  child: Icon(
                    Icons.delete_outline, // bin icon
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            note.description.capitalizeFirst(),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              note.date,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}
