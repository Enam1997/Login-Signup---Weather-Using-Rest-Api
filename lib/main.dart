import 'package:accelx/login.dart';
import 'package:accelx/screens/Loading.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var auth_token = prefs.getString('auth_token');
  Map<String, dynamic> sendSelectLocation = {"latitude" : "23.623776","longitude": "90.500040"};
  print(auth_token);
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: auth_token == null ? Login() : Loading(sendSelectLocation)));
}