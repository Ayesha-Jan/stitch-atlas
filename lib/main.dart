import 'package:flutter/material.dart';
import 'package:stitch_atlas/pages/designer.dart';
import 'package:stitch_atlas/pages/grid.dart';
import 'package:stitch_atlas/pages/explorer.dart';
import 'package:stitch_atlas/pages/home.dart';

void main() => runApp(StitchAtlasApp());

class StitchAtlasApp extends StatelessWidget {
  const StitchAtlasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StitchAtlas',
      home: Home(),
      routes: {
        '/designer' :(context) => Designer(),
        '/explorer' :(context) => Explorer(),
        '/home' :(context) => Home(),
      },
    );
  }
}