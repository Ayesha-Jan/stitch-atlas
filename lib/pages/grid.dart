import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'drawer.dart';
import 'mode.dart';

import 'package:flutter/services.dart';
import 'dart:ui' as ui;

class Grid extends StatefulWidget {
  final Mode selectedMode;
  final int gridWidth;
  final int gridHeight;

  const Grid({
    super.key,
    required this.selectedMode,
    required this.gridWidth,
    required this.gridHeight,
  });

  @override
  State<Grid> createState() => _GridState();
}

class _GridState extends State<Grid> {

  final GlobalKey _gridKey = GlobalKey();
  final TransformationController _transformationController = TransformationController();

  int generatedWidth = 8;
  int generatedHeight = 8;

  bool gridGenerated = false;

  List<List<String>> grid = [];
  String selectedSymbol = "no stitch";

  final List<List<List<String>>> _undoStack = [];
  final List<List<List<String>>> _redoStack = [];

  Color selectedColor = Colors.blue[100]!;
  List<Color> recentColors = [Colors.blue[100]!];

  // Converts a Color to a hex string like "#RRGGBB"
  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  // Converts a hex string like "#RRGGBB" to a Color
  Color hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  final List<Map<String, String>> crochetSymbols = [
    {"name": "chain", "file": "assets/crochet_symbols/ch.svg"},
    {"name": "slip stitch", "file": "assets/crochet_symbols/slst.svg"},
    {"name": "single crochet", "file": "assets/crochet_symbols/sc.svg"},
    {"name": "half double crochet", "file": "assets/crochet_symbols/hdc.svg"},
    {"name": "double crochet", "file": "assets/crochet_symbols/dc.svg"},
    {"name": "treble crochet", "file": "assets/crochet_symbols/tc.svg"},
    {"name": "double treble crochet", "file": "assets/crochet_symbols/dtc.svg"},
    {"name": "single crochet 2 together", "file": "assets/crochet_symbols/sc2tog.svg"},
    {"name": "single crochet 3 together", "file": "assets/crochet_symbols/sc3tog.svg"},
    {"name": "double crochet 2 together", "file": "assets/crochet_symbols/dc2tog.svg"},
    {"name": "double crochet 3 together", "file": "assets/crochet_symbols/dc3tog.svg"},
    {"name": "puff", "file": "assets/crochet_symbols/puff.svg"},
    {"name": "5 double crochet popcorn", "file": "assets/crochet_symbols/5dc-popcorn.svg"},
    {"name": "chain 3 picot", "file": "assets/crochet_symbols/ch3-picot.svg"},
    {"name": "front post double crochet", "file": "assets/crochet_symbols/fpdc.svg"},
    {"name": "back post double crochet", "file": "assets/crochet_symbols/bpdc.svg"},
    {"name": "back loop only", "file": "assets/crochet_symbols/blo.svg"},
    {"name": "front loop only", "file": "assets/crochet_symbols/flo.svg"},
    {"name": "no stitch", "file": "assets/crochet_symbols/none.svg"},
  ];

  final List<Map<String, String>> knitSymbols = [
    {"name": "knit", "file": "assets/knit_symbols/k.svg"},
    {"name": "purl", "file": "assets/knit_symbols/p.svg"},
    {"name": "yarn over", "file": "assets/knit_symbols/yo.svg"},
    {"name": "knit 2 together", "file": "assets/knit_symbols/k2tog.svg"},
    {"name": "purl 2 together", "file": "assets/knit_symbols/p2tog.svg"},
    {"name": "slip slip knit", "file": "assets/knit_symbols/ssk.svg"},
    {"name": "slip slip purl", "file": "assets/knit_symbols/ssp.svg"},
    {"name": "knit 3 together", "file": "assets/knit_symbols/k3tog.svg"},
    {"name": "slip slip slip knit", "file": "assets/knit_symbols/sssk.svg"},
    {"name": "make 1 right", "file": "assets/knit_symbols/m1r.svg"},
    {"name": "make 1 left", "file": "assets/knit_symbols/m1l.svg"},
    {"name": "knit through back loop", "file": "assets/knit_symbols/ktbl.svg"},
    {"name": "purl through back loop", "file": "assets/knit_symbols/ptbl.svg"},
    {"name": "bind off", "file": "assets/knit_symbols/bo.svg"},
    {"name": "no stitch", "file": "assets/knit_symbols/none.svg"},
  ];

