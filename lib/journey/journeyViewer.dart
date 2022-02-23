import 'package:flutter/material.dart';

import '../global.dart';

class JourneyViewer extends StatefulWidget {
  @override
  _JourneyViewerState createState() => _JourneyViewerState();
}

class _JourneyViewerState extends State<JourneyViewer> {
  void schowList(String ticketNr) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Zusammenfassung"),
      ),
      body: Column(
        children: [
          Container(height: double.infinity, child: Global().returnFAL())
        ],
      ),
    );
  }
}
