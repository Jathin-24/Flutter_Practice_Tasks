import 'package:flutter/material.dart';

class fourthscreen extends StatelessWidget {
  const fourthscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('fouth screen'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ElevatedButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('go to third screen')),
      ),
    );
  }
}
