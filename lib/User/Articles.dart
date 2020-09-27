import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:publtest/Connection.dart';
import 'package:publtest/User/Article.dart';

import 'Main.dart';

Future<List<ArticleMin>> fetchArticles(http.Client client) async {
  final response = await connect('listarts');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseArticles, response.body);
}

List<ArticleMin> parseArticles(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<ArticleMin>((json) => ArticleMin.fromJson(json)).toList();
}

class ArticleMin {
  final int id;
  final String name;
  final String text;

  ArticleMin(this.id, this.name, this.text);

  factory ArticleMin.fromJson(Map<String, dynamic> json) {
    return ArticleMin(
        json['id'] as int, json['name'] as String, json['text'] as String);
  }
}


class refresh extends StatefulWidget {
  @override
  _refreshState createState() => _refreshState();
}

class _refreshState extends State<refresh> {
  BuildContext context;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(child:ArticleList(),onRefresh: _refreshList,displacement: 100,);
  }

  Future<Null> _refreshList() async{
    setState(() {});
  }
}
class ArticleList extends StatefulWidget {
  @override
  _ArticleListState createState() => _ArticleListState();
}

class _ArticleListState extends State<ArticleList> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<List<ArticleMin>>(
            future: fetchArticles(http.Client()),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData?ListView.separated(
                itemBuilder: (_, index) => ArticleItem(snapshot.data[index]),
                separatorBuilder: (_, __) => Divider(),
                itemCount: snapshot.data.length,
              ):Center(child: CircularProgressIndicator());
            }));
  }
}

class ArticleItem extends StatelessWidget {
  ArticleMin article;

  ArticleItem(this.article);

  @override
  Widget build(BuildContext context) {
    var width =  MediaQuery.of(context).size.width;
    return Card(
      child: ListTile(
        title: Text(
          article.name,
          style: TextStyle(fontSize: width < 1000 ? 20 : width < 2000 ? 25 : 30),
        ),
        subtitle: Text(article.text),
        trailing: Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Article(article.id,article.name,article.text),
            ),
          ).then((value) => {
            User.page=-1
          });
        },
      ),
    );
  }
}
