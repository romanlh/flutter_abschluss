import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abschluss/database_writer.dart';
import 'package:flutter_abschluss/journey/journeyWriter.dart';
import 'package:intl/intl.dart';

import 'journey.dart';
import 'package:flutter_abschluss/global.dart';

import 'journeyStop.dart';

class JourneyStart extends StatefulWidget {
  JourneyStart({Key key}) : super(key: key);
  @override
  _JourneyStartState createState() => _JourneyStartState();
}

class _JourneyStartState extends State<JourneyStart> {
  int ticketNr;
  TextEditingController _start, _linie;
  String _typeSelected = "nothing";
  DatabaseReference _ref;
  DatabaseReference _ticketRef;
  DatabaseReference _refJourney;
  String buttonTitle;
  int sjNumber = Global().sjNumber;
  bool startIsKnown = false;
  @override
  void initState() {
    super.initState();
    var sjNumber = Global().sjNumber;
    _start = TextEditingController(text: Global().lastStop ?? "Hauptbahnhof");
    _linie = TextEditingController(text: "U1");
    _ref = FirebaseDatabase.instance.reference();
    _refJourney = _ref.child("Journeys");
    var isCheckInDone = Global().checkInDone;
    print("isGlobalCheckInDone? = $isCheckInDone");
    if (Global().checkInDone == true) {
      buttonTitle = "Einstieg";
      if (_start.text != "") {
        startIsKnown = true;
      }
    } else {
      buttonTitle = "CheckIn";
    }
    //print("// THIS IS START");
  }

  //FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var ticketNr = Global().ticketNr;
    _ref = FirebaseDatabase.instance.reference();
    _ticketRef = _ref.child("Journeys").child(ticketNr);
    print(ticketNr);
    return Scaffold(
      appBar: AppBar(
        title: Text("Journey #$ticketNr"),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          SizedBox(
            height: 8,
          ),
          Text(
            "Starthaltestelle:",
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(
            height: 8,
          ),
          TextFormField(
            controller: _start,
            autofocus: !startIsKnown,
            //initialValue: "Starthaltestelle",
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Linie:",
            style: TextStyle(fontSize: 18),
          ),
          TextFormField(
            controller: _linie,
            autofocus: startIsKnown,

            //initialValue: "Starthaltestelle",
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildJourneyType2("Bus", Icons.directions_bus_outlined),
              SizedBox(width: 10),
              _buildJourneyType2("Bahn", Icons.subway),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          Container(
            width: double.infinity,
            height: 48,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ElevatedButton(
              child: Text(
                buttonTitle,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 20),
              ),
              onPressed: () {
                // Global().lastLine = _linie.text;

                if (Global().checkInDone == false) {
                  //   print("Will Save CheckIn");
                  String start = _start.text;

                  var outputFormat = DateFormat("HH:mm");
                  var output = outputFormat.format(DateTime.now());

                  // var outputFormat2 = DateFormat("dd/MM/yyyy");
                  // var output2 = outputFormat2.format(DateTime.now());
                  var ticketNr = Global().ticketNr;
                  if (JourneyWriter().mapCheckIn(start, output, ticketNr)) {
                    print("CheckIn um $output erfolgreich übertragen");
                    JourneyWriter().setSubJourneys();
                  } else {
                    print("Unvollständige Informationen hier");
                  }

                  Global().checkInTime = output;
                  //   print("checkInTime = $output");
                  Global().checkInDone = true;
                  Global().lastStartTime = output;
                } else {
                  int sjNumber = Global().sjNumber;
                  //   print("Will Save SubJourney");
                  String start = _start.text;

                  var outputFormat = DateFormat("HH:mm");
                  var output = outputFormat.format(DateTime.now()).toString();

                  //   //var outputFormat2 = DateFormat("dd/MM/yyyy");
                  //   //var output2 = outputFormat2.format(DateTime.now());

                  Global().startTimes.add(output);
                  Global().lastStartTime = output;

                  Map<String, String> subJourneyStart = {
                    "id": "$sjNumber",
                    "start": start,
                    //"time": output,
                    //"date": output2,
                    "transportType": "$_typeSelected"
                  };

                  JourneyWriter().addSubJourney(subJourneyStart, sjNumber);

                  //   _refJourney
                  //       .child("$ticketNr")
                  //       .child("subJourneys")
                  //       .child("$sjNumber")
                  //       .set(subJourneyStart)
                  //       .then((value) => ((value) {
                  //             print("checkIn = $value");
                  //           }));
                }

                Global().lastStart = _start.text;
                Global().lastLine = _linie.text;

                // String lastStart = Global().lastStart;
                // print("Last start is $lastStart");

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => JourneyStop()),
                );
              },
            ),
          )
        ]),
      ),
    );
  }

  Widget _buildJourneyType2(String title, IconData icon) {
    //print("Will return Inkwell");
    return InkWell(
      child: Container(
        height: 48,
        width: 136,
        decoration: BoxDecoration(
            color: this._typeSelected == title
                ? Color.fromRGBO(227, 132, 64, 1)
                : Colors.black26,
            borderRadius: BorderRadius.circular(1000.0),
            border: Border.all(width: 3, color: Colors.black54)),
        child: Center(
          child: Icon(
            icon,
            color: Colors.white,
            size: 32.0,
          ),
        ),
      ),
      onTap: () {
        setState(() {
          this._typeSelected = title;
          Global().quickTransportType = this._typeSelected;
          print("Selected Type -> $_typeSelected");
        });
      },
    );
  }
}
