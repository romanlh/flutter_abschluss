import 'package:flutter/material.dart';
import 'package:flutter_abschluss/journey/journey.dart';

import '../global.dart';
import 'journeyFinal.dart';

Widget buildJourneyCell(Map journey, {BuildContext context}) {
  // print("Journey Cell -> $journey");
  String location = journey["location"];
  String date = journey["date"];
  String checkInTime = journey["startTime"];
  String locationAndDate = "$location - $date - $checkInTime";
  Global().startTimes.add(checkInTime);

  String version = journey["number"];
  String type = journey["type"];
  String versionAndType = "$type - $version";

  double cellWidth = 130;
  MainAxisAlignment cellMAA = MainAxisAlignment.spaceAround;
  //Color typeColor = getTypeColor(journey["type"]);
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10),
    padding: EdgeInsets.all(10),
    height: 120,
    color: Colors.white70,
    child: Center(
      child: Row /*or Column*/ (
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //mainAxisSize: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Container(
          //   color: Colors.yellow,
          //   height: 100,
          //   width: 100,
          //   child: Column(
          //     mainAxisAlignment: cellMAA,
          //     children: [
          //       Text(journey["startTime"]),
          //       Text(journey["startTime"]),
          //     ],
          //   ),
          // ),
          Container(
            color: Colors.amber,
            height: 100,
            width: 250,
            child: Column(
              mainAxisAlignment: cellMAA,
              children: [Text(journey["start"]), Text("Text 2")],
            ),
          ),
          MaterialButton(
            //heroTag: journey["id"],
            onPressed: () {
              var id = journey["id"].toString();
              Global().quickTicketNr = "$id";
              Global().quickStartTime = journey["startTime"];

              if (id != "null") {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JourneyFinal()),
                );
              }
            },
            color: Colors.teal,
            height: 100,
            minWidth: 100,
          ),
        ],
      ),
    ),
    // child: Row /*or Column*/ (
    //   crossAxisAlignment: CrossAxisAlignment.stretch,
    //   children: <Widget>[
    //     Icon(Icons.star, size: 50),
    //     Icon(Icons.star, size: 300),
    //     Icon(Icons.star, size: 50),
    //   ],
    // ),
  );
}
