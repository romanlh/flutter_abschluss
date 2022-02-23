import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abschluss/global.dart';
//import 'package:flutter_abschluss/journey/journeyCreator.dart';
import 'package:flutter_abschluss/journey/journeyFinal.dart';

import 'journeyCell.dart';

//import '../sign_in_page.dart';
//import 'journeyViewer.dart';

class Journeys extends StatefulWidget {
  Journeys({Key key}) : super(key: key);

  @override
  _JourneysState createState() => _JourneysState();
}

class _JourneysState extends State<Journeys> {
  Query _ref;
  Color iconColor;
  double iconSize = 14;

  @override
  void initState() {
    super.initState();
    Global().editMode = true;
    _ref = FirebaseDatabase.instance
        .reference()
        .child("Journeys")
        .orderByChild("date");
    //.orderByChild("desc");
    //.orderBy("date", "desc");

    //print("_ref = $_ref");
    iconColor = Global().secondary;
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
                  size: iconSize,
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black54),
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

                  if (id != "null") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JourneyFinal()),
                    );
                  }
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
                  size: iconSize,
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.black54),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Journeys"),
        ),
        body: Container(
          height: double.infinity,
          child: FirebaseAnimatedList(
            physics: BouncingScrollPhysics(),
            query: _ref,
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {
              Map journey = snapshot.value;
              //return buildJourneyCell(journey: journey, context: context);
              return buildJourneyCell(journey, context: context);
            },
          ),
        ));
  }

  Color getTypeColor(String type) {
    Color color = Theme.of(context).accentColor;

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
}
