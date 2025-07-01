import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "S T I T C H   A T L A S",
          style: TextStyle(
            fontSize: 28,
            color: Color(0xFFEA467E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFDCE7FB),
      ),
      body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/background.png"),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDCE7FB),
                    foregroundColor: Color(0xFFEA467E),
                    padding: EdgeInsets.symmetric(
                      vertical: 24,
                      horizontal: 30
                    ),
                    minimumSize: Size(200, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: Color(0xFFEA467E),
                        width: 2
                      )
                    )
                  ),
                  child: Text(
                    "Go to Designer Page",
                    style: TextStyle(fontSize: 35),
                  ),
                ),
                SizedBox(height: 200),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/explorer');
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDCE7FB),
                      foregroundColor: Color(0xFFEA467E),
                      padding: EdgeInsets.symmetric(
                          vertical: 24,
                          horizontal: 30
                      ),
                      minimumSize: Size(200, 70),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(
                              color: Color(0xFFEA467E),
                              width: 2
                          )
                      )
                  ),
                  child: Text(
                    "Go to Explorer Page",
                    style: TextStyle(fontSize: 35),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

