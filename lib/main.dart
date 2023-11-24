import 'package:flutter/material.dart';
import 'package:desirth/Reusable.dart' as Reusable;

void main() {
  runApp(const DesirthApp());
}

class DesirthApp extends StatelessWidget {
  const DesirthApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Sets background color of the AppBar using the colorScheme described in the app widget.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,

          title: const Text("Welcome to Desirth"),
        ),
        // Reusable Drawer is defined in ./lib/Reusables.dart
        drawer: const Reusable.ReusableDrawer(),
        body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
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
        ));
  }
}
