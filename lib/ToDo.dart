import 'package:flutter/material.dart';
import 'package:project1/Completed.dart';
import 'package:project1/Non-Completed.dart';

import 'Task.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _TodoState();
}

class _TodoState extends State<ToDo> {
  TextEditingController tasksCtrl = TextEditingController();
  TextEditingController tasksCtrlEditings = TextEditingController();
  String tasks = "";

  List<Task> listTasks = [];
  bool showCardEdit = false;
  int edittingIndex = 0;

  void FetchData() {}

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
                          setState(() {
                            listTasks.add(Task(title: tasksCtrl.text));
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(" your task added "),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                            ),
                          );
                          tasksCtrl.text = "";
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
                                        objTask.done = !objTask.done;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      setState(() {
                                        edittingIndex = index;
                                        tasksCtrlEditings.text = objTask.title;
                                        showCardEdit = !showCardEdit;
                                      });
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        listTasks.removeAt(element.key);
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
                              setState(() {
                                listTasks[edittingIndex].title =
                                    tasksCtrlEditings.text;
                                showCardEdit = !showCardEdit;
                              });
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
