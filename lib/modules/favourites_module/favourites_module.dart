import 'package:flutter/material.dart';

class FavoruitesScreen extends StatefulWidget {
  const FavoruitesScreen({Key? key}) : super(key: key);

  @override
  State<FavoruitesScreen> createState() => _FavoruitesScreenState();
}

class _FavoruitesScreenState extends State<FavoruitesScreen> {
  @override
  Widget build(BuildContext context) {
    return  Container(
        child: Center(
          child: Text('favoruites screen'),
        ),
      );
  }
}