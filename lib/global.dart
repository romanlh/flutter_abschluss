import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Global {
  static final Global _appData = new Global._internal();
  //GlobaleRef
  DatabaseReference reference = FirebaseDatabase().reference();
  //Globale User Ref
  DatabaseReference userRef = FirebaseDatabase().reference().child("User");
  //Globale Journey Ref
  DatabaseReference refJourney =
      FirebaseDatabase.instance.reference().child("Journeys");
  //Globale Ref auf das Ticket
  //Globale SubJourney Ref
  //Globale ChekIn Ref
  //DatabaseReference checkInRef = FirebaseDatabase.instance.reference().child("Journeys").child(ticketNr).child("checkIn")
  //Global CheckOut Ref

  bool checkInDone;
  String checkInTime;
  String lastStop;
  String lastStart;
  String lastStartTime;
  String lastLine;
  String ticketNr;
  int sjNumber = 0;
  String timeStringInput;
  String timeStringOutput;
  List startTimes = [];
  String quickTicketNr;
  String quickStartTime;
  String quickTransportType;
  Color secondary = Color.fromRGBO(227, 132, 64, 1);
  bool
      editMode; //Wird danach verändert ob man von der Journey auf JourneyFinal kommet oder von der Liste
  factory Global() {
    return _appData;
  }
  Global._internal();

  String getTimeFromRef(DatabaseReference ref) {
    return timeStringOutput;
  }

  getCheckInTime() async {
    await FirebaseDatabase.instance
        .reference()
        .child("Journeys")
        .child(ticketNr)
        .child("checkIn")
        .child("startTime")
        .once()
        .then((DataSnapshot snapshot) {
      var value = snapshot.value;
      print("checkInTime from Database = $value");
      checkInTime = snapshot.value;
      return "$checkInTime";
    });
  }

  Column returnList() {
    var newList = Column(children: [returnFAL()]);
  }

  FirebaseAnimatedList returnFAL() {
    Query query = FirebaseDatabase.instance
        .reference()
        .child("Journeys")
        .child(quickTicketNr)
        .child("subJourneys")
        .orderByChild("id");

    var list = FirebaseAnimatedList(
        query: query,
        itemBuilder: (BuildContext context, DataSnapshot snapshot,
            Animation<double> animation, int index) {
          Map subJourney = snapshot.value;
          return _buildJourneyItem(subJourney: subJourney);
        });
    return list;
  }

  Widget _buildJourneyItem({Map subJourney}) {
    //Color typeColor = getTypeColor(["type"]);
    print("subJourney = $subJourney");
    var start = subJourney["start"].toString();
    String startString = "$start";
    print("start = $start");

    return Container(
      //margin: EdgeInsets.all(15)
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            height: 48,
            alignment: Alignment.center,
            //color: Colors.amber,
            decoration: BoxDecoration(
              border: Border.all(width: 2.0),
              //color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Container(
                  //padding: EdgeInsets.all(7.0),
                  alignment: Alignment.center,
                  height: 32,
                  width: 62,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  child: Text(
                    subJourney["startTime"] ?? "X",
                    textAlign: TextAlign.center,
                  ),
                ),
                //Spacer(),
                SizedBox(
                  width: 8.0,
                ),
                Text(startString ?? "="),
                Spacer(),
                Container(
                  child: Icon(
                    Icons.train,
                    size: 32.0,
                    color: Colors.black87,
                  ),
                  height: 32,
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            height: 48,
            alignment: Alignment.center,
            //color: Colors.amber,
            decoration: BoxDecoration(
              border: Border.all(width: 2.0),
              //color: Colors.amber,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 8,
                ),
                Container(
                  //padding: EdgeInsets.all(7.0),
                  alignment: Alignment.center,
                  height: 32,
                  width: 62,
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(227, 132, 64, 1),
                      border: Border.all(width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  child: Text(
                    subJourney["line"] ?? "X2",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        backgroundColor: Color.fromRGBO(227, 132, 64, 1),
                        color: Colors.white),
                  ),
                ),
                //Spacer(),
                SizedBox(
                  width: 8.0,
                ),
                Text(subJourney["destination"] ?? "destination"),
                Spacer(),
                Container(
                  //alignment: Alignment.centerRight,
                  // decoration: BoxDecoration(
                  //     border: Border.all(width: 1.0),
                  //     borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  child: Icon(
                    Icons.pin_drop,
                    size: 32.0,
                    color: Colors.black87,
                  ),
                  height: 32,
                ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 18,
          ),
        ],
      ),
    );
  }

  //final appData = Global();
}
