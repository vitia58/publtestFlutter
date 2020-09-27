import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:http/http.dart';

String ip = "93.79.41.156";
int port = 3000;

String ipConnect() {
  final v = "http://" + ip + ":" + port.toString() + "/";
  //print(v);
  return v;
}
var client = http.Client();
Future<Response> connect(String body) async {
  print(ipConnect() + body);

  try{
    final response = await client.get(ipConnect() + body)
        .timeout(const Duration(seconds: 5));
    if (response.statusCode != 200) {
      port = port == 3000 ? 3200 : 3000;
      return connect(body);
    }
    return response;
  } on SocketException catch (_){
    port = port == 3000 ? 3200 : 3000;
    return connect(body);
  }
}
