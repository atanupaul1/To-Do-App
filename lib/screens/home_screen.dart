import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import '../widgets/task_tile.dart';
import '../widgets/note_tile.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/add_note_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Uuid _uuid = const Uuid();
  int _currentMode = 0; // 0 = Tasks, 1 = Notes
  List<GravityTask> _tasks = [];
  List<NebulaNoteCard> _notes = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tasks = await StorageService.loadTasks();
    final notes = await StorageService.loadNotes();
    setState(() {
      _tasks = tasks;
      _notes = notes;
    });
  }

  Future<void> _addTask(String title) async {
    final task = GravityTask(
      id: _uuid.v4(),
      title: title,
      createdAt: DateTime.now(),
    );
    setState(() {
      _tasks.insert(0, task);
    });
    await StorageService.saveTasks(_tasks);
  }

  Future<void> _toggleTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      setState(() {
        _tasks[index].isDone = !_tasks[index].isDone;
      });
      await StorageService.saveTasks(_tasks);
    }
  }

  Future<void> _removeTask(String id) async {
    setState(() {
      _tasks.removeWhere((t) => t.id == id);
    });
    await StorageService.saveTasks(_tasks);
  }

  Future<void> _addNote(String title, String body) async {
    final note = NebulaNoteCard(
      id: _uuid.v4(),
      title: title,
      body: body,
      createdAt: DateTime.now(),
    );
    setState(() {
      _notes.insert(0, note);
    });
    await StorageService.saveNotes(_notes);
  }

  Future<void> _removeNote(String id) async {
    setState(() {
      _notes.removeWhere((n) => n.id == id);
    });
    await StorageService.saveNotes(_notes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Deep Space Background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1.5,
                colors: [
                  Color(0xFF1A1F3A),
                  Color(0xFF0A0E21),
                  Color(0xFF000000),
                ],
              ),
            ),
          ),

          // Floating stars
          ...List.generate(50, (index) {
            final random = Random(index);
            return Positioned(
              left: random.nextDouble() * MediaQuery.of(context).size.width,
              top: random.nextDouble() * MediaQuery.of(context).size.height,
              child:
                  Container(
                        width: random.nextDouble() * 3 + 1,
                        height: random.nextDouble() * 3 + 1,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(
                            random.nextDouble() * 0.5 + 0.3,
                          ),
                          shape: BoxShape.circle,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .fadeIn(
                        duration: Duration(
                          milliseconds: random.nextInt(2000) + 1000,
                        ),
                      )
                      .fadeOut(
                        duration: Duration(
                          milliseconds: random.nextInt(2000) + 1000,
                        ),
                      ),
            );
          }),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: _currentMode == 0
                      ? _buildGravityTasks()
                      : _buildNebulaNotes(),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),

          // Bottom Navigation
          Positioned(left: 24, right: 24, bottom: 24, child: _buildBottomNav()),

          // Add Button
          Positioned(
            right: 24,
            bottom: 100,
            child: FloatingActionButton(
              onPressed: () {
                if (_currentMode == 0) {
                  _showAddTaskDialog();
                } else {
                  _showAddNoteDialog();
                }
              },
              backgroundColor: const Color(0xFF764BA2),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF667EEA).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.rocket_launch,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TO-DO',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              Text(
                '❤️ made by atanu',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  color: Colors.white60,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGravityTasks() {
    if (_tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rocket_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks in orbit',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to add a new task',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                color: Colors.white38,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return TaskTile(
              key: ValueKey(task.id),
              task: task,
              onToggle: () => _toggleTask(task.id),
              onDelete: () => _removeTask(task.id),
            )
            .animate()
            .fadeIn(duration: 300.ms, delay: (index * 50).ms)
            .slideY(
              begin: -0.3,
              end: 0,
              curve: Curves.elasticOut,
              duration: 800.ms,
            );
      },
    );
  }

  Widget _buildNebulaNotes() {
    if (_notes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome_outlined,
              size: 80,
              color: Colors.white.withOpacity(0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No notes floating',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                color: Colors.white60,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap + to create a new note',
              style: GoogleFonts.spaceGrotesk(
                fontSize: 14,
                color: Colors.white38,
              ),
            ),
          ],
        ),
      );
    }

    return MasonryGridView.count(
      padding: const EdgeInsets.all(24),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        return NoteTile(
              key: ValueKey(note.id),
              note: note,
              onDelete: () => _removeNote(note.id),
            )
            .animate()
            .fadeIn(duration: 400.ms, delay: (index * 80).ms)
            .scale(
              begin: const Offset(0.8, 0.8),
              curve: Curves.elasticOut,
              duration: 600.ms,
            );
      },
    );
  }

  Widget _buildBottomNav() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: _buildNavItem(
                icon: Icons.check_circle_outline,
                label: 'Gravity Tasks',
                isActive: _currentMode == 0,
                onTap: () => setState(() => _currentMode = 0),
              ),
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.white.withOpacity(0.2),
            ),
            Expanded(
              child: _buildNavItem(
                icon: Icons.auto_awesome,
                label: 'Nebula Notes',
                isActive: _currentMode == 1,
                onTap: () => setState(() => _currentMode = 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive ? const Color(0xFF667EEA) : Colors.white60,
                size: 22,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  color: isActive ? const Color(0xFF667EEA) : Colors.white60,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    showDialog(
      context: context,
      builder: (context) => AddTaskDialog(onAdd: (title) => _addTask(title)),
    );
  }

  void _showAddNoteDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AddNoteDialog(onAdd: (title, body) => _addNote(title, body)),
    );
  }
}
