import 'package:flutter/material.dart';
import 'Login.dart'; // อย่าลืมสร้างไฟล์นี้ไว้

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // เริ่มต้นที่หน้า Login
    );
  }
}
