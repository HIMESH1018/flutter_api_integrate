
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:login_retrofit/MaidModel.dart';
import 'package:login_retrofit/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';





late List _list;
late Map mapResponse;
late Map dataResponse;
class LoginScreen extends StatefulWidget {




  @override
  _LoginState createState() => _LoginState();
}

Future<MaidModel?> createUser() async{
  late List list;
  final String apiUrl = "https://maid-finder.stepheninnovations.com/api/maid-login";

  final response = await http.post(Uri.parse(apiUrl), body: {
    "telephone": "0713461519",
    "password": "abcd1234"
  });

  if(response.statusCode == 201){
    final String responseString = response.body;

    return mainModelFromJson(responseString);
  }else{
    return null;
  }
}

Future apcicall(String tel,String pass) async{
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json'
  };
  http.Response response;
  response = await http.post(Uri.parse("https://maid-finder.stepheninnovations.com/api/maid-login"),body: {
    "telephone": tel,
    "password": pass
  });
  if(response.statusCode == 201){

      // stringResponse = response.body;
       mapResponse = json.decode(response.body); //get whole response
        dataResponse = mapResponse['maid']; // get specific part of response

       // _list = mapResponse['maid']; // adding to list specifi part

  }
  else if(response.statusCode == 500){
    print("Please Check Details Again");
    Fluttertoast.showToast(msg: "Server Error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
  else{
    Fluttertoast.showToast(msg: "Please Check Details Again",
    toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}

class _LoginState extends State<LoginScreen> {

   MaidModel? _user;
  int user_id = -1;
  String user_name ='';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();


  Future<String> getUsername() async{

    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username');

    if(name == null){
      print("SharedPreference: "+name!);
      return "null";
    }
    print("SharedPreference: "+name);
    return name;
  }

  Future<void> _setUserDetails(String name) async{

    final prefs  = await SharedPreferences.getInstance();

    await prefs.setString('username', name);
  }


   @override
  void initState() {
  getUsername();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[

            TextField(
              controller: nameController,
            ),

            TextField(
              controller: jobController,
            ),

            SizedBox(height: 32,),

            _user == null ? Container() :
            Text("The user ${_user!.name}, ${_user!
                .id} is created successfully at time ${_user!.created_at
                .toIso8601String()}"),

          ],
        ),
      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final String tel = nameController.text;
            final String jobTitle = jobController.text;
            if(tel.isEmpty || jobTitle.isEmpty){
              Fluttertoast.showToast(msg: "Please Enter All fields",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            }
            else {
               await apcicall(tel, jobTitle);
               user_id = dataResponse['id'];

               if(user_id != -1){
                 Fluttertoast.showToast(msg: "Login Success",
                     toastLength: Toast.LENGTH_SHORT,
                     gravity: ToastGravity.CENTER,
                     timeInSecForIosWeb: 1,
                     backgroundColor: Colors.blue,
                     textColor: Colors.white,
                     fontSize: 16.0
                 );
                 _setUserDetails(dataResponse['name']);
               }
            }

            setState(() {
              print(dataResponse['id'].toString());
              print(dataResponse['name'].toString());
              print(dataResponse['image'].toString());
              print(dataResponse['gender'].toString());
            });

          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        )

    );
  }
}

