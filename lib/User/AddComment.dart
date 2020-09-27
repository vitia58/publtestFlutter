import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Connection.dart';

class Commentwindow extends StatelessWidget {
  int article;

  Commentwindow(this.article);

  @override
  Widget build(BuildContext context) {
    var width =  MediaQuery.of(context).size.width;
    var size = width < 1000 ? 20.0 : width < 2000 ? 25.0 : 30.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Добавление коментария",
          style: TextStyle(fontSize: size),
        ),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: NewComment(article),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send,color: Colors.white,),
        backgroundColor: Colors.blue[500],
        onPressed: () {
          if (Controllers._formKey.currentState.validate()) {
            addComment(article, Controllers.fio.text, Controllers.email.text,
                Controllers.comment.text);
            Controllers.fio.text = "";
            Controllers.email.text = "";
            Controllers.comment.text = "";
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }
}

class Controllers {
  static final comment = TextEditingController();
  static final fio = TextEditingController();
  static final email = TextEditingController();
  static final _formKey = GlobalKey<FormState>();
}

class NewComment extends StatelessWidget {
  int article;

  NewComment(this.article);

  @override
  Widget build(BuildContext context) {
    var width =  MediaQuery.of(context).size.width;
    var size = width < 1000 ? 16.0 : width < 2000 ? 20.0 : 25.0;
    return Form(
      key: Controllers._formKey,
      child: Padding(
        child: Column(
          children: [
            Row(children: <Widget>[
              Container(
                child: Text('ФИО:', style: TextStyle(fontSize: size)),
              ),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: TextFormField(
                        maxLength: 50,
                        style: TextStyle(fontSize: size),
                        validator: (value) {
                          if (value.isEmpty) return 'Ввведите имя';
                          return null;
                        },
                        controller: Controllers.fio,
                      )))
            ]),
            Row(children: <Widget>[
              Container(child: Text('Email:', style: TextStyle(fontSize: size))),
              Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 15),
                      child: TextFormField(
                        maxLength: 50,
                        style: TextStyle(fontSize: size),
                        validator: (value) {
                          if (value.isEmpty) return 'Ввведите email';
                          return null;
                        },
                        controller: Controllers.email,
                      )))
            ]),
            Row(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('Коментарий:', style: TextStyle(fontSize: size))),
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(left: 15),
                        child: TextFormField(
                          autovalidate: true,
                          keyboardType: TextInputType.multiline,
                          maxLines: 2,
                          maxLength: 100,
                          style: TextStyle(fontSize: size),
                          validator: (value) {
                            if (value.isEmpty) return 'Ввведите коментарий';
                            return null;
                          },
                          controller: Controllers.comment,
                        )))
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            )
          ],
        ),
        padding: EdgeInsets.all(size),
      ),
    );
  }
}

Future<void> addComment(var id, var fio, var email, var comment) async {
  var match = {
    "id": id.toString(),
    "fio": fio,
    "email": email,
    "comment": comment
  };
  var response = await http.post(Uri.parse(ipConnect() + "comment"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: json.encode(match),
      encoding: Encoding.getByName("utf-8"));
  print(json.encode(match));
  print(response.body);
  //final response = await http.get('http://93.79.41.156:3000/article?id=' + id.toString()+'&fio='+fio+'&email='+email+'&comment='+comment);
}
