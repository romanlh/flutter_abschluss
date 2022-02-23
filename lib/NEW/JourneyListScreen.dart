import 'dart:ffi';
import 'dart:js';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abschluss/global.dart';
import 'package:flutter_abschluss/journey/journeyCell.dart';
import 'package:flutter_abschluss/journey/journeyFinal.dart';
import 'package:material_segmented_control/material_segmented_control.dart';

class JourneyListScreen extends StatefulWidget {
  JourneyListScreen({Key key}) : super(key: key);

  @override
  _JourneyListScreenState createState() => _JourneyListScreenState();
}

List<Query> querys = [
  FirebaseDatabase.instance
      .reference()
      .child("Journeys")
      .child("all")
      .orderByChild("date"),
  FirebaseDatabase.instance
      .reference()
      .child("Journeys")
      .child("all")
      .child("Hamburg")
      .orderByChild("date"),
  FirebaseDatabase.instance
      .reference()
      .child("Journeys")
      .child("all")
      .orderByChild("Osnabrück"),
];

class _JourneyListScreenState extends State<JourneyListScreen> {
  Choice _selectedChoice = choices[0];

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: MaterialColor(0xFF0DA7D8, colorMap),
          title: Text("Journeys"),
          actions: <Widget>[
            PopupMenuButton<Choice>(
              onSelected: _select,
              itemBuilder: (BuildContext context) {
                return choices.map((Choice choice) {
                  return PopupMenuItem<Choice>(
                      value: choice, child: Text(choice.title));
                }).toList();
              },
            ),
          ],
        ),
        body: ChoiceCard(choice: _selectedChoice),
      ),
    );
  }

  void _select(Choice choice) {
    setState(() {
      _selectedChoice = choice;
      print(_selectedChoice.title);
    });
  }
}

class ChoiceCard extends StatelessWidget {
  final Choice choice;

  const ChoiceCard({Key key, this.choice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.headline4;
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Icon(
            //   choice.icon,
            //   size: 128.0,
            // ),
            Text(choice.title, style: textStyle),
            FirebaseAnimatedList(
              physics: BouncingScrollPhysics(),
              //query: choice.query,
              query: FirebaseDatabase.instance
                  .reference()
                  .child("Journeys")
                  .orderByChild("date"),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map journey = snapshot.value;
                //return buildJourneyCell(journey: journey, context: context);
                return buildJourneyCell(journey, context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildJourneyItem({Map journey}) {
  print("List -> $journey");
  String location = journey["location"];
  String date = journey["date"];
  String checkInTime = journey["startTime"];
  String locationAndDate = "$location - $date - $checkInTime";
  Global().startTimes.add(checkInTime);

  String version = journey["number"];
  String type = journey["type"];
  String versionAndType = "$type - $version";
  //Color typeColor = getTypeColor(journey["type"]);
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.all(10),
    height: 120,
    color: Colors.white70,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Hier soll eine Art Segmented Corntol hin um die Standorte zu verwalten
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getTypeColor(type),
              ),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              versionAndType,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Spacer(),
            SizedBox(
              width: 6,
            ),
          ],
        ),
        //Obere Reihe
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              child: Icon(
                Icons.person,
                //color: iconColor,
                color: Colors.white,
                //color: Theme.of(context).primaryColor,
                size: 22,
              ),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              journey["name"] ?? "no name",
              style: TextStyle(
                  fontSize: 16,
                  //color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600),
            ),
            Spacer(),
            FloatingActionButton(
              heroTag: journey["id"],
              backgroundColor: Global().secondary,
              mini: true,
              child: Icon(Icons.visibility),
              onPressed: () {
                var id = journey["id"].toString();
                Global().quickTicketNr = "$id";
                Global().quickStartTime = journey["startTime"];

                // if (id != "null") {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => JourneyFinal()),
                //   );
                // }
              },
            )
          ],
        ),
        Row(
          children: [
            Container(
              width: 20,
              height: 20,
              child: Icon(
                Icons.map,
                color: Colors.white,
                size: 22,
              ),
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black54),
            ),
            SizedBox(
              width: 6,
            ),
            Text(
              locationAndDate,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    ),
  );
}

class Choice {
  //const Choice({this.title, this.icon});
  const Choice({this.title, this.query});

  final String title;
  final Query query;
}

List<Choice> choices = <Choice>[
  Choice(title: 'All', query: querys[0]),
  Choice(title: 'Hamburg', query: querys[1]),
  Choice(title: 'Osnabrück', query: querys[2]),
];

Map<int, Color> colorMap = {
  50: Color.fromRGBO(13, 167, 216, .1),
  100: Color.fromRGBO(13, 167, 216, .2),
  200: Color.fromRGBO(13, 167, 216, .3),
  300: Color.fromRGBO(13, 167, 216, .4),
  400: Color.fromRGBO(13, 167, 216, .5),
  500: Color.fromRGBO(13, 167, 216, .6),
  600: Color.fromRGBO(13, 167, 216, .7),
  700: Color.fromRGBO(13, 167, 216, .8),
  800: Color.fromRGBO(13, 167, 216, .9),
  900: Color.fromRGBO(13, 167, 216, 1),
};

Color getTypeColor(String type) {
  Color color = MaterialColor(0xFF0DA7D8, colorMap);

  if (type == "Prod") {
    color = Colors.green.shade200;
  }

  if (type == "Staging") {
    color = Colors.yellow.shade200;
  }

  if (type == "Dev") {
    color = Colors.red.shade200;
  }

  return color;
}
