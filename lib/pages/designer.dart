import 'package:flutter/material.dart';

enum Mode { crochet, knit, colour }

class Designer extends StatefulWidget {
  const Designer({super.key});

  @override
  State<Designer> createState() => _DesignerState();
}

class _DesignerState extends State<Designer> {
  Mode selectedMode = Mode.crochet;
  int gridSize = 8;
  bool gridGenerated = false;

  dynamic selectedTool;
  late List<List<dynamic>> gridData;

  @override
  void initState() {
    super.initState();
    _initializeGrid();
  }

  void _initializeGrid(){
    gridData = List.generate(gridSize, (_) => List.generate(gridSize, (_) => null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Designer"),
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
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton<Mode>(
                  value: selectedMode,
                  onChanged: (Mode? value) {
                    setState(() => selectedMode = value!);
                  },
                  items: Mode.values.map((mode) {
                    return DropdownMenuItem(
                      value: mode,
                      child: Text(mode.name.toUpperCase()),
                    );
                  }).toList(),
                ),
                DropdownButton<int>(
                  value: gridSize,
                  onChanged: (int? value) {
                    setState(() {
                      gridSize = value!;
                      _initializeGrid();
                    });
                  },
                  items: [8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30].map((size) {
                    return DropdownMenuItem(value: size, child: Text('$size x $size'));
                  }).toList(),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      gridGenerated = true;
                      _initializeGrid();
                    });
                  },
                  child: Text("Generate Grid"),
                ),
              ],
            ),
            SizedBox(height: 16),
            if(gridGenerated) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select ${selectedMode == Mode.colour ? "Color" : "Stitch"}:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              SizedBox(height: 8),

              selectedMode == Mode.colour
              ? Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (String stitch in ["sc", "dc", "tr"])
                    GestureDetector(
                      onTap: () => setState(() => selectedTool = stitch),
                      child: Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: selectedTool == stitch ? Colors.black : Colors.grey,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Image.asset(
                            'assets/stitches/$stitch.png',
                            height: 30,
                          ),
                        ),
                      )
                    ),
                ],
              ):

              SizedBox(height: 16),

              Expanded(
                child: GridView.builder(
                  itemCount: gridSize * gridSize,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: gridSize,
                  ),
                  itemBuilder: (context, index) {
                    int row = index ~/ gridSize;
                    int col = index % gridSize;
                    var cell = gridData[row][col];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          gridData[row][col] = selectedTool;
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: selectedMode == Mode.colour
                            ? (cell ?? Colors.white)
                            : Colors.white,
                          border: Border.all(color: Colors.black12),
                        ),
                        child: selectedMode != Mode.colour && cell != null
                          ? Center(
                            child: Image.asset(
                              'assets/stitches/$cell.png',
                              height: 30,
                            ),
                          )
                        : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
