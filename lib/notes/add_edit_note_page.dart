import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../connectivity/connectivity.dart';
import '../model/note.dart';

class AddEditNotePage extends StatefulWidget {
  final String? noteId; // required for edit
  final String? initialTitle;
  final String? initialContent;

  const AddEditNotePage({
    super.key,
    this.noteId,
    this.initialTitle,
    this.initialContent,
  });

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  late final bool isEdit;
  NoteItem? note;


  @override
  void initState() {
    super.initState();

    note = Get.arguments as NoteItem?;

    isEdit = note != null;

    _titleController =
        TextEditingController(text: widget.initialTitle ?? '');
    _contentController =
        TextEditingController(text: widget.initialContent ?? '');

    if (isEdit) {
      _titleController.text = note!.title;
      _contentController.text = note!.description;
    }

  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }

    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    final connectivity = Get.find<ConnectivityController>();
    if (!connectivity.isConnected.value) {
      Get.snackbar('Offline', 'Check internet connection');
      return;
    }
    // Optional: avoid update if nothing changed
    if (isEdit &&
        title == widget.initialTitle &&
        content == widget.initialContent) {
      Get.back();
      return;
    }

    setState(() => _isLoading = true);

    try {
      final notesRef = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notes');

      if (isEdit) {
        await notesRef.doc(note!.id).update({
          'userId': user.uid,
          'title': title,
          'content': content,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {

        await notesRef.add({
          'userId': user.uid,
          'title': title,
          'content': content,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      Get.back(result: true);
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving note: $e')),
      );
    } finally {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Note' : 'Add Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _contentController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveNote,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.blueAccent)
                    : Text(isEdit ? 'Update' : 'Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
