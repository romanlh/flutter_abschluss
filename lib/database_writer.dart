import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatabaseWriter {
  //DatabaseReference _ref = FirebaseDatabase.instance.reference();
  DatabaseReference _refJourney =
      FirebaseDatabase.instance.reference().child("Journeys");

  String id;
  String name;
  String nummer;
  String type;
  String standort;
  String zeit = DateTime.now().toString();

  String returnId() {
    return id;
  }

  void data1(
      String id, String name, String nummer, String typ, String standort) {
    id = id;
    name = name;
    print("Habe Name gesetzt auf $name");
    nummer = nummer;
    print("Habe Nummer gesetzt auf $nummer");
    typ = type;
    print("Habe Typ gesetzt auf $type");
    standort = standort;
    print("Habe Standort gesetzt auf $standort");
    createJourney();
  }

  void createJourney() async {
    var outputFormat = DateFormat("HH:mm");
    var output = outputFormat.format(DateTime.now());

    var outputFormat2 = DateFormat("dd/MM/yyyy");
    var output2 = outputFormat2.format(DateTime.now());
    Map<String, String> journey = {
      "name": name,
      "time": output,
      //"date": output2,
      "number": nummer,
      "type": type,
      "location": standort
    };

    _refJourney.child(id).set(journey).then((value) => ((value) {
          print("value = $value");
        }));
    print("DatabaseWriter Journey -> $journey");
  }
}
