import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFFDCE7FB),
      child: Column(
        children: [
          DrawerHeader(
            child: Image.asset(
              'assets/images/designs/crochet.png',
              fit: BoxFit.contain,
            ),
          ),
          _buildTile(context, Icons.home, "H O M E", '/home'),
          _buildTile(context, Icons.design_services, "D E S I G N E R", '/designer'),
          _buildTile(context, Icons.explore, "E X P L O R E R", '/explorer'),
        ],
      ),
    );
  }

  Widget _buildTile(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, size: 20, color: Color(0xFFEA467E)),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          color: Color(0xFFEA467E),
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
