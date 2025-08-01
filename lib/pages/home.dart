import 'package:flutter/material.dart';
import 'drawer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "S T I T C H   A T L A S",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFFEA467E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFDCE7FB),
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/designs/background.png"),
              fit: BoxFit.cover,
              ),
            ),
          ),
          Image.asset(
            'assets/images/designs/yarn.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),

          // Foreground content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 25),
                Image.asset(
                  'assets/images/designs/string.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/designer');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDCE7FB),
                    foregroundColor: Color(0xFFEA467E),
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
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
                    "Go to Designer",
                    style: TextStyle(fontSize: 30),
                  ),
                ),

                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/designs/crochet.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        'assets/images/designs/knit.png',
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/explorer');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDCE7FB),
                    foregroundColor: Color(0xFFEA467E),
                    padding: EdgeInsets.symmetric(
                        vertical: 16,
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
                    "Go to Explorer",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                SizedBox(height: 25),
                Image.asset(
                  'assets/images/designs/string_flipped.png',
                  width: double.infinity,
                  fit: BoxFit.fitWidth,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

