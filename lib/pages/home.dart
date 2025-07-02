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
      drawer: Drawer(
        backgroundColor: Color(0xFFDCE7FB),
        child: Column(
          children: [
            DrawerHeader(
                child: Icon(
                  Icons.favorite,
                  size: 48,
                )
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text("H O M E"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: Icon(Icons.design_services),
              title: Text("D E S I G N E R"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/designer');
              },
            ),
            ListTile(
              leading: Icon(Icons.explore),
              title: Text("E X P L O R E R"),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/explorer');
              },
            ),
          ],
        ),
      ),
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
          SizedBox(height: 20),
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

                SizedBox(height: 40),
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
                SizedBox(height: 40),

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
                SizedBox(height: 30),
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

