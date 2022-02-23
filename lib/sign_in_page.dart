import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_abschluss/main.dart';
import 'package:flutter_abschluss/sign_up_page.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';
import 'main.dart';
import 'journey/journeyList.dart';

//import 'sign_up_page.dart'; -> muss noch entwickelt werden

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      print("SignInPage -> $firebaseUser");
      return MyHomePage();
    }
    print("No User");
    return SignInPage();
  }
}

class SignInPage extends StatelessWidget {
  final TextEditingController emailController =
      TextEditingController(text: "roman.hckl@gmail.com");
  final TextEditingController passwordController =
      TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text("Sign in"),
          ],
        ),
        //backgroundColor: Colors.blue,
        bottom: PreferredSize(
          child: Container(),
          preferredSize: Size.fromHeight(6.0),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            SizedBox(height: 8),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 8),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(
              height: 48 / 2,
            ),
            ButtonTheme(
              minWidth: double.infinity,
              height: 48.0,
              child: RaisedButton(
                onPressed: () {
                  context.read<AuthenticationService>().signIn(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim());

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AuthenticationWrapper()),
                    (Route<dynamic> route) => false,
                  );

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => AuthenticationWrapper()),
                  // );
                },
                child: Text('Sign in'),
                color: Colors.orange,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 4.0,
              ),
            ),
            SizedBox(height: 32 / 2),
            ButtonTheme(
              minWidth: double.infinity,
              height: 48.0,
              child: RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                child: Text('Sign Up'),
                color: Colors.orange,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                elevation: 4.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
