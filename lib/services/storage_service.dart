import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';
import '../models/note.dart';

class StorageService {
  static const String _tasksKey = 'gravity_tasks';
  static const String _notesKey = 'nebula_notes';

  // Tasks
  static Future<void> saveTasks(List<GravityTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = tasks.map((t) => jsonEncode(t.toJson())).toList();
    await prefs.setStringList(_tasksKey, jsonList);
  }

  static Future<List<GravityTask>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_tasksKey) ?? [];
    return jsonList
        .map((json) => GravityTask.fromJson(jsonDecode(json)))
        .toList();
  }

  // Notes
  static Future<void> saveNotes(List<NebulaNoteCard> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = notes.map((n) => jsonEncode(n.toJson())).toList();
    await prefs.setStringList(_notesKey, jsonList);
  }

  static Future<List<NebulaNoteCard>> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_notesKey) ?? [];
    return jsonList
        .map((json) => NebulaNoteCard.fromJson(jsonDecode(json)))
        .toList();
  }
}
