import 'package:flutter/material.dart';

void main(){
  runApp(MaterialApp(
    home: FadeExample(),
  ));
}

class FadeExample extends StatefulWidget {
  const FadeExample({super.key});

  @override
  State<FadeExample> createState() => _FadeExampleState();
}

class _FadeExampleState extends State<FadeExample> {
  double opacity = 1.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fade Example'),
      ),
      body: Center(
        child: AnimatedOpacity(
          opacity: opacity, duration: Duration(seconds: 1),
          child: Column(
            children: [
              Image.asset('assets/images/img.png', height: 100,width: 100,),
              Text('This is an Animation of me The KING OF THE PIRATES')
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => setState(() {
        opacity = opacity == 1 ? 0 : 1 ;
      }),
        child: Icon(Icons.opacity),
      ),
    );
  }
}
