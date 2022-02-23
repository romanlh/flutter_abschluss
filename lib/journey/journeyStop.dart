import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abschluss/journey/journeyWriter.dart';
import 'package:intl/intl.dart';

import '../global.dart';
import 'journeyCompleter.dart';

class JourneyStop extends StatefulWidget {
  @override
  _JourneyStopState createState() => _JourneyStopState();
}

class _JourneyStopState extends State<JourneyStop> {
  int ticketNr;
  TextEditingController _ziel;
  DatabaseReference _ref;
  DatabaseReference _ticketRef;
  int sjNumber = Global().sjNumber;
  DatabaseReference _refJourney;
  String text = "CheckIn";
  @override
  void initState() {
    super.initState();
    _ziel = TextEditingController(text: "Lübecker Straße");
    _ref = FirebaseDatabase.instance.reference();
    _refJourney = _ref.child("Journeys");
    if (Global().checkInDone == true) {
      int i = Global().sjNumber + 1;
      text = "Sub Journey #$i";
    }
  }

  @override
  Widget build(BuildContext context) {
    var ticketNr = Global().ticketNr;
    return Scaffold(
      appBar: AppBar(
        title: Text("Journey #$ticketNr"),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Zielhaltestelle:",
              style: TextStyle(fontSize: 18),
            ),
            TextFormField(
              controller: _ziel,
              autofocus: true,
            ),
            SizedBox(
              height: 16,
            ),
            Text(
              "Anmerkungen zum $text:",
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              maxLines: 3,
              maxLength: 100,
            ),
            SizedBox(
              height: 22,
            ),
            Text(
              "Mit Fahrt starten wird der Ankunftszeitpunkt gesetzt",
              style: TextStyle(fontSize: 12, color: Colors.black45),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              width: double.infinity,
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                child: Text(
                  "Fahrt starten",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                onPressed: () {
                  Global().lastStop = _ziel.text;
                  String start = Global().lastStart;
                  String destination = this._ziel.text;
                  String line = Global().lastLine;
                  int sjNumber = Global().sjNumber;

                  var outputFormat = DateFormat("HH:mm");
                  var output = outputFormat.format(DateTime.now());

                  var outputFormat2 = DateFormat("dd/MM/yyyy");
                  var output2 = outputFormat2.format(DateTime.now());

                  Map<String, String> subJourney = {
                    "start": start,
                    "startTime": output,
                    "destination": destination,
                    "line": line,
                    "transportType": Global().quickTransportType
                  };

                  JourneyWriter().addSubJourney(subJourney, sjNumber);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JourneyCompleter()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
