import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;




Future<Task> fetchTasks() async {
  final response = await http
      .get(Uri.parse('https://flutter-tasker-server.herokuapp.com/tasks'));

  if (response.statusCode == 200) {

    return Task.fromJson(jsonDecode(response.body));
  } else {

    throw Exception('Failed to load tasks');
  }
}


class Task {
  final String name;
/*  final Object createdDate;
  final Object startDate;
  final Object completeDate;
  final Object deleteDate;*/

  const Task({
    required this.name,
    /*required this.createdDate,
    required this.startDate,
    required this.completeDate,
    required this.deleteDate*/

  });

  factory Task.fromJson(List<dynamic> json) {
    return Task(
      //todo: populate 2 tasks with postMaster, access them properly,display list
      name: json[0],
    /*  createdDate: json['createdDate'],
      startDate: json['startDate'],
      completeDate: json['completeDate'],
      deleteDate: json['deleteDate'],*/
    );
  }
}



void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<Task> futureTask;

  @override
  void initState() {
    super.initState();
    futureTask = fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Tasker'),
        ),
        body: Center(
          child: FutureBuilder<Task>(
            future: futureTask,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!.name);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}