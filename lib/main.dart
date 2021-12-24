import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DataFromAPI(),
    );
  }
}

class DataFromAPI extends StatefulWidget {
  @override
  _DataFromAPIState createState() => _DataFromAPIState();
}

class _DataFromAPIState extends State<DataFromAPI> {
  Future getUserData() async {
    var response = await http.get(Uri.http("127.0.0.1:8000", "/api/recipe"));

    var jsonData = jsonDecode(response.body);
    // print(jsonData);
    List<User> users = [];

    for (var u in jsonData) {
      User user = User(u["name"], u["images"], u["rating"], u["totalTime"]);

      users.add(user);
    }

    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Order'),
      ),
      body: Container(
          child: Card(
            child: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container(
                    child: Center(
                      child: Text('Loading..'),
                    ),
                  );
                } else
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                              title: Text(snapshot.data[i].name),
                              subtitle: Text(snapshot.data[i].images),
                              trailing: Text(snapshot.data[i].rating),
                        );
                      });
              },
            ),
          ),
        )
    );
  }
}

class User {
  final String name, images, rating, totalTime;
  User(this.name, this.images, this.rating, this.totalTime);
}
