import 'package:flutter/material.dart';
import 'package:desirth/Reusable.dart' as Reusable;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

const FirebaseOptions options = FirebaseOptions(
    apiKey: "AIzaSyCRXOHoWZ1QY-oxBvkBT5L58NU0GwKcndY",
    authDomain: "desirth-app.firebaseapp.com",
    projectId: "desirth-app",
    storageBucket: "desirth-app.appspot.com",
    messagingSenderId: "340486672266",
    appId: "1:340486672266:web:737d0edc359eaca778c273");

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(options: options);
  runApp(const DesirthApp());
}

class DesirthApp extends StatelessWidget {
  const DesirthApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desirth Universe',
      theme: ThemeData(
        // This is the theme of your application.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              // Sets background color of the AppBar using the colorScheme described in the app widget.
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,

              title: const Text("Welcome to Desirth"),
            ),
            // Reusable Drawer is defined in ./lib/Reusables.dart
            drawer: const Reusable.ReusableDrawer(),
            body: Center(
              child: ListView(
                children: [
                  const ListTile(
                    titleAlignment: ListTileTitleAlignment.center,
                    title: const Center(
                      child: const Text("Welcome to Desirth",
                          style: const TextStyle(fontSize: 24)),
                    ),
                    subtitle:
                        const Center(child: const Text("by Supernal Studios")),
                  ),
                ],
              ),
              // This trailing comma makes auto-formatting nicer for build methods.
            )));
  }
}
