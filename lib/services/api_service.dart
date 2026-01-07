import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/todo_model.dart';

class ApiService {
  // fake API
  static const String url = "https://jsonplaceholder.typicode.com/todos";

  static Future<List<Todo>> fetchTodos() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // 1. Decode the response body (it's a String) into a List
      List<dynamic> body = json.decode(response.body);

      // take 20 item
      return body.take(50).map((item) => Todo.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load tasks from internet");
    }
  }
}