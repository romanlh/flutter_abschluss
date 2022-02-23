import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abschluss/authentication_service.dart';
import 'package:flutter_abschluss/journey/journeyWriter.dart';
import 'package:flutter_abschluss/sign_in_page.dart';

import '../global.dart';
import 'journeyList.dart';
import 'package:intl/intl.dart';

class JourneyFinal extends StatefulWidget {
  @override
  _JourneyFinalState createState() => _JourneyFinalState();
}

class _JourneyFinalState extends State<JourneyFinal> {
  Query _subJourneys;
  DatabaseReference ticketRef;
  DatabaseReference checkInRef;
  String checkInTime;
  var ticketNr;
  bool showButton;
  Widget actionItem;
  //double falHeight; Wurde benutzt um die Höher der animierten Liste nach editMode auszurichten
  @override
  void initState() {
    super.initState();
    print("jounreyFinal");
    //Global().getCheckInTime();
    //print(Global().startTimes);

    if (Global().editMode) {
      actionItem = Container();
      //CheckInTime aus der Datenbank holen
      checkInTime = Global().quickStartTime ?? "No2";
      //print("checkInTime = $checkInTime");
      ticketNr = Global().quickTicketNr ?? "Nr";
      //print("ticketNr = $ticketNr");
    } else {
      checkInTime = Global().checkInTime ?? "No";
      ticketNr = Global().ticketNr ?? "Nr";
      actionItem = Container(
        width: double.infinity,
        height: 48,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ElevatedButton(
          style: ButtonStyle(),
          child: Text(
            "CheckOut",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
          ),
          onPressed: () {
            var outputFormat = DateFormat("HH:mm");
            var output = outputFormat.format(DateTime.now());
            String stop = Global().lastStop ?? "Kein Global lastStop gefunden";
            JourneyWriter().mapCheckOut(stop, output);

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => AuthenticationWrapper()),
              (Route<dynamic> route) => false,
            );
          },
        ),
      );
    }

    _subJourneys = FirebaseDatabase.instance
        .reference()
        .child("Journeys")
        .child(ticketNr)
        .child("subJourneys")
        .orderByChild("id");
    //.orderByChild("SJ");

    ticketRef =
        FirebaseDatabase.instance.reference().child("Journeys").child(ticketNr);

    //Future<dynamic> checkInTimeDataBase = Global().getCheckInTime();

    checkInRef = ticketRef.child("checkIn");
    //checkInTime = "$checkInTimeDataBase" ?? "Error";
    //print("checkInTime = $checkInTime");
    //print("/");
    //print("ticketNR = $ticketNr");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zusammenfassung"),
      ),
      body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 3,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(32.0))),
                      child: Text(
                        checkInTime ?? "No",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    //Spacer(),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("CheckIn"),
                    //Spacer(),
                    // Container(
                    //   child: Text("CheckIn"),
                    //   height: 32,
                    // ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ),
              Container(
                height: 400,
                child: FirebaseAnimatedList(
                  physics: BouncingScrollPhysics(),
                  query: _subJourneys,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map subJourney = snapshot.value;
                    //subJourneys.add(subJourney.toString());
                    //print("subJounrey = $subJourney");
                    checkInTime = subJourney["StartTime"];
                    print("checkInTime = $checkInTime");
                    //print("NEW CHECKINTIME = $subJourney");

                    return _buildJourneyItem(subJourney: subJourney);
                  },
                ),
              ),
              actionItem,
              Spacer(),
              SizedBox(
                height: 24,
              ),
            ],
          )),
    );
  }

  // Color getTypeColor(String type) {
  //   Color color = Theme.of(context).accentColor;

  //   if (type == "Prod") {
  //     color = Colors.green;
  //   }

  //   if (type == "Staging") {
  //     color = Colors.yellow;
  //   }

  //   if (type == "Dev") {
  //     color = Colors.red;
  //   }

  //   return color;
  // }

  Widget _buildCheckInItem(String time) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
              time,
              textAlign: TextAlign.center,
            ),
          ),
          //Spacer(),
          SizedBox(
            width: 8.0,
          ),
          Text("CheckIn"),
          //Spacer(),
          // Container(
          //   child: Text("CheckIn"),
          //   height: 32,
          // ),
          SizedBox(
            width: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyItem({Map subJourney}) {
    //Color typeColor = getTypeColor(ticketRef.child("type").);
    //print("subJourney = $subJourney");
    var start = subJourney["start"].toString() ?? "start";
    String startString = "$start";
    String transportType = subJourney["transportType"];
    String type = subJourney["type"];
    print("// -> type = $type");
    IconData typeTransport;

    if (transportType == "Bus") {
      typeTransport = Icons.directions_bus;
    }

    if (transportType == "Bahn") {
      typeTransport = Icons.train;
    }

    return Container(
      //margin: EdgeInsets.all(15)
      child: Column(
        children: [
          Container(
            //color: getTypeColor(type),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                    typeTransport,
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
            //margin: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                //Text(subJourney["destination"] ?? "destination"),
                Spacer(),
                // Container(
                //   //alignment: Alignment.centerRight,
                //   // decoration: BoxDecoration(
                //   //     border: Border.all(width: 1.0),
                //   //     borderRadius: BorderRadius.all(Radius.circular(32.0))),
                //   child: Icon(
                //     Icons.pin_drop,
                //     size: 32.0,
                //     color: Colors.black87,
                //   ),
                //   height: 32,
                // ),
                SizedBox(
                  width: 8,
                ),
              ],
            ),
          ),
          Container(
            //margin: EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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
                      //color: Color.fromRGBO(227, 132, 64, 1),
                      border: Border.all(width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0))),
                  child: Text(
                    subJourney["stopTime"] ?? "X2",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        //backgroundColor: Color.fromRGBO(227, 132, 64, 1),
                        color: Colors.black),
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
}
