import 'package:flutter/material.dart';
import 'package:project1/Task.dart';

class Completed extends StatefulWidget {
  const Completed({super.key});

  @override
  State<Completed> createState() => _CompletedState();
}

class _CompletedState extends State<Completed> {
  @override
  Widget build(BuildContext context) {
    final List<Task>? listTask =
        ModalRoute.of(context)?.settings.arguments as List<Task>?;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tasks-Completed",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SizedBox(
          child: Column(
            children: [
              if (listTask == null)
                Text("non tasks-completed ")
              else
                ...listTask.map((element) {
                  if (element.done) {
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
  }
}
