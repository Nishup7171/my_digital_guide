import 'package:flutter/material.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      appBar: AppBar(
        title: const Text("Map of the Museum"),
        backgroundColor: Colors.blue[300],
        automaticallyImplyLeading: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Image.asset("assets/images/sitemap.png", fit: BoxFit.contain,),
      ),
    );
  }
}