  double zoom = 1.0; // Zoom scale for InteractiveViewer

  @override
  void initState() {
    super.initState();
    _generateGrid();
  }

  // Generates an empty grid
  void _generateGrid() {
    generatedWidth = widget.gridWidth;
    generatedHeight = widget.gridHeight;
    grid = List.generate(generatedHeight, (_) => List.filled(generatedWidth, ""));
    gridGenerated = true;
    zoom = 1.0;
    _transformationController.value = Matrix4.identity();
    setState(() {});
  }

  // Handles a cell tap
  void _handleCellTap(int row, int col) {
    if (row < 0 || row >= grid.length || col < 0 || col >= grid[row].length) return;

    // Save current state for undo
    _undoStack.add(grid.map((r) => List<String>.from(r)).toList());
    _redoStack.clear(); // Clear redo stack on new action

    if (widget.selectedMode == Mode.colour) {
      grid[row][col] = colorToHex(selectedColor);
    } else {
      final symbolList = widget.selectedMode == Mode.knit ? knitSymbols : crochetSymbols;
      final symbol = symbolList.firstWhere(
            (s) => s["name"] == selectedSymbol,
        orElse: () => {"name": "no stitch"},
      );
      grid[row][col] = symbol["name"]!;
    }
    setState(() {});
  }

