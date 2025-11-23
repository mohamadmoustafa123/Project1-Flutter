import 'package:flutter/material.dart';

import 'Task.dart';

class NonCcompleted extends StatefulWidget {
  const NonCcompleted({super.key});

  @override
  State<NonCcompleted> createState() => _NonCcompletedState();
}

class _NonCcompletedState extends State<NonCcompleted> {
  @override
  Widget build(BuildContext context) {
    final List<Task>? listTask =
        ModalRoute.of(context)?.settings.arguments as List<Task>?;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tasks-Non-Completed",
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          child: Column(
            children: [
              if (listTask == null)
                Text("non tasks-NonCompleted ")
              else
                ...listTask.map((element) {
                  if (!element.done) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(element.title, style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                }),
            ],
          ),
        ),
      ),
    );
    ;
  }
}
