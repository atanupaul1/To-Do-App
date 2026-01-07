import 'package:get/get.dart';
import '../models/todo_model.dart';
import '../services/api_service.dart';

class TodoController extends GetxController {
  var tasks = <Todo>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  // --- READ (API) ---
  void fetchInitialData() async {
    try {
      isLoading(true);
      var apiData = await ApiService.fetchTodos();
      tasks.assignAll(apiData);
    } catch (e) {
      Get.snackbar("Error", "Could not fetch data: $e",
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }

  //CREATE
  void addTask(String title) {
    tasks.insert(0, Todo(title: title)); // Add to top of list
  }

  //UPDATE
  void updateTask(int index, String newTitle) {
    tasks[index].title = newTitle;
    tasks.refresh(); // Required for GetX to see changes inside object properties
  }

  void toggleStatus(int index) {
    tasks[index].isDone = !tasks[index].isDone;
    tasks.refresh();
  }

  // DELETE
  void deleteTask(int index) {
    tasks.removeAt(index);
    Get.snackbar("Deleted", "Task removed",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 1));
  }
}