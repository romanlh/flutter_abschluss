import '../global.dart';

class JourneyReader {
  showDataBase() {
    var ref = Global().reference.child("Journeys");
    print("!!! Reader -> $ref");
  }
}
