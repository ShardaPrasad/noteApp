import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../auth/service/auth_service.dart';
import '../connectivity/connectivity.dart';
import '../model/note.dart';
import '../routes/app_routes.dart';
import 'notecard_page.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();

  List<NoteItem> _notes = [];
  List<NoteItem> _filteredNotes = [];

  @override
  void initState() {
    super.initState();

    final connectivity = Get.find<ConnectivityController>();
    if (!connectivity.isConnected.value) {
      Get.snackbar('Offline', 'Check internet connection');
    } else {
      _fetchNotes();
    }
  }

  /// ------------------
  /// Firebase Fetch (Firestore)
  /// ------------------
  Future<void> _fetchNotes() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .get();

    final loadedNotes = snapshot.docs.map((doc) {
      final data = doc.data();

      final Timestamp? timestamp = data['createdAt'];
      final DateTime dateTime =
      timestamp != null ? timestamp.toDate() : DateTime.now();

      return NoteItem(
        id: doc.id,
        title: data['title'] ?? '',
        description: data['content'] ?? '',
        date: _formatDate(dateTime),
        color: _getColorFromIndex(doc.id.hashCode),
      );
    }).toList();

    setState(() {
      _notes
        ..clear()
        ..addAll(loadedNotes);
      _filteredNotes = _notes;
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getColorFromIndex(int index) {
    final colors = [
      Colors.lightBlueAccent,
      Colors.greenAccent,
      Colors.pinkAccent,
      Colors.orangeAccent,
      Colors.tealAccent,
      Colors.lightGreen,
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Notes',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: () {
              Get.dialog(
                AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {

                        await AuthService().logout();
                        await FirebaseAuth.instance.signOut();
                        Get.offAllNamed(AppRoutes.login);
                      },
                      child: const Text('Logout'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // 🔍 Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search notes...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged('');
                  },
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // 📄 Notes List
          Expanded(
            child: _filteredNotes.isEmpty
                ? const Center(
              child: Text(
                'No notes available',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                itemCount: (_filteredNotes.length / 2).ceil(),
                itemBuilder: (context, index) {
                  final leftData = _filteredNotes[index * 2];
                  final right = (index * 2 + 1 < _filteredNotes.length)
                      ? _filteredNotes[index * 2 + 1]
                      : null;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: NoteCard(
                            note: leftData,
                            onDelete: () =>
                                _confirmDelete(context, leftData),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: right != null
                              ? NoteCard(
                            note: right,
                            onDelete: () =>
                                _confirmDelete(context, right),
                          )
                              : const SizedBox(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // TODO: Navigate to Add Note
          final result = await Get.toNamed(AppRoutes.addEditNotePage);
          if (result == true) {
            final connectivity = Get.find<ConnectivityController>();
            if (!connectivity.isConnected.value) {
              Get.snackbar('Offline', 'Check internet connection');
            } else {
              _fetchNotes();
            }
          }
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (query.isEmpty) {
      _filteredNotes = _notes;
    } else {
      _filteredNotes = _notes.where((note) {
        final title = note.title.toLowerCase();
        return title.contains(query.toLowerCase());
      }).toList();
    }
    setState(() {});
  }

void _confirmDelete(BuildContext context, NoteItem item) {
  Get.defaultDialog(
    title: 'Delete Note',
    middleText: 'Are you sure you want to delete this note?',
    textCancel: 'Cancel',
    textConfirm: 'Delete',
    confirmTextColor: Colors.white,
    onConfirm: () {
      Get.back();
      _deleteNote(item); // 🔥 notify parent
    },
  );
}

  Future<void> _deleteNote(NoteItem note) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notes')
        .doc(note.id)
        .delete();

    final connectivity = Get.find<ConnectivityController>();
    if (!connectivity.isConnected.value) {
      Get.snackbar('Offline', 'Check internet connection');
    } else {
      _fetchNotes();
    } // refresh list
  }

}
