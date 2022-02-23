import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_abschluss/journey/journeyCreator.dart';
import 'package:flutter_abschluss/user_screen.dart';
import 'package:provider/provider.dart';

import 'NEW/JourneyListScreen.dart';
import 'authentication_service.dart';
import 'global.dart';
import 'sign_in_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //JourneyReader().showDataBase();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        // ignore: missing_required_param
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: 'Test App',
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF0DA7D8, color), // <- colorCustom
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(),
      ),
    );
  }
}

//Wird als erstes angesprochen
class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    if (firebaseUser != null) {
      print("Firebase User: $firebaseUser");
      saveUser(context);
      print("context = $context");
      return MyHomePage();
    }
    return SignInPage();
  }
}

void saveUser(BuildContext context) {
  final firebaseUser = context.watch<User>();
  String name = firebaseUser.displayName ?? "Not Given";
  String mail = firebaseUser.email;
  String id = firebaseUser.uid;

  Map<String, String> user = {"name": name, "mail": mail, "location": ""};

  //PURE GOLD
  Global().userRef.child(id).set(user).then((value) => ((value) {
        print("value = $value");
      }));
  print("main.dart knows this about the user -> $user");
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 1; //<- Start wählen

  List bottomBarIcons = [
    Icon(Icons.add_circle_outline),
    Icon(Icons.map),
    Icon(Icons.person)
  ];

  List<Widget> myWidgets = [
    JourneyCreator(),
    JourneyListScreen() /*Journeys()*/,
    UserScreen()
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      body: myWidgets[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: Color.fromRGBO(16, 167, 216, 1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white30,
        showUnselectedLabels: true,
        iconSize: 30,
        onTap: (value) {
          setState(() => _currentIndex = value);
        },
        items: [
          BottomNavigationBarItem(
            label: "New",
            icon: bottomBarIcons[0],
          ),
          BottomNavigationBarItem(
            label: "Journeys",
            icon: bottomBarIcons[1],
          ),
          BottomNavigationBarItem(
            label: "Profile",
            icon: bottomBarIcons[2],
          ),
        ],
      ),
    );
  }
}

const defaultLetterSpacing = 0.03;

Map<int, Color> color = {
  50: Color.fromRGBO(13, 167, 216, .1),
  100: Color.fromRGBO(13, 167, 216, .2),
  200: Color.fromRGBO(13, 167, 216, .3),
  300: Color.fromRGBO(13, 167, 216, .4),
  400: Color.fromRGBO(13, 167, 216, .5),
  500: Color.fromRGBO(13, 167, 216, .6),
  600: Color.fromRGBO(13, 167, 216, .7),
  700: Color.fromRGBO(13, 167, 216, .8),
  800: Color.fromRGBO(13, 167, 216, .9),
  900: Color.fromRGBO(13, 167, 216, 1),
};
