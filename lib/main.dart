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

Future<String> startTask(String task) async {
  final parsedTaskId = jsonDecode(task)['id'];

  print('${task}');
  print(parsedTaskId);

  final response = await http
      .get(Uri.parse('https://flutter-tasker-server.herokuapp.com/tasks/${parsedTaskId.toString()}/start'));

  if (response.statusCode == 200) {
    fetchTasks();
    return '';
  } else {
    print(response.body);
    throw Exception('Failed to load task');
  }
}

Future<String> deleteTask(String task) async {
  final parsedTaskId = jsonDecode(task)['id'];

  print('${task}');
  print(parsedTaskId);

  final response = await http
      .get(Uri.parse('https://flutter-tasker-server.herokuapp.com/tasks/${parsedTaskId.toString()}/delete'));

  if (response.statusCode == 200) {
    fetchTasks();
    return '';
  } else {
    print(response.body);
    throw Exception('Failed to load task');
  }
}


Future<String> completeTask(String task) async {
  final parsedTaskId = jsonDecode(task)['id'];

  print('${task}');
  print(parsedTaskId);

  final response = await http
      .get(Uri.parse('https://flutter-tasker-server.herokuapp.com/tasks/${parsedTaskId.toString()}/complete'));

  if (response.statusCode == 200) {
    print(response.body);
    fetchTasks();
    return '';
  } else {
    print(response.body);
    throw Exception('Failed to load task');
  }
}


// helper functions
DateTime dateFormatted (int timestamp) {
   return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
}

String taskStatus (String task) {
  final parsedTask = jsonDecode(task);
  if(parsedTask['completedAt'] != null) {
    return 'task completed';
  } else if (parsedTask['startedAt'] == null) {
    return 'task not started';
  }else return 'in progress';
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
                  completeTask(task);
                },
                child: Text('complete')
            ),
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                  deleteTask(task);
                },
                child: Text('Delete')
            )
          ],
        );
      }   ,
    );
  }

 Future<void> showNewTaskDialog(BuildContext context) async{
   return await showDialog(context: context,
     builder:(context) {
       return AlertDialog(
         content: Text('new task'),
         actions:<Widget>[
           TextButton(
               onPressed: (){
                 Navigator.of(context).pop();

               },
               child: Text('start')
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

// James, I suspect I'm not adding my tasks to state properly and may be missing a few structual things, preventing event listeners from being implementable currently
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
                List filteredTaskList = [];
                taskslist.forEach((task) {
                  if(task["deletedAt"] == null) {

                    filteredTaskList.add(task);
                  }
                });

                return ListView.builder(
                  itemCount: filteredTaskList.length,
                  itemBuilder: (context, index) {

                    return ListTile(


                      title: Text(filteredTaskList[index]['name'].toString()),
                      subtitle: Text(
                         'Status: ${taskStatus(jsonEncode(filteredTaskList[index]))}'
                       //   "create at: ${dateFormatted(filteredTaskList[index]["createdAt"])}"
                      ),
                      trailing: Icon(Icons.more_vert),
                      isThreeLine: true,
                      // white not start, blue in progress, green completed
                      tileColor: filteredTaskList[index]['startedAt'] == null ? Colors.white : filteredTaskList[index]['completedAt'] != null ? Colors.green : Colors.blue,
                      onTap: () => showTaskEditDialog(context, jsonEncode(filteredTaskList[index])),
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

     /*   bottomNavigationBar: Container(
          height: 60,
          color: Colors.black12,
          child: InkWell(
            onTap: () {
              showNewTaskDialog(context);
          },
        ),
      ),*/
        
        // james, No MaterialLocalizations found error
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showNewTaskDialog(context);
          },
          child: const Icon(
            Icons.add_box_rounded,
            color: Colors.white,

          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    )


    );
  }
}
