// page for widgets that are reused in multiple places in the app.

import 'package:flutter/material.dart';

import 'MapPage.dart';
import 'main.dart';

class ReusableDrawer extends StatelessWidget {
  const ReusableDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // ListView is used to create a scrollable list of items in the drawer.
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.inversePrimary),
              child:
                  // Text widget is wrapped in Center widget to center the text vertically and horizontally.
                  Center(
                      child: const Text(
                "Desirth",
                // TextStyle is used to change the font size of the text. Can also change color, font, etc.
                style: const TextStyle(fontSize: 24),
              ))),
          ListTile(
              title: const Text("Home"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LandingPage()));
              }),
          ListTile(title: const Text("Reigons")),
          ListTile(title: const Text("Stories")),
          ListTile(
            title: const Text("Map"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MapPage()));
            },
          ),
          ListTile(title: const Text("About")),
        ],
      ),
    );
  }
}

// D