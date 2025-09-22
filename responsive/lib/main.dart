import 'package:flutter/material.dart';

// MEDIAQUERY & BREAKPOINTS
void main(){
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    home: Scaffold(
      appBar: AppBar(
        title: Text('MedaiQuery & BreakPoints'),
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
      ),
      body: Builder(builder: (context){
        double width = MediaQuery.of(context).size.width;

        if (width < 600){
          return Column(
            children: buildBoxes(width),
          );
        }
        else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: buildBoxes(width/3),
          );
        }
      }
      ),
    ),
  ));
}

List<Widget> buildBoxes(double boxWidth){
  return[
        Image.asset('assets/images/img.png',
          width: boxWidth,
          height: 200,
        ),
        Image.asset('assets/images/img.png',
          width: boxWidth,
          height: 200,
        ),
        Image.asset('assets/images/img.png',
          width: boxWidth,
          height: 200,
        )
    // Container(
    //   width: boxWidth,
    //   height: 200,
    //   color: Colors.deepOrangeAccent,
    // ),
    // Container(
    //   width: boxWidth,
    //   height: 200,
    //   color: Colors.white,
    // ),
    // Container(
    //   width: boxWidth,
    //   height: 200,
    //   color: Colors.greenAccent,
    // )
  ];
}

// LAYOUT BUILDING FOR DIFFERENT SIZES OF SCREENS
// void main(){
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text("Responsive Design using Flutter"),
//       ),
//       body: LayoutBuilder(builder: (context, constraints){
//         double width = constraints.maxWidth;
//
//         if(width < 600){
//           return Center(
//             child: Column(
//               children: [
//                 Text('Mobile View'),
//                 Image.asset('assets/images/img.png'),
//               ],
//             ),
//           );
//         }
//         else if(width < 900){
//           return Center(
//             child: Column(
//               children: [
//                 Text('Tablet View'),
//                 Image.asset('assets/images/img.png'),
//               ],
//             ),
//           );
//         }
//         else{
//           return Center(
//             child: Column(
//               children: [
//                 Text('Desktop View'),
//                 Image.asset('assets/images/img.png'),
//               ],
//             ),
//           );
//         }
//       }),
//     ),
//   ));
// }