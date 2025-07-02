import 'package:flutter/material.dart';

class Explorer extends StatelessWidget {
  const Explorer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "E X P L O R E R",
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
      body: Container(
        color: Color(0xFFFDDBE6),
      ),
    );
  }
}
