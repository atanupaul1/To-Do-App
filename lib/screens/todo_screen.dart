import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';

class TodoScreen extends StatelessWidget {
  // Inject the controller
  final TodoController controller = Get.put(TodoController());
  final TextEditingController textController = TextEditingController();

  TodoScreen({super.key});

  // Reusable Dialog for Adding and Editing
  void showTaskDialog({int? index}) {
    if (index != null) {
      textController.text = controller.tasks[index].title;
    } else {
      textController.clear();
    }

    Get.defaultDialog(
      title: index == null ? "New Task" : "Edit Task",
      content: TextField(
        controller: textController,
        decoration: const InputDecoration(hintText: "What needs to be done?"),
      ),
      textConfirm: "Save",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (textController.text.isNotEmpty) {
          if (index == null) {
            controller.addTask(textController.text);
          } else {
            controller.updateTask(index, textController.text);
          }
          textController.clear();
          Get.back();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => controller.fetchInitialData(),
          )
        ],
      ),
      body: Obx(() {
        // Show spinner while loading from API
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show message if list is empty
        if (controller.tasks.isEmpty) {
          return const Center(child: Text("No tasks found."),);
        }

        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final task = controller.tasks[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: ListTile(
                leading: Checkbox(
                  value: task.isDone,
                  onChanged: (val) => controller.toggleStatus(index),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                    color: task.isDone ? Colors.grey : Colors.black,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => showTaskDialog(index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.deleteTask(index),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showTaskDialog(),
        child: const Icon(Icons.add_circle_rounded),
      ),
    );
  }
}