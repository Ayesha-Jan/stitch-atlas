import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum Mode { crochet, knit, colour }

class Designer extends StatefulWidget {
  const Designer({super.key});

  @override
  State<Designer> createState() => _DesignerState();
}

class _DesignerState extends State<Designer> {
  Mode selectedMode = Mode.crochet;

  final TextEditingController widthController = TextEditingController(text: "8");
  final TextEditingController heightController = TextEditingController(text: "8");
  final TransformationController _transformationController = TransformationController();

  int gridWidth = 8;
  int gridHeight = 8;
  int generatedWidth = 8;
  int generatedHeight = 8;

  bool gridGenerated = false;

  List<List<String>> grid = []; // 2D list to hold values (crochet_symbols or colors)
  String selectedSymbol = "single crochet"; // default stitch icon or color

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
  ];

  double zoom = 1.0; // Zoom scale for InteractiveViewer

  // Generates an empty grid
  void _generateGrid() {
    generatedWidth = gridWidth;
    generatedHeight = gridHeight;
    grid = List.generate(generatedHeight, (_) => List.filled(generatedWidth, ""));
    gridGenerated = true;
    zoom = 1.0;
    _transformationController.value = Matrix4.identity();
    setState(() {});
  }

  // Handles a cell tap
  void _handleCellTap(int row, int col) {
    if (row < 0 || row >= grid.length || col < 0 || col >= grid[row].length) return;
    // Store just the symbol name, not the file path
    final symbol = crochetSymbols.firstWhere((s) => s["name"] == selectedSymbol);
    grid[row][col] = symbol["name"]!;
    setState(() {});
  }

  @override
  void dispose() {
    widthController.dispose();
    heightController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Size of each grid cell in main grid
    final double cellSize = 30;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "D E S I G N E R",
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
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            children: [
              // Mode Row (centered)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "MODE:  ",
                    style: TextStyle(fontSize: 16),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFDCE7FB),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButton<Mode>(
                      dropdownColor: Color(0xFFDCE7FB),
                      value: selectedMode,
                      onChanged: (mode) {
                        if (mode != null) {
                          setState(() {
                            selectedMode = mode;
                            // Default to first crochet symbol if in crochet mode
                            if (mode == Mode.crochet && crochetSymbols.isNotEmpty) {
                              selectedSymbol = crochetSymbols[0]["name"]!;
                            } else {
                              selectedSymbol = "";
                            }
                          });
                        }
                      },
                      items: Mode.values.map((m) {
                        return DropdownMenuItem(
                          value: m,
                          child: Text((m.toString().split('.').last).toUpperCase()),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Grid Size Row (label)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "GRID SIZE:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Rows & Columns Inputs
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ROWS: "),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Color(0xFFDCE7FB),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      ),
                      onChanged: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed != null && parsed >= 2 && parsed <= 100) {
                          gridHeight = parsed;
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Text("COLUMNS: "),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: widthController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        isDense: true,
                        filled: true,
                        fillColor: Color(0xFFDCE7FB),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      ),
                      onChanged: (value) {
                        final parsed = int.tryParse(value);
                        if (parsed != null && parsed >= 2 && parsed <= 100) {
                          gridWidth = parsed;
                        }
                      },
                    ),
                  ),
                ],
              ),


              SizedBox(height: 20),

              // GENERATE GRID BUTTON
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _generateGrid();  // create a new grid with current gridSize
                    gridGenerated = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFDCE7FB),
                    foregroundColor: Color(0xFFEA467E),
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                            color: Color(0xFFEA467E),
                            width: 2
                        )
                    )
                ),
                child: Text(
                  "Generate Grid",
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),

              SizedBox(height: 12),

              // GRID
              if (gridGenerated)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Zoom:"),
                    Slider(
                      value: zoom,
                      min: 0.2,
                      max: 5.0,
                      divisions: 48,
                      label: zoom.toStringAsFixed(2),
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

              SizedBox(height: 12),

              // GRID + MINIMAP ROW
              if (gridGenerated)
                Expanded(
                  child: Stack(
                    children: [
                      // Main Grid with labels & zoom & scroll
                      Expanded(
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
                                // Top column labels
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 32, height: 32),
                                      ...List.generate(
                                        generatedWidth,
                                            (col) => Container(
                                          width: cellSize,
                                          height: cellSize,
                                          alignment: Alignment.center,
                                          child: Text('${col + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      const SizedBox(width: 32, height: 32),
                                    ],
                                  ),
                                ),

                                // MIDDLE ROWS: left labels + grid + right labels
                                ...List.generate(generatedHeight, (row) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 32,
                                        height: cellSize,
                                        alignment: Alignment.center,
                                        child: Text('${generatedHeight - row}', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                      ...List.generate(generatedWidth, (col) {
                                        return GestureDetector(
                                          onTap: () => _handleCellTap(row, col),
                                          child: Container(
                                            width: cellSize,
                                            height: cellSize,
                                            margin: EdgeInsets.all(1),
                                            color: Colors.grey[200],
                                            alignment: Alignment.center,
                                            child: grid[row][col].isEmpty
                                                ? SizedBox.shrink()
                                                : SvgPicture.asset(
                                                    crochetSymbols.firstWhere(
                                                          (s) => s["name"] == grid[row][col],
                                                      orElse: () => {"file": ""}, // fallback
                                                    )["file"]!,
                                                    width: cellSize * 0.8,
                                                    height: cellSize * 0.8,
                                                ),
                                          ),
                                        );
                                      }),
                                      Container(
                                        width: 32,
                                        height: cellSize,
                                        alignment: Alignment.center,
                                        child: Text('${generatedHeight - row}', style: TextStyle(fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  );
                                }),

                                // BOTTOM ROW: scrollable horizontally
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 32, height: 32), // bottom-left corner
                                      ...List.generate(
                                        generatedWidth,
                                            (col) => Container(
                                          width: cellSize,
                                          height: cellSize,
                                          alignment: Alignment.center,
                                          child: Text('${col + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      const SizedBox(width: 32, height: 32), // bottom-right corner
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (selectedMode == Mode.crochet)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                    color: Color(0xFFDCE7FB),
                    borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButton<String>(
                      value: crochetSymbols.any((s) => s["name"] == selectedSymbol) ? selectedSymbol : null,
                      hint: Text("Select a stitch"),
                      onChanged: (value) {
                        final symbol = crochetSymbols.firstWhere((s) => s["name"] == value);
                        setState(() {
                          selectedSymbol = symbol["name"]!; // this is the SVG path
                        });
                      },
                      items: crochetSymbols.map((symbol) {
                        return DropdownMenuItem<String>(
                          value: symbol["name"],
                          child: Container(
                            color: Color(0xFFDCE7FB),
                            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: SvgPicture.asset(
                                    symbol["file"]!,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text(symbol["name"]!),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}