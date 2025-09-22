import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Forms',
      home: SimpleFormPage(),
    );
  }
}

class SimpleFormPage extends StatefulWidget {
  const SimpleFormPage({super.key});

  @override
  State<SimpleFormPage> createState() => _SimpleFormPageState();
}

class _SimpleFormPageState extends State<SimpleFormPage> {
  final _formKey = GlobalKey<FormState>();
  String? name, email, gender, address;
  bool subscribe = false;

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form Submitted Successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        title: const Text('Validate Form'),
        backgroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Name:",
                    hintText: 'Enter Your Name',
                    border: OutlineInputBorder()),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  } else if (value.trim().length < 3) {
                    return 'Name must be at least 3 characters';
                  }
                  return null;
                },
                onSaved: (value) => name = value,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Email:',
                    hintText: 'Enter Your Mail',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  final emailRegex =
                  RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
                  if (!emailRegex.hasMatch(value)) {
                    return "Use a valid Gmail address (e.g. name@gmail.com)";
                  }
                  return null;
                },
                onSaved: (value) => email = value,
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender:',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(value: 'male', child: Text("Male")),
                  DropdownMenuItem(value: 'female', child: Text('Female')),
                  DropdownMenuItem(value: 'others', child: Text('Others')),
                ],
                validator: (value) =>
                value == null ? 'Please select a gender' : null,
                onChanged: (value) => gender = value,
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Address:',
                    hintText: 'Enter your Address',
                    border: OutlineInputBorder()),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Address is required';
                  } else if (value.trim().length < 10) {
                    return "Address must be at least 10 characters";
                  }
                  return null;
                },
                onSaved: (value) => address = value,
              ),
              SizedBox(height: 20.0),
              CheckboxListTile(
                  title: Text("Subscribe to newsletter"),
                  value: subscribe,
                  onChanged: (value) =>
                      setState(() => subscribe = value!)),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}