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

  // Generates an empty grid
  void _generateGrid() {
    generatedWidth = gridWidth;
    generatedHeight = gridHeight;
    grid = List.generate(generatedHeight, (_) => List.filled(generatedWidth, ""));
    gridGenerated = true;
    setState(() {});
  }

  // Handles a cell tap
  void _handleCellTap(int row, int col) {
    grid[row][col] = selectedSymbol;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
              Row(
                children: [
                  Text("MODE:  "),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFFDCE7FB),         // background color
                      borderRadius: BorderRadius.circular(15), // rounded corners
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
                            selectedSymbol = "🟥"; // color block
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

                SizedBox(width: 10),

                // GRID SIZE DROPDOWN
                Text("GRID SIZE:  "),

                SizedBox(width: 10),
                Text("W: "),
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

                SizedBox(width: 10),
                Text("H: "),
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

            SizedBox(height: 16),

            // GRID
            if (gridGenerated)
              Expanded(
                child: GridView.builder(
                  itemCount: generatedWidth * generatedHeight,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: generatedWidth,
                  ),
                  itemBuilder: (context, index) {
                    final row = index ~/ generatedWidth;
                    final col = index % generatedWidth;
                    return GestureDetector(
                      onTap: () => _handleCellTap(row, col),
                      child: Container(
                        margin: EdgeInsets.all(1),
                        color: Colors.grey[200],
                        child: Center(
                          child: Text(
                            grid[row][col],
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}