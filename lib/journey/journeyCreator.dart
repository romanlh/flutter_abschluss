import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abschluss/database_writer.dart';
import 'package:flutter_abschluss/global.dart';
import 'package:flutter_abschluss/journey/journey.dart';
import 'package:flutter_abschluss/journey/journeyStart.dart';
import 'package:flutter_abschluss/journey/journeyWriter.dart';
//import 'package:flutter_abschluss/database_writer.dart';
import 'package:provider/provider.dart';
import '../global.dart';
import 'package:intl/intl.dart';

//TODO: bei textfeldern nicht mehr onChanged sondern onEditingComplete: () {},
//TODO: Ticket Nr bei Button oder Firebase string

class JourneyCreator extends StatefulWidget {
  JourneyCreator({Key key}) : super(key: key);

  @override
  _JournyInspector createState() => _JournyInspector();
}

class _JournyInspector extends State<JourneyCreator> {
  int ticketNr;
  TextEditingController _nameController, _numberController, _locationController;
  String _typeSelected = "";
  DatabaseReference _ref;
  DatabaseReference _refJourney;
  DatabaseReference _refVersion;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    super.initState();
    // print("journeyCreator");
    _nameController = TextEditingController(text: returnUserNameIfGiven());
    _numberController = TextEditingController(text: getVersionNumber());
    _locationController = TextEditingController(text: returnLocation());
    _ref = FirebaseDatabase.instance.reference();
    _refJourney = _ref.child("Journeys");
    _refVersion = _ref.child("Rules").child("versionnumber");
  }

  returnUserNameIfGiven() {
    print("Returning User name if given ...");
    final firebaseUser = auth.currentUser;
    if (firebaseUser != null) {
      return firebaseUser.displayName ?? firebaseUser.email;
    } else {
      return Text("Name");
    }
  }

  returnVersionnumber() async {
    String result;
    await _refVersion.once().then((snapshot) {
      result = snapshot.value.toString();
    });

    if (result != null) {
      return "$result";
    } else {
      return "Version";
    }
  }

  returnLocation() {
    return "Hamburg";
  }

//Vielleicht zu verwenden um Prod, Staging Dev anzugeben?
  Widget _buildJourneyType(String title) {
    return InkWell(
      child: Container(
        height: 48,
        width: 108,
        decoration: BoxDecoration(
          color:
              this._typeSelected == title ? Global().secondary : Colors.black26,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        setState(() {
          getTicketNr();
          this._typeSelected = title;
        });
      },
    );
  }

  returnLocationIfGiven() async {
    final locRef = FirebaseDatabase.instance
        .reference()
        .child("Users")
        .child(auth.currentUser.displayName)
        .child("location")
        .key;

    if (locRef != "") {
      print("locRef -> $locRef");
    } else {
      print("locRef = " "");
    }
  }

  getVersionNumber() {
    print("Searching for the Versionnumber in $_refVersion");

    if (_refVersion != null) {
      var versionnumber = _refVersion.key;

      if (versionnumber != null) {
        print("Creator -> $versionnumber");
        return versionnumber;
      }
    } else {
      print("Versionnumber is = null");
    }

    return "1.0.0";
  }

  @override
  Widget build(BuildContext context) {
    //print("Will return Scaffold()");
    return Scaffold(
      //backgroundColor: Color.fromRGBO(13, 167, 216, 1),
      appBar: AppBar(title: Text("New Journey")),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: this._nameController,
              decoration: InputDecoration(
                  //hintText: returnUserNameIfGiven(),
                  prefixIcon: Icon(
                    Icons.account_circle,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: EdgeInsets.all(15)),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: this._numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.wysiwyg,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true),
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: this._locationController,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.gps_fixed,
                    size: 30,
                  ),
                  fillColor: Colors.white,
                  filled: true),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildJourneyType("Prod"),
                SizedBox(width: 8),
                _buildJourneyType("Staging"),
                SizedBox(width: 8),
                _buildJourneyType("Dev"),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Container(
              width: double.infinity,
              height: 48,
              //padding: EdgeInsets.symmetric(horizontal: 10),
              child: ElevatedButton(
                child: Text(
                  "Start Journey",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20),
                ),
                onPressed: () {
                  updateUsername();
                  //saveJourney(ticketNr);

                  Journey(jid: "$ticketNr");
                  Global().ticketNr = "$ticketNr";
                  Global().checkInDone = false;
                  Global().sjNumber = 0;

                  print("TicketNr = $ticketNr");

                  JourneyWriter().setJourney("$ticketNr");

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JourneyStart()),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  getTicketNr() async {
    await FirebaseDatabase.instance
        .reference()
        .child("JourneyNr")
        //.child("ticketNr")
        .once()
        .then((DataSnapshot snapshot) {
      var value = snapshot.value;
      print("snapshot.value = $value");
      _ref.child("JourneyNr").set(snapshot.value + 1);
      //var ticketNrString = snapshot.value;
      ticketNr = snapshot.value;
    });
  }

  void updateDisplayNameIfGiven() {
    if (_nameController.text != auth.currentUser.email) {
      //Hier muss noch etwas hin das überprüft ob es den Namen schon gibt
      auth.currentUser.updateProfile(displayName: this._nameController.text);
      print("Updated Displayname");
    }
  }

  void updateUsername() {
    String text = _nameController.text.trim();
    if (_nameController.text != auth.currentUser.email) {
      //Hier muss noch etwas hin das überprüft ob es den Namen schon gibt
      auth.currentUser.updateProfile(displayName: text);
      print("Updated Displayname to $text");
    }
  }

  void saveJourney(int ticketNr) {
    print("Will Save Journey");
    String name = auth.currentUser.displayName ?? auth.currentUser.email;
    String number = this._numberController.text;

    var outputFormat = DateFormat("HH:mm");
    var output = outputFormat.format(DateTime.now());

    var outputFormat2 = DateFormat("dd/MM/yyyy");
    var output2 = outputFormat2.format(DateTime.now());

    Map<String, String> journey = {
      "id": "$ticketNr",
      "name": name,
      "startTime": output,
      "date": output2,
      "number": number,
      "type": this._typeSelected,
      "location": this._locationController.text,
      "checkIn":
          "noch nicht eingecheckt" //Vielleicht lasse ich die Location immer über die vom User hinterlegte Location anzeigen
    };

    _refJourney.child("$ticketNr").update(journey).then((value) => ((value) {
          print("value = $value");
        }));
  }
}
