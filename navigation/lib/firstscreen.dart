import 'package:flutter/material.dart';
import 'package:navigation/secondScreen.dart';

class firstscreen extends StatelessWidget {
  const firstscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => secondscreen()));
        }, child: Text('go to 2nd screen'))
      ),
    );
  }
}
