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

Future<Tasks> startTask(String task) async {
  final parsedTaskId = jsonDecode(task)['id'];

  print('${task}');
  print(parsedTaskId);

  final response = await http
      .get(Uri.parse('https://flutter-tasker-server.herokuapp.com/tasks/${parsedTaskId.toString()}/start'));

  if (response.statusCode == 200) {
    print(response.body);
    fetchTasks();
    return Tasks.fromJson(jsonDecode(response.body));
  } else {
    print(response.body);
    throw Exception('Failed to load task');
  }
}


// helper functions
DateTime dateFormatted (int timestamp) {
   return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}


//useing to ensure I can pass data properly
test(String task){
  print('${task}');
  print("!!");
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

  //one of 2 ways trying to open the dialogue
 Future<void> showTaskEditDialog(BuildContext context, String task) async{
   final parsedTask = jsonDecode(task);
    return await showDialog(context: context,
      builder:(context) {
        return AlertDialog(
          content: Text('${parsedTask['name'].toString()}'),
          actions:<Widget>[
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  startTask(task);
                },
                child: Text('start')
            ),
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  test(task);
                },
                child: Text('Delete')
            )
          ],
        );
      }   ,
    );
  }
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
                      onTap: () => showTaskEditDialog(context, jsonEncode(taskslist[index])),
                    //  shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black, width: 1), borderRadius: BorderRadius.circular(5)),
                    );
                  },
                );
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
            onTap: () {
             // showinformationDialog(context);
          },
        ),
      ),
    )


    );
  }
}