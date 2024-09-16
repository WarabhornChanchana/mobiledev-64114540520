import 'package:flutter/material.dart';
import 'package:uquiz/members.dart';

// import 'home.dart';
// import 'shopping.dart';
import 'login.dart';

class UQuizApp extends StatefulWidget {
  const UQuizApp({super.key});

  @override
  State<UQuizApp> createState() => _UQuizAppState();
}

class _UQuizAppState extends State<UQuizApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'UQuiz App',
      // home: Home(),
      // home: MemberListPage(), //Shopping(),
      home: LoginPage(),
    );
  }
}
