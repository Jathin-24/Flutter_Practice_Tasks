import 'dart:math';

import 'package:flutter/material.dart';
void main(){
  runApp(CoinFlip());
}

class CoinFlip extends StatefulWidget {
  @override
  State<CoinFlip> createState() => _CoinFlipState();
}

class _CoinFlipState extends State<CoinFlip> {
  int CoinHead = 0;

  Random coinside = Random();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('CoinFlip: ' + (CoinHead == 1 ? 'heads' : 'tails')),

        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          setState(() {CoinHead = coinside.nextInt(2);
          });
          print(CoinHead);

        },

          child: Icon(Icons.favorite_outline),        ),
      ),
    );
  }}