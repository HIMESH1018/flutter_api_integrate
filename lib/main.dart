import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:login_retrofit/Login.dart';
import 'dart:convert';

import 'package:login_retrofit/constant.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Retrofit Test',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: HomePage()
    );
  }
}

String stringResponse = "";
late Map mapResponse;
late Map dataResponse;
late List _list;

class HomePage extends StatefulWidget{

  @override
  _HomepageState createState() => _HomepageState();

}


  class _HomepageState extends State<HomePage>{


    Future apcicall() async{
      http.Response response;
      response = await http.get(Uri.parse("https://reqres.in/api/users?page=2"));
      if(response.statusCode == 200){
        setState(() {
         // stringResponse = response.body;
           mapResponse = json.decode(response.body); //get whole response
         //  dataResponse = mapResponse['data']; // get specific part of response

           _list = mapResponse['data']; // adding to list specifi part

        });
      }
    }
    @override
  void initState() {
    apcicall() ;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("API TEST"),
      ),
      // body: Center(
      //   child: Container(
      //     height: 200,
      //     width: 300,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(20),color: Colors.blue),
      //     child: Center(
      //     // child: list == null ?Container() :Text("Api Response"+" "+list[1].toString() // get to whole postion data
      //         child: list == null ?Container() :Text("Api Response"+" "+list[1]['first_name'].toString() // get to whole postion specifi data
      //       ),
      //     ),
      //   ),

      body: ListView.builder(itemBuilder: (context,index)
    {
      return Container(
        
        child: Column(
          children: [
            Text(_list[index]['id'].toString()),
            Text(_list[index]['email'].toString()),
            Text(_list[index]['first_name'].toString()),
            Text(_list[index]['last_name'].toString()),
            Image.network(_list[index]['avatar']),
            Padding(padding: EdgeInsets.all(20.0),
              child:TextButton(
                style: TextButton.styleFrom(backgroundColor: Colors.blue,padding: const EdgeInsets.symmetric(horizontal: 100,vertical: 10),),
                child: Text("Login",style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,

                ),
                ),
                onPressed: () {  Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()
                )
                );
                },
              ),
            ),
          ],
        ),
      );
    
      },
        itemCount: _list == null ?0: _list.length,
      ),
    );
  }
}



