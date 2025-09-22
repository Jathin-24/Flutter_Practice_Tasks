import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main(){
  runApp(MaterialApp(
    home: FetchExample(),
  ));
}
class FetchExample extends StatelessWidget {
  Future<void> getData() async{
    final url=Uri.parse('https://jsonplaceholder.typicode.com/users');
    final response = await http.get(url);

    if (response.statusCode == 200){
      var data = json.decode(response.body);
      print(data);
    }
    else{
      print('Failed to load data');
    }
}

  @override
  Widget build(BuildContext context) {
    getData(); // fetch data from api
    return Scaffold(
      appBar: AppBar(
        title: Text("Fetch API Example"),
      ),
      body: Center(
        child: Text("Hey User Please check you Console!... for API Data"),
      ),
    );
  }
}
