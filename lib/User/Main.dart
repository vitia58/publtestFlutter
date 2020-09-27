import 'package:flutter/material.dart';
import 'package:publtest/User/Articles.dart';
import 'package:publtest/User/Article.dart';

class User extends StatefulWidget {
  static int page = -1;

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  @override
  Widget build(BuildContext context) {
    return User.page == -1
        ? Scaffold(
            appBar: AppBar(
              title: Text(
                "News List",
                style: TextStyle(fontSize: 30),
              ),
              centerTitle: true,
              backgroundColor: Colors.blueAccent,
            ),
            //bottomNavigationBar: Navigation(),
            body: refresh())
        : Article(User.page, "Загрузка", "Загрузка");
  }
  @override
  void setState(fn) {

  }
}

/*class Navigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(items: [
      BottomNavigationBarItem(
          title: FlatButton(
            onPressed: () {},
            child: null,
          ),
          icon: Icon(Icons.format_align_justify))
    ]);
  }
}*/
