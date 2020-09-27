import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(title: "PublTest", home: NewWidget()));
}

class NewWidget extends StatefulWidget {
  const NewWidget({
    Key key,
  }) : super(key: key);

  @override
  _NewWidgetState createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  int id = 0;

  @override
  Widget build(BuildContext context) {
    return id == 0
        ? Card(
            child: FlatButton(
              onPressed: () {
                setState(() {
                  id = 1;
                });
              },
              child: Text("click"),
            ),
          )
        : Text("nope");
  }
}
