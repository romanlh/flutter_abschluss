import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abschluss/journey/journeyStart.dart';
import 'package:flutter_abschluss/journey/journeyWriter.dart';
import 'package:intl/intl.dart';

import '../global.dart';
import 'journeyFinal.dart';

class JourneyCompleter extends StatefulWidget {
  @override
  _JourneyCompleterState createState() => _JourneyCompleterState();
}

class _JourneyCompleterState extends State<JourneyCompleter> {
  DatabaseReference _ref = FirebaseDatabase.instance.reference();
  String startTime;
  String lastLine;
  IconData transportTypeIconData;

  void initState() {
    super.initState();
    print("journeyCompleter");
    Global().editMode = false;
    _refJourney = _ref.child("Journeys");
    print("Completer -> $_refJourney"); // !!!!

    startTime = Global().lastStartTime;
    print("Completer -> $startTime");
    //Global().getCheckInTime();
    var transportType = Global().quickTransportType;

    if (transportType == "Bus") {
      transportTypeIconData = Icons.directions_bus;
    }

    if (transportType == "Bahn") {
      transportTypeIconData = Icons.train;
    }

    lastLine = Global().lastLine;
    print("Global().lastLine = $lastLine");
  }

  int sjNumber = Global().sjNumber;
  DatabaseReference _refJourney;

  @override
  Widget build(BuildContext context) {
    var ticketNr = Global().ticketNr;
    return Scaffold(
      appBar: AppBar(
        title: Text("Journey #$ticketNr"),
      ),
      body: Container(
        //margin: EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: 18,
            ),
            Container(
              margin: EdgeInsets.all(14),
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
                      "$startTime" ?? "Error",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  //Spacer(),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(Global().lastStart ?? "Error"),
                  Spacer(),
                  Container(
                    child: Icon(
                      transportTypeIconData,
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
              margin: EdgeInsets.all(14),
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
                      lastLine ?? "Error",
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
                  Text(Global().lastStop),
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
              height: 18 / 2,
            ),
            Container(
              width: double.infinity,
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                child: Text(
                  "Zwischenstop",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                onPressed: () {
                  saveStopTime(Global().ticketNr);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JourneyStart()),
                  );
                },
              ),
            ),
            SizedBox(
              height: 18.0,
            ),
            Container(
              width: double.infinity,
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                style: ButtonStyle(),
                child: Text(
                  "Zum Checkout",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                onPressed: () {
                  saveStopTime(Global().ticketNr);
                  JourneyWriter().completeJourney(Global().ticketNr);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JourneyFinal()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveStopTime(String ticketNr) {
    var outputFormat = DateFormat("HH:mm");
    var output = outputFormat.format(DateTime.now());

    var outputFormat2 = DateFormat("dd/MM/yyyy");
    var output2 = outputFormat2.format(DateTime.now());
    Map<String, String> stopTime = {
      "stopTime": output,
    };

    JourneyWriter().addSubJourney(stopTime, sjNumber);

    Global().sjNumber = Global().sjNumber + 1;
    int sjNumberInfo = Global().sjNumber;
    print("SJ NUMBER: $sjNumberInfo");
  }
}
