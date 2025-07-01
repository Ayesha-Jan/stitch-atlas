import 'package:flutter/material.dart';
import 'designer.dart';

class Grid extends StatefulWidget {
  final int gridWidth;
  final int gridHeight;
  final Mode mode;

  const Grid({super.key,
    required this.gridWidth,
    required this.gridHeight,
    required this.mode,
  });

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {
  late List<List<String>> grid;
  late Mode selectedMode;

  @override
  void initState() {
    super.initState();
    selectedMode = widget.mode;
    grid = List.generate(widget.gridHeight, (_) => List.filled(widget.gridWidth, ""));
    // Initialize other variables...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Designer")),
      body: Column(
        children: [
          // Grid rendering here
          // Zoom slider
          // Undo/Redo buttons
          // Stitch/Color dropdowns
        ],
      ),
    );
  }
}
