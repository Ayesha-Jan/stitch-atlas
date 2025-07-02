import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer> {
  List<Map<String, dynamic>> regions = [];

  @override
  void initState() {
    super.initState();
    loadRegionData();
  }

  Future<void> loadRegionData() async {
    final String response = await rootBundle.loadString('assets/data/regions.json');
    final data = json.decode(response);
    setState(() {
      regions = List<Map<String, dynamic>>.from(data);
    });
  }

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
                )),
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
      body: regions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
        options: MapOptions(
          center: LatLng(20, 0),
          zoom: 2,
        ),
        children: [
          // TileLayer for base map tiles
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),

          // Overlay a semi-transparent pink polygon to simulate pink land color
          PolygonLayer(
            polygons: [
              Polygon(
                points: [
                  LatLng(90, -180),
                  LatLng(90, 180),
                  LatLng(-90, 180),
                  LatLng(-90, -180),
                ],
                color: Color(0xFFFDDBE6).withOpacity(0.3),
                borderColor: Colors.transparent,
              )
            ],
          ),

          MarkerLayer(
            markers: regions.map((region) {
              final coords = region['coordinates'];
              // If no coordinates, provide default (e.g., 0,0) or skip marker
              if (coords == null || coords.length < 2) {
                return null;
              }
              return Marker(
                point: LatLng(coords[0], coords[1]),
                width: 40,
                height: 40,
                builder: (ctx) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegionDetail(region: region),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEA467E),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              );
            }).whereType<Marker>().toList(),
          ),
        ],
      ),
    );
  }
}

class RegionDetail extends StatelessWidget {
  final Map<String, dynamic> region;
  const RegionDetail({super.key, required this.region});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(region['region'] ?? 'Region')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Region: ${region['region'] ?? 'Unknown'}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 6),
              Text(
                "Countries: ${region['countries'] ?? 'Unknown'}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 6),
              Text(
                "Culture: ${region['culture'] ?? 'Unknown'}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(region['description'] ?? '', style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              Text("Pattern: ${region['pattern'] ?? 'Unknown'}",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
