import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;



// request functions
Future<Tasks> fetchTasks() async {
  final response = await http
      .get(Uri.parse('https://flutter-tasker-server.herokuapp.com/tasks'));

  if (response.statusCode == 200) {
    return Tasks.fromJson(jsonDecode(response.body));
  } else {

    throw Exception('Failed to load tasks');
  }
}

// helper functions
DateTime dateFormatted (int timestamp) {
   return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}

class Task {

  final String name;
  final Object createdDate;
  final Object startDate;
  final Object completeDate;
  final Object deleteDate;

  const Task({
    required this.name,
    required this.createdDate,
    required this.startDate,
    required this.completeDate,
    required this.deleteDate

  });
}


class Tasks {
  final List tasks;

  const Tasks({
    required this.tasks

  });

  factory Tasks.fromJson(List <dynamic> json) {
    return Tasks(
      //todo: populate 2 tasks with postMaster, access them properly,display list
      tasks: json,
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
  late Future<Tasks> futureTasks;

  @override
  void initState() {
    super.initState();
    futureTasks = fetchTasks();
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
          child: FutureBuilder<Tasks>(
            future: futureTasks,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List taskslist = snapshot.data!.tasks;
                return ListView.builder(
                  itemCount: taskslist.length,
                  itemBuilder: (context, index) {

                    return ListTile(
                      title: Text(taskslist[index]['name'].toString()),
                      subtitle: Text(
                          "create at: ${dateFormatted(taskslist[index]["createdAt"])}"
                      ),
                      trailing: Icon(Icons.more_vert),
                      isThreeLine: true,
                      onTap: () => print('temporary - will be a function'),
                    );
                  },
                );
               // return Text(snapshot.data!.tasks.toString());
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),

        bottomNavigationBar: Container(
          height: 60,
          color: Colors.black12,
          child: InkWell(
            onTap: () => print('temporary - will be a function'),
            child: Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.add_box_outlined,
                    color: Theme.of(context).accentColor,
                  ),
                  Text('New Task'),
                ],
              ),
            ),
          ),
        ),


   /*     bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined),
              label: 'New',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera),
              label: 'Delete',
            ),

          ],
        ),*/




      ),
    );
  }
}