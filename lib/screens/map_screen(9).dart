import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart'; // النسخة اللي ظبطت معاك
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen9 extends StatefulWidget {
  const MapScreen9({super.key});

  @override
  State<MapScreen9> createState() => _MapScreen9State();
}

class _MapScreen9State extends State<MapScreen9> {
  // الألوان الرسمية للمشروع
  final Color neonGreen = const Color(0xFFCCFF00);
  final Color darkCard = const Color(0xFF121212);
  
  // متغيرات الخريطة والطريق
  LatLng _currentLocation = const LatLng(31.2598, 32.2882); // بداية افتراضية في بورسعيد
  List<LatLng> _routePoints = []; 
  bool _isLoading = true;

  // نقطة هدف تجريبية (مثلاً الكلية أو أي مكان في بورسعيد)
  final LatLng _destination = const LatLng(31.2635, 32.3019);

  @override
  void initState() {
    super.initState();
    _initMapLogic();
  }

  // دالة تحضير الخريطة بالكامل
  Future<void> _initMapLogic() async {
    await _determinePosition();
    if (!_isLoading) {
      await _getRoute(_destination);
    }
  }

  // جلب موقعك الحقيقي من الـ GPS
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _isLoading = false;
    });
  }

  // جلب مسار الطريق "السموز" من سيرفر OSRM
  Future<void> _getRoute(LatLng destination) async {
    final url = 'http://router.project-osrm.org/route/v1/driving/'
        '${_currentLocation.longitude},${_currentLocation.latitude};'
        '${destination.longitude},${destination.latitude}'
        '?overview=full&geometries=geojson';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List coords = data['routes'][0]['geometry']['coordinates'];
        setState(() {
          _routePoints = coords.map((c) => LatLng(c[1], c[0])).toList();
        });
      }
    } catch (e) {
      debugPrint("Routing Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. الخريطة (FlutterMap)
          _isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFCCFF00)))
          : FlutterMap(
              options: MapOptions(
                initialCenter: _currentLocation,
                initialZoom: 14.5,
              ),
              children: [
                // طبقة الـ Tiles مع تأثير الـ Dark Mode
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.smart_traffic.ziad',
                  tileBuilder: (context, tileWidget, tile) {
                    return ColorFiltered(
                      colorFilter: const ColorFilter.matrix([
                        -1,  0,  0, 0, 255,
                         0, -1,  0, 0, 255,
                         0,  0, -1, 0, 255,
                         0,  0,  0, 1, 0,
                      ]),
                      child: tileWidget,
                    );
                  },
                ),
                
                // رسم الطريق النيون
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      color: neonGreen,
                      strokeWidth: 5.0,
                      borderStrokeWidth: 3.0, // التعديل اللي شال الايرور
                      borderColor: neonGreen.withOpacity(0.3),
                      strokeCap: StrokeCap.round,
                      strokeJoin: StrokeJoin.round,
                    ),
                  ],
                ),

                // العلامات (Markers)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation,
                      child: _buildGlowPoint(Icons.my_location, Colors.blue),
                    ),
                    Marker(
                      point: _destination,
                      child: _buildGlowPoint(Icons.flag_rounded, neonGreen),
                    ),
                  ],
                ),
              ],
            ),

          // 2. الجزء العلوي (Search + Location Info)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 12),
                  _buildLocationInfoCard(),
                ],
              ),
            ),
          ),

          // 3. الجزء السفلي (Quick Actions)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildQuickActionsMenu(),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- دوال بناء الـ UI المساعدة ---

  Widget _buildGlowPoint(IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color.withOpacity(0.5), blurRadius: 20, spreadRadius: 5)],
      ),
      child: Icon(icon, color: color, size: 30),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: const TextField(
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Where to?",
          hintStyle: TextStyle(color: Colors.white38),
          prefixIcon: Icon(Icons.search, color: Colors.white54),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildLocationInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF111111).withOpacity(0.9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Current Location", style: TextStyle(color: Colors.white54, fontSize: 11)),
          const Text("Port Said University", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          Text("Traffic: Smooth Flow", style: TextStyle(color: neonGreen, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildQuickActionsMenu() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
      decoration: const BoxDecoration(
        color: Color(0xFF0A0A0A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _actionCard("Report", Icons.warning_amber_rounded, Colors.orange),
              _actionCard("Winch", Icons.local_shipping_outlined, neonGreen),
              _actionCard("Navigate", Icons.directions_rounded, Colors.cyan),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionCard(String title, IconData icon, Color color) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: const Color(0xFF161616), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.map_rounded, "Map", true),
          _navItem(Icons.store_outlined, "Store", false),
          _navItem(Icons.build_outlined, "Services", false),
          _navItem(Icons.person_outline, "Profile", false),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? neonGreen : Colors.white54, size: 28),
        Text(label, style: TextStyle(color: isActive ? neonGreen : Colors.white54, fontSize: 11)),
      ],
    );
  }
}