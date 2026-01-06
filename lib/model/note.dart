
import 'dart:ui';

/// ------------------
/// Note Model
/// ------------------
class NoteItem {
  final String id;
  final String title;
  final String description;
  final String date;
  final Color color;

  NoteItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.color,
  });
}