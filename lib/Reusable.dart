// page for widgets that are reused in multiple places in the app.

// flutter
import 'dart:io';

import 'package:flutter/material.dart';

// navigatable pages
import 'MapPage.dart';
import 'main.dart';
import 'Manage.dart';

// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:google_sign_in_web/google_sign_in_web.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// taken from https://firebase.flutter.dev/docs/auth/social
Future<UserCredential> signInWithGoogle() async {
  // Create a new provider
  GoogleAuthProvider googleProvider = GoogleAuthProvider();

  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);

  // Or use signInWithRedirect
  // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
}

class ReusableDrawer extends StatefulWidget {
  const ReusableDrawer({super.key});

  @override
  State<ReusableDrawer> createState() => _ReusableDrawerState();
}

class _ReusableDrawerState extends State<ReusableDrawer> {
  // save login status as a static variable so it can be saved when the drawer is rebuilt
  static bool _isLoggedIn = false;
  static bool _isWriter = false;
  static User? _user;
  static bool _isAdmin = false;

  Text loginStatus(bool isLoggedIn, User? user) {
    if (isLoggedIn) {
      return Text("Logged in as ${user!.displayName}");
    } else {
      return Text("Not logged in");
    }
  }

  Widget loginIcon(bool isLoggedIn, User? user) {
    if (isLoggedIn) {
      return Image.network(
        user!.photoURL!,
        scale: 0.5,
      );
    } else {
      return Icon(Icons.login);
    }
  }

  List<ListTile> authedDrawerItems(bool isWriter, bool isAdmin) {
    List<ListTile> items = [];
    if (isLoggedIn) {
      if (isWriter) {
        items.add(ListTile(title: const Text("Upload")));
      }
      if (isAdmin) {
        items.add(ListTile(
            title: const Text("Manage"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ManagePage()));
            }));
      }
      items.add(ListTile(
          title: const Text("Logout"),
          onTap: () {
            FirebaseAuth.instance.signOut().then((value) {
              setState(() {
                _isLoggedIn = false;
                _isWriter = false;
                _isAdmin = false;
              });
            });
          }));
    }
    return items;
  }

  getUserFireStore(User user) async {
    // TODO: check if the user is in cookies / local storage

    // get the user from the firestore
    // if the user doesn't exist, create it
    // if the user does exist, return it
    // if the user is an admin, set the isAdmin flag to true
    // if the user is a writer, set the isWriter flag to true
    // if the user is neither, set both flags to false
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc =
        await firestore.collection("users").doc(user.uid).get();
    if (userDoc.exists) {
      // TODO: add the user to the cookies / local storage

      return userDoc;
    } else {
      firestore.collection("users").doc(user.uid).set({
        "name": user.displayName,
        "email": user.email,
        "isAdmin": false,
        "isWriter": false,
      });
      return userDoc;
    }
  }

  getUser() {
    return _user;
  }

  get isLoggedIn {
    return _isLoggedIn;
  }

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
                  const Center(
                      child: Text(
                "Desirth",
                // TextStyle is used to change the font size of the text. Can also change color, font, etc.
                style: TextStyle(fontSize: 24),
              ))),
          ListTile(
              title: const Text("Home"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LandingPage()));
              }),
          ListTile(title: const Text("Regions")),
          ListTile(title: const Text("Stories")),
          ListTile(
            title: const Text("Map"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MapPage()));
            },
          ),
          ListTile(title: const Text("About")),
          Text("For Writers", textAlign: TextAlign.center),
          ListTile(
              leading: loginIcon(_isLoggedIn, _user),
              title: loginStatus(_isLoggedIn, _user),
              onTap: () {
                if (isLoggedIn) {
                  return;
                }
                signInWithGoogle().then((value) {
                  setState(() {
                    _isLoggedIn = true;
                    _user = value.user;
                    getUserFireStore(_user!).then((value) {
                      // print(value.user!.uid);
                      setState(() {
                        _isWriter = value["isWriter"];
                        _isAdmin = value["isAdmin"];
                      });
                    });
                  });
                });
              }),
          ...authedDrawerItems(_isWriter, _isAdmin),
        ],
      ),
    );
  }
}


// D