import 'package:flutter/material.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => firstscreen(),
        '/second': (context) => secondscreen(),
        '/third': (context) => thirdscreen(),
        '/fourth': (context) => fourthscreen()
      },
      title: 'My First App',
    );
  }
}




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
              Navigator.pushNamed(context, '/fourthscreen');
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

