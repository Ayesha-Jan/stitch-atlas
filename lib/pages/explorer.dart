import 'package:flutter/material.dart';

class Explorer extends StatelessWidget {
  const Explorer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Explorer"),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[100],
      ),
    );
  }
}
