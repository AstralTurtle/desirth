// Page for world map

import 'package:flutter/material.dart';
import 'package:desirth/Reusable.dart' as Reusable;
import 'dart:math';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final scaleMatrix = Matrix4.identity()..scale(3);
  var _transformationController = TransformationController();
  // values taken from print statement
  final double initZoomValue = 2.1104847801578352;
  final double initX = 3.426805506023811e-10;
  final double initY = 9.19346376804242e-10;

  //  https://stackoverflow.com/questions/70424394/how-to-set-interactiveviewer-initial-zoom-level

  @override
  // void initState() {
  //   // used to start the map
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final screenWidth = MediaQuery.of(context).size.width;
  //     final screenHeight = MediaQuery.of(context).size.height + 56;
  //     final imageWidth = 808;
  //     final imageHeight = 1068;
  //     final zoomFactor =
  //         max(screenHeight / imageHeight, screenWidth / imageWidth);
  //     print(zoomFactor);
  //     final xTranslate = (screenWidth / 2) * (zoomFactor - 1);
  //     final yTranslate = (screenHeight / 2) * (zoomFactor - 1);
  //     _transformationController.value.setEntry(0, 0, zoomFactor);
  //     _transformationController.value.setEntry(1, 1, zoomFactor);
  //     _transformationController.value.setEntry(2, 2, zoomFactor);
  //     _transformationController.value.setEntry(0, 3, -xTranslate);
  //     _transformationController.value.setEntry(1, 3, -yTranslate);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    // SafeArea is used to make sure the app doesn't go into the status bar.
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Map of Desirth"),
      ),
      drawer: const Reusable.ReusableDrawer(),
      body: InteractiveViewer(
        alignment: Alignment.topLeft,
        transformationController: _transformationController,
        clipBehavior: Clip.hardEdge,
        constrained: false,
        minScale: 0.001,
        maxScale: 10.0,
        // make a container the size of the screen and put the image in it
        // this is to ensure the image is centered and fits in the inital zoom
        child: Container(
          color: Colors.black,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.network(
              "https://media.discordapp.net/attachments/1175796664439689226/1177311124992036884/image.png?ex=65720b6d&is=655f966d&hm=5b43b834cf49de033d8e3b768b40e1546eb44d2bdd9c7ec3cba75191db3a17a3&=&format=webp&width=887&height=671",
              fit: BoxFit.scaleDown),
        ),
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () {
      //   print(_transformationController.value);
      // }),
    ));
  }
}
