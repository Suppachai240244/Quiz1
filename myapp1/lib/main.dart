import 'package:flutter/material.dart';
import 'package:myapp1/user.dart';
import 'database/database_helper.dart';
import 'database/userlist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<User> users = [];
  late DatabaseHelper _dbHelper;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper.instance;
    initUsers();
  }

  void initUsers() async {
    var result = await _dbHelper.fetchUsers();
    setState(() {
      users = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz1',
      theme: ThemeData(primarySwatch: Colors.green),
      home: UserScreen(
        users: users,
        dbHelper: _dbHelper,
      ),
    );
  }
}
