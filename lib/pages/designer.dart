import 'package:flutter/material.dart';

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

  int gridWidth = 8;
  int gridHeight = 8;
  int generatedWidth = 8;
  int generatedHeight = 8;

  bool gridGenerated = false;

  List<List<String>> grid = []; // 2D list to hold values (symbols or colors)
  String selectedSymbol = "🧵"; // default stitch icon or color


  double zoom = 1.0; // Zoom scale for InteractiveViewer

  final TransformationController _transformationController = TransformationController();

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
    grid[row][col] = selectedSymbol;
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

    // Size of each cell in minimap (smaller)
    final double miniCellSize = 6;

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
                          selectedMode = mode;
                          if (mode == Mode.crochet) {
                            selectedSymbol = "🧵";
                          } else if (mode == Mode.knit) {
                            selectedSymbol = "🧶";
                          } else {
                            selectedSymbol = "🟥";
                          }
                          setState(() {});
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
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Main Grid with labels & zoom & scroll
                      Expanded(
                        child: InteractiveViewer(
                          constrained: false,
                          boundaryMargin: EdgeInsets.all(20),
                          minScale: 0.2,
                          maxScale: 5.0,
                          scaleEnabled: false, // zoom controlled by slider now
                          transformationController: _transformationController,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // TOP ROW: scrollable horizontally
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const SizedBox(width: 32, height: 32), // top-left corner
                                      ...List.generate(
                                        generatedWidth,
                                            (col) => Container(
                                          width: cellSize,
                                          height: cellSize,
                                          alignment: Alignment.center,
                                          child: Text('${col + 1}', style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                      const SizedBox(width: 32, height: 32), // top-right corner
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
                                            child: Text(
                                              grid[row][col],
                                              style: TextStyle(fontSize: 18),
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

                      SizedBox(width: 12),

                      // MINIMAP
                      Container(
                        width: (generatedWidth * miniCellSize) + 64,
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text("Minimap", style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Top numbers row for minimap
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(width: 16), // corner spacing
                                      ...List.generate(
                                        generatedWidth,
                                            (col) => Container(
                                          width: miniCellSize,
                                          height: miniCellSize,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${col + 1}',
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                    ],
                                  ),

                                  ...List.generate(generatedHeight, (row) {
                                    return Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Left number label
                                        Container(
                                          width: 16,
                                          height: miniCellSize,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${generatedHeight - row}',
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        ),
                                        // Mini grid cells
                                        ...List.generate(generatedWidth, (col) {
                                          return Container(
                                            width: miniCellSize,
                                            height: miniCellSize,
                                            margin: EdgeInsets.all(0.5),
                                            color: grid[row][col].isEmpty
                                                ? Colors.grey[300]
                                                : Colors.pink[200],
                                            alignment: Alignment.center,
                                            child: Text(
                                              grid[row][col],
                                              style: TextStyle(fontSize: 6),
                                            ),
                                          );
                                        }),
                                        // Right number label
                                        Container(
                                          width: 16,
                                          height: miniCellSize,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${generatedHeight - row}',
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),

                                  // Bottom numbers row for minimap
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(width: 16),
                                      ...List.generate(
                                        generatedWidth,
                                            (col) => Container(
                                          width: miniCellSize,
                                          height: miniCellSize,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${col + 1}',
                                            style: TextStyle(fontSize: 8),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}