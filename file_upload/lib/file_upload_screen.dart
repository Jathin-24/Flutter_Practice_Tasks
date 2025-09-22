import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

class FileUploadScreen extends StatefulWidget {
  const FileUploadScreen({super.key});

  @override
  State<FileUploadScreen> createState() => _FileUploadScreenState();
}

class _FileUploadScreenState extends State<FileUploadScreen> {
  File? _selectedFile;
  String? _fileName;

  void _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        _fileName = result.files.single.name;
        _selectedFile = File(result.files.single.path!);
      });
    }
  }

  void _uploadFile() {
    if (_selectedFile != null) {
      print('Uploading file: $_fileName');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Upload simulated in console')),
      );
    }
  }

  Widget _buildFilePreview() {
    if (_selectedFile == null) return const Text('No file selected.');

    if (_fileName!.endsWith('.jpg') || _fileName!.endsWith('.png')) {
      return Image.file(_selectedFile!, height: 150);
    } else {
      return Column(
        children: [
          const Icon(Icons.picture_as_pdf, size: 80),
          Text(_fileName!),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload File'),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text('Hello World 👋', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickFile,
              child: Card(
                color: colorScheme.secondaryContainer,
                child: const Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.upload_file, size: 30),
                      SizedBox(width: 10),
                      Text("Select File", style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildFilePreview(),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _uploadFile,
              icon: const Icon(Icons.cloud_upload),
              label: const Text("Upload"),
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: colorScheme.secondaryContainer,
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Text(
            'By Jathin',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
