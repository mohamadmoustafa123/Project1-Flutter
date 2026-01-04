import 'dart:convert' as convert;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project1/SignUp.dart';

import 'ToDo.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> submitLogin() async {
    String path = "http://mohamadmoustafa.atwebpages.com/signIn.php";
    Uri uri = Uri.parse(path);
    var response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: convert.jsonEncode(<String, String>{
        'email': email.text,
        'password': password.text,
      }),
    );
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      print("response bodyyy: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['message']),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => ToDo()));
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (email.text == "" || password.text == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("you should enter all filled !!!"),
                            backgroundColor: Colors.red,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      } else {
                        submitLogin();
                      }
                    },
                    child: Text("Sign in"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
