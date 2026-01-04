import 'dart:convert' as convert;
import 'dart:convert' as converter;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project1/Completed.dart';
import 'package:project1/Non-Completed.dart';

import 'Task.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _TodoState();
}

class _TodoState extends State<ToDo> {
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  TextEditingController tasksCtrl = TextEditingController();
  TextEditingController tasksCtrlEditings = TextEditingController();
  String tasks = "";

  List<Task> listTasks = [];
  bool showCardEdit = false;
  int edittingIndex = 0;

  Future<void> fetchData() async {
    String path = "http://mohamadmoustafa.atwebpages.com/getTasks.php";
    Uri uri = Uri.parse(path);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      setState(() {
        var jsonArray = converter.jsonDecode(response.body);
        for (var element in jsonArray) {
          bool doneStatus = element['isCompleted'].toString() == '1'
              ? true
              : false;
          Task t = Task(
            ID: int.parse(element["ID"]),
            title: element["Task"],
            done: doneStatus,
          );

          listTasks.add(t);
        }
      });
    }
  }

  Future<void> addTask() async {
    String path = "http://mohamadmoustafa.atwebpages.com/addTask.php";
    Uri uri = Uri.parse(path);
    var response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{'Task': tasksCtrl.text}),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        listTasks.add(Task(ID: data['id'], title: tasksCtrl.text));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      tasksCtrl.text = "";
    } else {
      var data = jsonDecode(response.body);
      print("response bodyyy: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['error']),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> editTasks() async {
    String path =
        "http://mohamadmoustafa.atwebpages.com/updateTask.php?id=${edittingIndex}";
    Uri uri = Uri.parse(path);
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'newTitle': tasksCtrlEditings.text,
      }),
    );
    if (response.statusCode == 200) {
      setState(() {
        Task taskbyid = listTasks.firstWhere((t) => t.ID == edittingIndex);
        taskbyid.title = tasksCtrlEditings.text;
        showCardEdit = !showCardEdit;
        String message = response.body;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      });
    } else {
      String message = response.body;
      print("response bodyyy: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> updateCompleted(Task objTask) async {
    String path =
        "http://mohamadmoustafa.atwebpages.com/updateTaskIsCompleted.php?id=${objTask.ID}";
    Uri uri = Uri.parse(path);
    var response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        objTask.done = !objTask.done;
        String message = response.body;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      });
    } else {
      String message = response.body;
      print("response bodyyy: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> deleteTask(int ID, int index) async {
    String path = "http://mohamadmoustafa.atwebpages.com/delete.php?id=${ID}";
    Uri uri = Uri.parse(path);
    var response = await http.delete(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        listTasks.removeAt(index);
        String message = response.body;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      });
    } else {
      String message = response.body;
      print("response bodyyy: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Todo List")),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: 400,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: tasksCtrl,
                          decoration: InputDecoration(labelText: "Add tasks"),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          addTask();
                        },
                        child: Text("Add "),
                      ),
                    ],
                  ),

                  SizedBox(height: 30),
                  ...listTasks.asMap().entries.map((element) {
                    int index = element.key;
                    Task objTask = element.value;

                    return SizedBox(
                      width: double.infinity,
                      child: Card(
                        elevation: 3,
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                objTask.title,
                                style: TextStyle(fontSize: 16),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.done,
                                      color: objTask.done
                                          ? Colors.green
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        updateCompleted(objTask);
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        edittingIndex = objTask.ID;
                                        tasksCtrlEditings.text = objTask.title;
                                        showCardEdit = !showCardEdit;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        deleteTask(objTask.ID, index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  SizedBox(height: 30),
                  SizedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Completed(),
                                settings: RouteSettings(arguments: listTasks),
                              ),
                            );
                          },
                          child: Text(
                            "Tasks-Completed",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NonCcompleted(),
                                settings: RouteSettings(arguments: listTasks),
                              ),
                            );
                          },
                          child: Text(
                            "Tasks-non-Completed",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (showCardEdit)
            Positioned(
              child: Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 420,
                  child: Card(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Expanded(
                              child: TextField(
                                controller: tasksCtrlEditings,
                                decoration: InputDecoration(
                                  labelText: "enter what you want edit",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              editTasks();
                            },
                            child: Text("Edit"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
