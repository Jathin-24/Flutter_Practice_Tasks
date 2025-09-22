import 'package:flutter/material.dart';
import './file_upload_screen.dart';

void main() {
  runApp(const MyApp());
}

// Material 3 themed app
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Upload Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.redAccent),
      ),
      home: const FileUploadScreen(),
    );
  }
}