  void undo() {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(grid.map((r) => List<String>.from(r)).toList());
      grid = _undoStack.removeLast();
      setState(() {});
    }
  }

  void redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(grid.map((r) => List<String>.from(r)).toList());
      grid = _redoStack.removeLast();
      setState(() {});
    }
  }

  Future<void> saveGridAsImage() async {
    try {
      RenderRepaintBoundary boundary = _gridKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final channel = MethodChannel('com.example.grid');
      final result = await channel.invokeMethod('saveImageToGallery', {'bytes': pngBytes});

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saved to gallery!")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error saving image: $e")));
    }
  }

  Widget buildSymbolDropdown(List<Map<String, String>> symbols, String modeName) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFFDCE7FB),
          borderRadius: BorderRadius.circular(15),
        ),
        child: DropdownButton<String>(
          value: symbols.any((s) => s["name"] == selectedSymbol) ? selectedSymbol : null,
          hint: Text("Select a $modeName stitch"),
          onChanged: (value) {
            final symbol = symbols.firstWhere((s) => s["name"] == value);
            setState(() {
              selectedSymbol = symbol["name"]!;
            });
          },
          items: symbols.map((symbol) {
            return DropdownMenuItem<String>(
              value: symbol["name"],
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(symbol["file"]!),
                  ),
                  SizedBox(width: 8),
                  Text(symbol["name"]!),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Size of each grid cell in main grid
    final double cellSize = 30;
    Mode selectedMode = widget.selectedMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "G R I D",
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

      body: Container(
        color: Color(0xFFFDDBE6),
        child: Column(
          children: [
            SizedBox(height: 10),
            Image.asset(
              'assets/images/designs/string.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            if (gridGenerated)
              Column(
                children: [
                  //undo/redo
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: undo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDCE7FB),
                          foregroundColor: Color(0xFFEA467E),
                        ),
                        child: Text("Undo"),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: redo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDCE7FB),
                          foregroundColor: Color(0xFFEA467E),
                        ),
                        child: Text("Redo"),
                      ),
                    ],
                  ),

                  ElevatedButton(
                    onPressed: saveGridAsImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFDCE7FB),
                      foregroundColor: Color(0xFFEA467E),
                    ),
                    child: Text("Save Grid as Image"),
                  ),

                  //zoom
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("ZOOM: "),
                      Slider(
                        value: zoom,
                        min: 0.2,
                        max: 5.0,
                        divisions: 48,
                        label: zoom.toStringAsFixed(2),
                        activeColor: Color(0xFFEA467E),
                        onChanged: (value) {
                          setState(() {
                            zoom = value;
                            // Also update InteractiveViewer matrix scale
                            _transformationController.value = Matrix4.identity()..scale(zoom);
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),

            SizedBox(height: 12),

            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: RepaintBoundary(
                      key: _gridKey,
                      child: InteractiveViewer(
                        constrained: false,
                        boundaryMargin: EdgeInsets.all(20),
                        minScale: 0.2,
                        maxScale: 5.0,
                        scaleEnabled: false,
                        transformationController: _transformationController,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // TOP COLUMN LABELS
                              Row(
                                children: [
                                  const SizedBox(width: 32, height: 32), // top-left spacer
                                  ...List.generate(
                                    generatedWidth,
                                        (col) => Container(
                                      width: cellSize,
                                      height: cellSize,
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                        child: Text(
                                          '${col + 1}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 32), // optional padding after last column
                                ],
                              ),
                      
                              // GRID WITH LEFT/RIGHT LABELS
                              ...List.generate(generatedHeight, (row) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Left row number
                                    Container(
                                      width: 32,
                                      height: cellSize,
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                        child: Text(
                                          '${generatedHeight - row}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                      
                                    // Grid cells
                                    ...List.generate(generatedWidth, (col) {
                                      return GestureDetector(
                                        onTap: () => _handleCellTap(row, col),
                                        child: Container(
                                          width: cellSize,
                                          height: cellSize,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            border: Border.all(
                                              color: Colors.pink.shade100,
                                              width: 0.5,
                                            ),
                                          ),
                                          alignment: Alignment.center,
                                          child: Builder(
                                            builder: (_) {
                                              final symbolName = grid[row][col];
                      
                                              if (symbolName.isEmpty) {
                                                return SizedBox.shrink();
                                              }
                      
                                              if (symbolName.startsWith('#')) {
                                                return Container(
                                                  width: cellSize,
                                                  height: cellSize,
                                                  decoration: BoxDecoration(
                                                    color: hexToColor(symbolName),
                                                  ),
                                                );
                                              }
                      
                                              final crochetMatch = crochetSymbols.firstWhere(
                                                    (s) => s["name"] == symbolName,
                                                orElse: () => {},
                                              );
                      
                                              final knitMatch = knitSymbols.firstWhere(
                                                    (s) => s["name"] == symbolName,
                                                orElse: () => {},
                                              );
                      
                                              final filePath = crochetMatch["file"] ?? knitMatch["file"];
                      
                                              if (filePath == null || filePath.isEmpty) {
                                                return Icon(Icons.error, size: cellSize * 0.5);
                                              }
                      
                                              return SvgPicture.asset(
                                                filePath,
                                                width: cellSize * 0.8,
                                                height: cellSize * 0.8,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }),
                      
                                    // Right row number
                                    Container(
                                      width: 32,
                                      height: cellSize,
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                        child: Text(
                                          '${generatedHeight - row}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                      
                              // BOTTOM COLUMN LABELS
                              Row(
                                children: [
                                  const SizedBox(width: 32, height: 32), // bottom-left spacer
                                  ...List.generate(
                                    generatedWidth,
                                        (col) => Container(
                                      width: cellSize,
                                      height: cellSize,
                                      alignment: Alignment.center,
                                      child: FittedBox(
                                        child: Text(
                                          '${col + 1}',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 32), // optional right padding
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),


            if (selectedMode == Mode.crochet)
              buildSymbolDropdown(crochetSymbols, "crochet")
            else if (selectedMode == Mode.knit)
              buildSymbolDropdown(knitSymbols, "knit")
            else if (selectedMode == Mode.colour)
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Pick a Color"),
                              content: SingleChildScrollView(
                                child: ColorPicker(
                                  pickerColor: selectedColor,
                                  onColorChanged: (color) {
                                    selectedColor = color;
                                  },
                                  enableAlpha: false,
                                  pickerAreaHeightPercent: 0.7,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: Text("Select"),
                                  onPressed: () {
                                    // Add to recent colors
                                    if (!recentColors.contains(selectedColor)) {
                                      recentColors.insert(0, selectedColor);
                                      if (recentColors.length > 10) {
                                        recentColors = recentColors.sublist(0, 10);
                                      }
                                    }
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDCE7FB),
                          foregroundColor: Color(0xFFEA467E),
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 20,
                          ),
                          minimumSize: Size(100, 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: Color(0xFFEA467E),
                                  width: 2
                              )
                          )
                      ),
                      child: Text(
                          "Pick a Color",
                          style: TextStyle(
                            fontSize: 17,
                          )
                      ),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: recentColors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedColor == color ? Colors.black : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
            Image.asset(
              'assets/images/designs/string_flipped.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}