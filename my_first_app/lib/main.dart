import 'package:flutter/material.dart';



// TASK 3
void main(){
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        title: Text("Insta Post",
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                  child: Image.asset("assets/images/Luffy.jpeg",
                      height: 30,
                      width: 30,
                      fit: BoxFit.cover,
                  ),
                  ),
                  SizedBox(width: 8),
                  Text("Jathin_24"),
                  SizedBox(width: 8),
                  // Image.asset("assets/images/your_name.jpg",
                  // height: 30,
                  // ),
                  TextButton(
                      onPressed: () {  },
                      child: Text("Follow"),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/Luffy.jpeg",
                  width: 200,
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.pinkAccent,
                    size: 24,
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.mode_comment_outlined,
                    color: Colors.black,
                    size: 24,
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.send,
                    color: Colors.black,
                    size: 24,
                  ),
                  SizedBox(width: 16),
                  Icon(
                    Icons.save,
                    color: Colors.black,
                    size: 24,
                  )
                ],
              )
            ],
        ),
      ),
    ),
  ));
}



// TASK 2
// void main(){
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("About Me",
//         style: TextStyle(
//           color: Colors.white,
//         ),
//         ),
//         backgroundColor: Colors.black,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             ClipOval(
//                 child: Image.asset("assets/images/Luffy.jpeg",
//                 height: 200,
//                 width: 200,
//                 fit: BoxFit.cover,
//                 ),
//             ),
//             Text("Monkey.D.Luffy",
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold
//             ),),
//             Image.network("https://upload.wikimedia.org/wikipedia/commons/c/cf/Eric_Holder_signature.jpg")
//           ],
//         ),
//       ),
//     ),
//   ));
// }


// TASK 1
// void main(){
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: Text("Task 1 & 2",
//         style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Colors.black,
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ClipOval(
//               child: Image.asset("assets/images/Luffy.jpeg",
//               height: 200,
//               width: 200,
//               fit: BoxFit.cover,)
//               ),
//               Text("I am Monkey.D.Luffy and I am going to become the KING OF THE PIRATES",
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Colors.redAccent
//               ),)
//             ],
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ClipOval(
//                   child: Image.asset("assets/images/your_name.jpg",
//                     height: 200,
//                     width: 200,
//                     fit: BoxFit.cover,)
//               ),
//               Text("Bound by fate, destined across time—we are Mitsuha Miyamizu and Taki Tachibana.",
//               style: TextStyle(
//                 fontSize: 20,
//                 color: Colors.pinkAccent
//               ),)
//             ],
//           ),
//         ],
//       ),
//       backgroundColor: Colors.black12,
//     ),
//   ));
// }




// void main(){
//   runApp(MaterialApp(
//     home: Scaffold(
//       appBar: AppBar(
//         title: Text("Free Fire",
//         style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.black,
//       ),
//       body: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Center(
//             child: Text("Letss play FF",
//             style: TextStyle(color: Colors.redAccent,
//             fontSize: 50),
//             ),
//           ),
//           Image.asset('assets/images/your_name.jpg',
//             width: 700,),
//           Image.network("assets/images/Luffy.jpeg"),
//
//         ],
//       ),
//       backgroundColor: Colors.black12,
//     ),
//   ));
// }


// void main()
// {
//   runApp(Text("HOIIIIIIIIIIIIIIIIIIIIIIIII",
//     textDirection: TextDirection.rtl,
//     textAlign: TextAlign.center,
//     style: TextStyle(
//       color: Colors.pinkAccent,
//       fontSize: 50,
//       fontWeight: FontWeight.bold,
//       fontStyle: FontStyle.italic,
//     ),
//   ));
// }