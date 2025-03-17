import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:json_to_form/json_schema.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _Register createState() => _Register();
}

class _Register extends State<Register> {
  Map keyboardTypes = {
    "number": TextInputType.number,
  };
  String form = json.encode({
    'fields': [
      {
        'key': 'name',
        'type': 'Input',
        'label': 'Name',
        'placeholder': "Enter Your Name",
        'required': true,
      },
      {
        'key': 'username',
        'type': 'Input',
        'label': 'Username',
        'placeholder': "Enter Your Username",
        'required': true,
        'hiddenLabel': true,
      },
      {'key': 'email', 'type': 'Email', 'label': 'email', 'required': true},
      {
        'key': 'password1',
        'type': 'Password',
        'label': 'Password',
        'required': true
      },
      {'key': 'number', 'type': 'Input', 'label': 'number', 'required': true},
    ]
  });
  dynamic response;

  Map decorations = {
    'email': InputDecoration(
      hintText: 'Email',
      prefixIcon: const Icon(Icons.email),
      contentPadding: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    ),
    'username': const InputDecoration(
      labelText: "Enter your email",
      prefixIcon: Icon(Icons.account_box),
      border: OutlineInputBorder(),
    ),
    'password1': const InputDecoration(
        prefixIcon: Icon(Icons.security), border: OutlineInputBorder()),
  };

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Login"),
      ),
      body: SingleChildScrollView(
        child: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10.0),
              child: const Text(
                "Register Form",
                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
              ),
            ),
            JsonSchema(
              decorations: decorations,
              keyboardTypes: keyboardTypes,
              form: form,
              onChanged: (dynamic response) {
                print(jsonEncode(response));
                this.response = response;
              },
              actionSave: (data) {
                print(data);
              },
              buttonSave: Container(
                height: 40.0,
                color: Colors.blueAccent,
                child: const Center(
                  child: Text("Register",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
