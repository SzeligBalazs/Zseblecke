import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zseblecke/Widgets/Home.dart';
import 'package:zseblecke/Widgets/NewNote.dart';
import 'package:zseblecke/Widgets/Search.dart';
import 'package:zseblecke/Widgets/Settings.dart';
import 'package:zseblecke/Widgets/WelcomeScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  setupState = prefs.getBool("setupState");
  print(setupState);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(ZsebleckeApp()));
  runApp(const ZsebleckeApp());
}

bool? setupState;

Color primaryColor = Colors.blueAccent;

class ZsebleckeApp extends StatelessWidget {
  const ZsebleckeApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zseblecke',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: primaryColor,
        accentColor: primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: setupState == true ? '/home' : '/welcome',
      routes: {
        '/welcome': (context) => WelcomeScreen(),
        '/home': (context) => HomePage(),
        '/newNote': (context) => NewNote(),
        '/settings': (context) => SettingsScreen(),
        '/search': (context) => SearchForTasks(),
      },
      debugShowCheckedModeBanner: false,
      home: setupState == true ? HomePage() : WelcomeScreen(),
    );
  }
}
