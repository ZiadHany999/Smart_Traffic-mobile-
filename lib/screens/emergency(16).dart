import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // مكتبة الاتصال
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmergencyScreen16 extends StatefulWidget {
  const EmergencyScreen16({super.key});

  @override
  State<EmergencyScreen16> createState() => _EmergencyScreen16State();
}

class _EmergencyScreen16State extends State<EmergencyScreen16> {
  final Color neonGreen = const Color(0xFFCCFF00);
  final Color darkCard = const Color(0xFF121212);

  // --- التعديل السحري هنا: دالة الاتصال المحدثة ---
  Future<void> _makeCall(String phoneNumber) async {
    // 1. تنظيف الرقم من أي مسافات عشان السيستم يقرأه صح
    final String cleanNumber = phoneNumber.replaceAll(' ', '');
    final Uri launchUri = Uri(scheme: 'tel', path: cleanNumber);
    
    try {
      // 2. محاولة فتح الرقم بوضع externalApplication لضمان فتح الـ Dialer
      await launchUrl(
        launchUri,
        mode: LaunchMode.externalApplication, 
      );
    } catch (e) {
      // لو فيه مشكلة تظهر في الـ Console للـ Debugging
      debugPrint("Could not launch $cleanNumber: $e");
    }
  }

  // --- المربع الصغير (SOS Dialog) ---
  void _showSOSOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25))
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Emergency Call", 
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            _sosTile(title: "Ambulance (إسعاف)", number: "123", icon: Icons.medical_services, color: Colors.red),
            _sosTile(title: "Police (شرطة)", number: "122", icon: Icons.local_police, color: Colors.blue),
            _sosTile(title: "Fire (مطافئ)", number: "180", icon: Icons.fire_truck, color: Colors.orange),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _sosTile({required String title, required String number, required IconData icon, required Color color}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Text(number, style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold)),
      onTap: () {
        Navigator.pop(context); // قفل القائمة
        _makeCall(number);     // الاتصال
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text("Emergency Assistance", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const Text("24/7 roadside help", style: TextStyle(color: Colors.white54, fontSize: 16)),
                    
                    // --- زر الـ SOS الكبير ---
                    Center(
                      child: GestureDetector(
                        onTap: _showSOSOptions,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 40),
                          width: 250,
                          height: 250,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red.shade700,
                            boxShadow: [
                              BoxShadow(color: Colors.red.withOpacity(0.5), blurRadius: 40, spreadRadius: 10),
                            ],
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("SOS", style: TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.w900)),
                              Text("Emergency Call", style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const Center(child: Text("Press for immediate emergency dispatch", style: TextStyle(color: Colors.white54, fontSize: 14))),
                    const SizedBox(height: 40),

                    const Text("Quick Services", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 1.1,
                      children: [
                        _serviceCard("Winch", "Towing service", Icons.local_shipping_outlined),
                        _serviceCard("Fuel", "Fuel delivery", Icons.local_gas_station_outlined),
                        _serviceCard("Mechanic", "Live support", Icons.build_outlined),
                        _serviceCard("Jumpstart", "Battery boost", Icons.bolt_outlined),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // --- كارت الهوت لاين (الرقم المحدث) ---
                    InkWell(
                      onTap: () => _makeCall("+201025789366"),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: darkCard, 
                          borderRadius: BorderRadius.circular(20), 
                          border: Border.all(color: Colors.white10)
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Emergency Hotline", style: TextStyle(color: Colors.white54)),
                                  SizedBox(height: 5),
                                  Text("+20 102 578 9366", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            CircleAvatar(backgroundColor: neonGreen, child: const Icon(Icons.phone, color: Colors.black)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black, 
                border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05)))
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.map_outlined, "Map", false),
                  _navItem(Icons.store_outlined, "Store", false),
                  _navItem(Icons.build_rounded, "Services", true), 
                  _navItem(Icons.person_outline, "Profile", false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _serviceCard(String title, String sub, IconData icon) {
    return InkWell(
      onTap: () => print("$title Clicked"),
      child: Container(
        decoration: BoxDecoration(color: darkCard, borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: neonGreen.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: neonGreen, size: 30),
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(sub, style: const TextStyle(color: Colors.white38, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? neonGreen : Colors.white54, size: 28),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? neonGreen : Colors.white54, fontSize: 12)),
      ],
    );
  }
}