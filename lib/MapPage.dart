// Page for world map

import 'package:flutter/material.dart';
import 'package:desirth/Reusable.dart' as Reusable;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  var _transformationController = TransformationController();

  @override
  void initState() {
    // used to start the map
    _transformationController =
        TransformationController(Matrix4.identity()..scale(3));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Map of Desirth"),
      ),
      drawer: const Reusable.ReusableDrawer(),
      body: InteractiveViewer(
        alignment: Alignment.topLeft,
        transformationController: _transformationController,
        clipBehavior: Clip.none,
        constrained: false,
        minScale: 0.1,
        maxScale: 6.0,
        child: Image.network(
            "https://media.discordapp.net/attachments/1175796664439689226/1177311124992036884/image.png?ex=65720b6d&is=655f966d&hm=5b43b834cf49de033d8e3b768b40e1546eb44d2bdd9c7ec3cba75191db3a17a3&=&format=webp&width=887&height=671",
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width),
      ),
    );
  }
}
