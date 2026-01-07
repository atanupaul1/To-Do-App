import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'screens/todo_screen.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // We use GetMaterialApp instead of MaterialApp to enable GetX features
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Pro Roadmap',

      // Theme data allows you to control the look of your app globally
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true, // Material design
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
      ),

      // App start form here
      home: TodoScreen(),
    );
  }
}