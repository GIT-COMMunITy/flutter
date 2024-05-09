import 'package:flutter/material.dart';
import 'my_app.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async{
  await dotenv.load(fileName: 'assets/config/.env');
  runApp(MyApp());
}



