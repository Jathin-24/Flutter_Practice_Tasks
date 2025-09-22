import 'package:flutter/material.dart';
import 'package:navigation/thirdscreen.dart';


class secondscreen extends StatelessWidget {
  const secondscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('second screen'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
             ElevatedButton(onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder: (context) => thirdscreen()));
            }, child: Text('Go to Third Screen')),
          ElevatedButton(onPressed: (){
              Navigator.pop(context);
            }, child: Text('go to first screen')),

        ],
      ),
    );
  }
}
