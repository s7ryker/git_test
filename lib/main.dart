import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:github_repos/screen/homescreen.dart';
import 'package:http/http.dart' as http;
import 'models/repo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

Future<http.Response> fetchRepos(String username) async {
  final response =
      await http.get(Uri.parse("https://api.github.com/users/$username/repos"));

  print(response.body);
  return response;
}
