import 'package:flutter/material.dart';
import 'grid.dart';
import 'drawer.dart';
import 'mode.dart';

class Designer extends StatefulWidget {
  const Designer({super.key});

  @override
  State<Designer> createState() => _DesignerState();
}

class _DesignerState extends State<Designer> {
  Mode selectedMode = Mode.crochet;

  final TextEditingController widthController = TextEditingController(text: "8");
  final TextEditingController heightController = TextEditingController(text: "8");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "D E S I G N E R",
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

      body: SafeArea(
        child: Container(
          color: Color(0xFFFDDBE6),
          child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 10),
                  
                      Image.asset(
                        'assets/images/designs/string.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                  
                      SizedBox(height: 10),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "MODE:  ",
                            style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold),
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
                                if (mode != null) setState(() => selectedMode = mode);
                              },
                              items: Mode.values.map((m) {
                                return DropdownMenuItem(
                                  value: m,
                                  child: Text(
                                    (m
                                        .toString()
                                        .split('.')
                                        .last).toUpperCase(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                  
                      SizedBox(height: 10),
                  
                      Image.asset(
                        'assets/images/designs/yarn.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                  
                      SizedBox(height: 10),
                  
                      Text(
                        "GRID SIZE:",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                  
                      SizedBox(height: 20),
                  
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("ROWS: ", style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: heightController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Color(0xFFDCE7FB),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Text("COLUMNS: ", style: TextStyle(fontSize: 18,
                              fontWeight: FontWeight.bold)),
                          SizedBox(
                            width: 50,
                            child: TextField(
                              controller: widthController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                isDense: true,
                                filled: true,
                                fillColor: Color(0xFFDCE7FB),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 6),
                              ),
                            ),
                          ),
                        ],
                      ),
                  
                      SizedBox(height: 20),
                  
                      Image.asset(
                        'assets/images/designs/yarn_flipped.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                  
                      SizedBox(height: 30),
                  
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            final width = int.tryParse(widthController.text) ?? 8;
                            final height = int.tryParse(heightController.text) ?? 8;
                  
                            if (width >= 2 && height >= 2 && width <= 100 &&
                                height <= 100) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      Grid(
                                        selectedMode: selectedMode,
                                        gridWidth: width,
                                        gridHeight: height,
                                      ),
                                ),
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    AlertDialog(
                                      title: Text("Invalid Input"),
                                      content: Text(
                                          "Please enter a number between 2 and 100 for both rows and columns."),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text("OK"),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFDCE7FB),
                            foregroundColor: Color(0xFFEA467E),
                            padding: EdgeInsets.symmetric(
                                vertical: 24, horizontal: 30),
                            minimumSize: Size(200, 70),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: BorderSide(color: Color(0xFFEA467E), width: 2),
                            ),
                          ),
                          child: Text("GENERATE GRID", style: TextStyle(
                              fontSize: 22)),
                        ),
                      ),
                  
                      SizedBox(height: 20),
                  
                      Image.asset(
                        'assets/images/designs/string_flipped.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                  
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
          ),
        ),
      )
    );
  }
}