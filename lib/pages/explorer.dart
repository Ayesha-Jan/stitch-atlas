import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'drawer.dart';


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
            fontSize: 20,
            color: Color(0xFFEA467E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFDCE7FB),
      ),
      drawer: const AppDrawer(),

      body: regions.isEmpty
        ? Center(child: CircularProgressIndicator())
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
            tileProvider: NetworkTileProvider(
              headers: {
              'User-Agent': 'StitchAtlas/1.0 (ayeshajan667@gmail.com)',
              },
            ),
          ),

          MarkerLayer(
            markers: regions.map((region) {
              final coords = region['coordinates'];
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
      appBar: AppBar(
        title: Text(
          (region['region'] ?? 'Region').toUpperCase(),
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFFEA467E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFFDCE7FB),
      ),
      backgroundColor: Color(0xFFFDDBE6),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Image.asset(
              'assets/images/designs/string.png',
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  color: Color(0xFFDCE7FB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "COUNTRIES: ",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFEA467E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Center(
                          child: Text(
                            "${region['countries'] ?? 'Unknown'}",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 6),
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Card(
                  color: Color(0xFFDCE7FB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "CULTURES: ",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(0xFFEA467E),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Center(
                          child: Text(
                            "${region['culture'] ?? 'Unknown'}",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                color: Color(0xFFDCE7FB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Text(
                    region['description'] ?? '',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                color: Color(0xFFDCE7FB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                elevation: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "PATTERN: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color(0xFFEA467E),
                        ),
                      ),
                      Text(
                        "${region['pattern'] ?? 'Unknown'}",
                        style: TextStyle(fontSize: 17),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            if (region['image'] != null && region['image'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    region['image'],
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            SizedBox(height: 10),
            if (region['source'] != null && region['source'].toString().isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final url = Uri.parse(region['source']);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch URL')),
                        );
                      }
                    },
                    icon: Icon(Icons.open_in_new),
                    label: Text("Learn More",
                      style: TextStyle(fontSize: 25),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFEA467E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: 10),
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
