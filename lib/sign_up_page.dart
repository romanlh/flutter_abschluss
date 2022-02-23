import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abschluss/main.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class USer {
  static const usernane = "Tester";
  static const password = "123456";
}

class _SignUpState extends State<SignUp> {
  final databaseReference = FirebaseDatabase.instance.reference().child("User");
  TextEditingController _emailController,
      _passwordController,
      _passwordControllerCon,
      _usernameController;

  String randomString;
  @override
  void initState() {
    super.initState();
    randomString = getRandomString(9);
    _emailController =
        TextEditingController(text: "$randomString@inSideTester.de");
    _passwordController = TextEditingController(text: USer.password);
    _passwordControllerCon = TextEditingController(text: USer.password);
    _usernameController = TextEditingController(text: USer.usernane);
  }

  String emailChild = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up"),
        ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              TextField(
                //Hier muss noch etwas hin das überprüft ob es den Namen schon gibt
                controller: _usernameController,
                decoration: InputDecoration(labelText: "Username"),
                autocorrect: false,
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                onChanged: (text) {
                  emailChild = text.trim();
                },
              ),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                autocorrect: false,
              ),
              TextField(
                controller: _passwordControllerCon,
                obscureText: true,
                decoration: InputDecoration(labelText: "Confirm Password"),
                onChanged: (text) {
                  if (text != _passwordController.text) {
                    //Hier muss was hin das überprüft ob der Text von passwordController der gleiche ist
                  }
                },
              ),
              SizedBox(
                height: 32,
              ),
              ButtonTheme(
                minWidth: double.infinity,
                height: 48.0,
                child: RaisedButton(
                  onPressed: () async {
                    var email = _emailController.text.trim();
                    var displayName = _usernameController.text.trim();
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email,
                              password: _passwordController.text.trim());

                      // await FirebaseDatabase.instance
                      //     .reference()
                      //     .child(email)
                      //     .set({"email": email});

                      // await FirebaseDatabase.instance
                      //     .reference()
                      //     .child(email)
                      //     .set({"displayName": displayName});

                      // await FirebaseDatabase.instance
                      //     .reference()
                      //     .child(email)
                      //     .set({"location": "*"});
                      //createUser();

                      // databaseReference
                      //     .child("$email")
                      //     .set({"displayName : $displayName"});

                      //databaseReference.
                      // String username =
                      //     FirebaseAuth.instance.currentUser.displayName;

                      // FirebaseDatabase.instance
                      //     .reference()
                      //     .child("Users")
                      //     .child(FirebaseAuth.instance.currentUser.email)
                      //     .set({"Username": "$username"});
                      //createUser();

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuthenticationWrapper()),
                        (Route<dynamic> route) => false,
                      );
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('The password provided is too weak.');
                      } else if (e.code == 'email-already-in-use') {
                        print('The account already exists for that email.');
                      }
                    } catch (e) {
                      print("SignUp -> $e");
                    }
                  },
                  child: Text('Finish Sign Up'),
                  color: Colors.orange,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  elevation: 4.0,
                ),
              )
            ],
          ),
        ));
  }
}
