import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


void main(){
  runApp(MaterialApp(
    home: UserListScreen(),
  ));
}
class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List users = [];
  bool isLoaded = true;

  Future<void> fetchUsers() async{
    try{
    final url=Uri.parse('https://jsonplaceholder.typicode.com/users');
    final response = await http.get(url);

    if (response.statusCode == 200){
      setState(() {
        users = json.decode(response.body);
        isLoaded = false;
      });
    }
    else{
      print('Server Error ${response.statusCode}');
    }
    }
    catch(e){
      print("Error $e");
    }
  }


  @override
  void initState(){
    super.initState();
    fetchUsers();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Lists"),
      ),
      body: isLoaded ? Center(
        child: CircularProgressIndicator()) : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index){
          var user = users[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(user['name'][0]),

              ),
              title: Text(user['name']),
              subtitle: Text('${user['email']}\nCity: ${user['address']['city']}'),
              isThreeLine: true,
            ),

          );
        },
      ) ,
      );

  }
}

