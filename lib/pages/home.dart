import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stitch Atlas"),
        centerTitle: true,
        backgroundColor: Color(0xFFDCE7FB),
      ),
      body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
              image: DecorationImage(
              image: AssetImage("assets/background.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
    // Foreground content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/designer');
                    },
                    child: Text("Go to Designer Page"),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/explorer');
                    },
                    child: Text("Go to Explorer Page"),
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }
}

