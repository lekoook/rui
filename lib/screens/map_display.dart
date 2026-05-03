import 'package:flutter/material.dart';

class MapDisplay extends StatefulWidget {
  const MapDisplay({super.key});

  @override
  State<StatefulWidget> createState() => _MapDisplayState();
}

class _MapDisplayState extends State<MapDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey,
      child: Text('Map goes here'),
    );
  }
}
