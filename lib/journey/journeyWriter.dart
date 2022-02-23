/*
1.
IST: Journeys werden nach und nach aktualisiert
SOLL: Eine Journey soll am Ende einmalig mit allen Daten abgesendet werden

2.
IST: Eine Journey ist am Ende einmalig mit allen Daten abgesendet werden
SOLL: Es gibt Referenzen mit den gezielt pfade aktualisiert werden können
*/

import 'package:firebase_database/firebase_database.dart';

import '../global.dart';

class JourneyWriter {
  DatabaseReference _refJourney =
      FirebaseDatabase().reference().child("Journeys");
  //var ticketNr = Global().ticketNr;

  Map<String, String> journey = {};
  Map<String, String> checkIn = {};
  Map<String, String> checkOut = {};

  setJourney(String ticketNr) {
    print("Will create Ticket $ticketNr");

    _refJourney
        .child(ticketNr)
        .set("Checking In ...")
        .then((value) => ((value) {
              print("Created Ticket Nr $ticketNr");
            }));
  }

  setSubJourneys() {
    var ticketNr = Global().ticketNr;
    _refJourney
        .child(ticketNr)
        .update({"SubJourneys": "0"}).then((value) => ((value) {
              print("Created Ticket Nr $ticketNr");
            }));
  }

  addSubJourney(Map<String, String> subJourney, sjNumber) {
    _refJourney
        .child(Global().ticketNr)
        .child("SubJourneys")
        .child("$sjNumber")
        .update(subJourney)
        .then((value) => ((value) {
              print("subJourney = $value");
            }));
  }

  bool completeJourney(String ticketNr) {
    if (checkIn != {} && checkOut != {}) {
      journey.addAll(checkIn);
      journey.addAll(checkOut);

      _refJourney
          .child("$ticketNr")
          .child("JourneyV2")
          .update(journey)
          .then((value) => ((value) {
                print("checkIn = $value");
              }));
      return true;
    } else {
      print("checkIn != {} oder checkOut != {} == {}");
      return false;
    }
  }

  /*
  Hier soll eine Funktion entstehen, welche die Werte für die CheckIn
  annehmen soll. Im Falle das Daten Fehlen soll eine Fehlermeldung
  zurückgegeben werden.
  */

  bool mapCheckIn(String start, String output, String ticketNr) {
    if (start != "" && output != "") {
      checkIn = {
        "start": start,
        "time": output,
      };
      _refJourney
          .child(ticketNr)
          .child("CheckIn")
          .update(checkIn)
          .then((value) => ((value) {
                print("Created Ticket Nr $ticketNr");
              }));
      return true;
    } else {
      return false;
    }
  }

  bool mapCheckOut(String stop, String output) {
    if (stop != "" && output != "") {
      checkOut = {
        "destination": stop,
        "time": output,
      };
      return true;
    } else {
      return false;
    }
  }

  bool subJourneys() {}
  bool userInfomration() {}
}
