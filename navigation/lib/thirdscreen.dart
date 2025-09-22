import 'package:flutter/material.dart';
import 'package:navigation/fourthscreen.dart';

class thirdscreen extends StatelessWidget {
  const thirdscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('third screen'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Row(
          children: [
            ElevatedButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => fourthscreen()));
            }, child: Text('go to 4th screen')),
            ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('go to second screen'))
          ],
        ),
      ),
    );
  }
}
