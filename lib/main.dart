import 'package:flutter/material.dart';
import 'screens/robot_dashboard.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        child: RobotMainView(),
      ),
    );
  }
}
