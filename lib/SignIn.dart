import 'package:flutter/material.dart';

import 'ToDo.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String msg = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Sign In",
            style: TextStyle(color: Colors.purple, fontWeight: FontWeight.w900),
          ),
        ),
      ),

      body: Center(
        child: SizedBox(
          width: 400,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: password,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                child: ElevatedButton(
                  onPressed: () {
                    if (name.text == "" ||
                        email.text == "" ||
                        password.text == "") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("you should enter all filled !!!"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ToDo()),
                      );
                    }
                  },
                  child: Text("data"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
