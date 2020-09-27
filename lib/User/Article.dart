import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:publtest/User/AddComment.dart';

import '../Connection.dart';

class ArticleItem {
  String name, text;

  ArticleItem({this.name, this.text});

  factory ArticleItem.fromJson(Map<String, dynamic> json) {
    return ArticleItem(text: json['text'], name: json['name']);
  }

  @override
  String toString() {
    return "name = $name; comment = $text";
  }
}

class CommentItem {
  String name, comment;

  CommentItem({this.name, this.comment});

  factory CommentItem.fromJson(Map<String, dynamic> json) {
    return CommentItem(name: json['name'], comment: json['comment']);
  }

  @override
  String toString() {
    return "name = $name; comment = $comment";
  }
}

Future<ArticleItem> fetchArticle(int article) async {
  final response = await connect('article?id=' + article.toString());
  if (response.statusCode == 200) {
    print(response.body);
    return ArticleItem.fromJson(json.decode(response.body)[0]);
  } else {
    return ArticleItem.fromJson(json.decode(
        '[{"name":"Ошибка","text":"Не удалось подключится к серверу"}]')[0]);
  }
}

Future<List<CommentItem>> fetchComments(int article) async {
  final response = await connect('comments?id=' + article.toString());
  return compute(parseComments, response.body);
}

List<CommentItem> parseComments(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<CommentItem>((json) => CommentItem.fromJson(json)).toList();
}

class Article extends StatefulWidget {
  final int article;
  final String preloadedHead, preloadedBody;

  Article(this.article, this.preloadedHead, this.preloadedBody);

  @override
  _ArticleState createState() => _ArticleState();
}

class _ArticleState extends State<Article> {
  @override
  Widget build(BuildContext context) {
    var width =  MediaQuery.of(context).size.width;
    var size = width < 1000 ? 20.0 : width < 2000 ? 25.0 : 30.0;
    String headtext =
        widget.preloadedHead == null ? "Загрузка" : widget.preloadedHead;
    Text head = Text(
      headtext,
      style: TextStyle(fontSize: size),
    );
    return Scaffold(
        appBar: AppBar(
          title: head,
          backgroundColor: Colors.blueAccent,
          centerTitle: true,
        ),
        body: FutureBuilder<ArticleItem>(
            future: fetchArticle(widget.article),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print(snapshot.error);
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text('Ошибка')));
              }
              //print(widget.preloadedHead+"/"+widget.preloadedBody+"/"+widget.article.toString());
              if (snapshot.hasData) {
                headtext = snapshot.data.text;
                print(snapshot.data.toString());
                return Body(snapshot.data.text, widget.article);
              } else {
                return Column(children: <Widget>[
                  Body(widget.preloadedBody, widget.article),
                  Center(child: CircularProgressIndicator())
                ]);
              }
            }));
  }
}

class Body extends StatefulWidget {
  String text;
  int article;

  Body(this.text, this.article);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    var width =  MediaQuery.of(context).size.width;
    var size = width < 1000 ? 18.0 : width < 2000 ? 22.0 : 25.0;
    return ListView(children: <Widget>[
      Padding(
          child: Text(widget.text,
              textAlign: TextAlign.justify, style: TextStyle(fontSize: size)),
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40)),
      Divider(
        thickness: 2,
        height: 20,
        color: Colors.blueAccent,
      ),
      Center(
          child: Card(
        child: ListTile(
          leading: Icon(
            Icons.comment,
          ),
          title: Text(
            "Добавить коментарий",
            style: TextStyle(fontSize: size),
          ),
          onTap: (() => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Commentwindow(widget.article),
                  ),
                ).then((value) => {setState(() {})})
              }),
        ),
      )),
      Comments(widget.article)
      /*]),
        ListView(
          children: <Widget>[
            Card(
              child: ListTile(
                leading: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                title: Text(
                  "Назад",
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () => {
                  setState(() {
                    index = 0;
                  })
                },
              ),
            ),
            NewComment(widget.article),
            Comments(widget.article)
          ],
        ),*/
    ]);
  }
}

class Comments extends StatelessWidget {
  static List<CommentItem> lastcomms = List<CommentItem>();
  int article;

  Comments(this.article);

  @override
  Widget build(BuildContext context) {
    var comments = List<Widget>();
    comments.add(Center(
      child: Text(
        "Коментарии: ",
        style: TextStyle(fontSize: 25),
      ),
    ));
    return Container(
        child: FutureBuilder<List<CommentItem>>(
            future: fetchComments(article),
            builder: (context, snapshot) {
              //if (snapshot.hasError) print(snapshot.error);
              if (snapshot.hasData) {
                //print(snapshot.data[0].toString());
                E:
                for (int i = 0; i < snapshot.data.length; i++) {
                  for (int j = 0; j < lastcomms.length; j++) {
                    if (lastcomms[j].hashCode == snapshot.data[i].hashCode)
                      continue E;
                  }
                  comments.add(Comment(snapshot.data[i]));
                  lastcomms.add(snapshot.data[i]);
                }
                return Column(
                  children: comments,
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class Comment extends StatelessWidget {
  String name, text;

  Comment(CommentItem snapshot) {
    name = snapshot.name;
    text = snapshot.comment;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: Card(
        child: ListTile(
          title: Text(
            name,
            style: TextStyle(fontSize: 20),
          ),
          subtitle: Text(
            text,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 15),
          ),
        ),
      ),
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
    );
  }
}
