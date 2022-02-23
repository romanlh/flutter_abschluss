import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'authentication_service.dart';
import 'package:provider/provider.dart';

//TODO: Username TextField mit inital Wert von allem vor dem @ der Email

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController passwordController2 = TextEditingController();
    String val1 = "";
    String val2 = "";

    final firebaseUser = context.watch<User>();

    return Scaffold(
        appBar: AppBar(
          title: Text("Password"),
          actions: [],
        ),
        body: Container(
            //width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                //Text(firebaseUser.displayName),
                //Spacer(),
                // SizedBox(
                //   height: 36,
                // ),
                // Text(
                //   "Change Password",
                //   style: TextStyle(
                //       color: Colors.black,
                //       fontWeight: FontWeight.w300,
                //       decoration: TextDecoration.underline,
                //       fontSize: 20),
                // ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "Old Password"),
                  onChanged: (text) {
                    val1 = text;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: "New Password"),
                  onChanged: (text) {
                    val1 = text;
                  },
                ),
                TextFormField(
                  controller: passwordController2,
                  decoration:
                      InputDecoration(labelText: "Confirm New Password"),
                  onChanged: (text) {
                    val2 = text;
                  },
                ),
                SizedBox(
                  height: 24,
                ),
                Container(
                  width: double.infinity,
                  height: 48,
                  //padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    onPressed: () {
                      if (val1 == val2 && val1 != "") {
                        firebaseUser.updatePassword(val2);
                        print("Password changed");
                      } else {
                        print("Passwords doenst match");
                      }
                    },
                  ),
                ),
                Spacer(
                  flex: 2,
                ),
                Container(
                  width: double.infinity,
                  height: 48,
                  //padding: EdgeInsets.symmetric(horizontal: 8),
                  child: ElevatedButton(
                    child: Text(
                      "Sign Out",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 20),
                    ),
                    onPressed: () {
                      context.read<AuthenticationService>().signOut();
                    },
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
              ],
            )));
  }
}
