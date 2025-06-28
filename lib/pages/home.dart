import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stitch Atlas"),
        centerTitle: true,
        backgroundColor: Colors.pinkAccent[100],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/designer');
              },
              child: Text("Go to Designer Page")
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/explorer');
              },
              child: Text("Go to Explorer Page"),
          ),
        ],
      )
    );
  }
}
