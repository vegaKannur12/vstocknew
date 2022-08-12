import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vstock/screen/1_splashscreen.dart';
import 'package:vstock/screen/2_registration.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[200],
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Color(0xFF424242),
          secondary: Color(0xFF424242),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: RegistrationScreen(),
    );
  }
}
