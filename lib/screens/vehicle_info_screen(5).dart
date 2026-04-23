import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
// --- الربط بالصفحة رقم 6 ---
import 'phone_number (6).dart'; 

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  // متغيرات الحالة (State)
  String? selectedBrand;
  String? selectedModel;
  File? plateImage;

  final Color neonGreen = const Color(0xFFCCFF00); // لوننا الرسمي

  // دالة اختيار الصورة (كاميرا أو استوديو)
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    
    if (image != null) {
      setState(() {
        plateImage = File(image.path);
      });
    }
  }

  // قائمة اختيار مصدر الصورة (BottomSheet)
  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library, color: neonGreen),
                title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt, color: neonGreen),
                title: const Text('Take a Photo', style: TextStyle(color: Colors.white)),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Vehicle Information", 
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اختار الماركة
            _buildLabel("SELECT BRAND/MAKE"),
            _buildDropdown(
              "Choose Brand", 
              ['Toyota', 'BMW', 'Mercedes', 'Hyundai', 'Kia'], 
              selectedBrand, 
              (val) => setState(() => selectedBrand = val)
            ),

            const SizedBox(height: 25),

            // اختار الموديل
            _buildLabel("SELECT MODEL"),
            _buildDropdown(
              "Choose Model", 
              ['Corolla', 'X5', 'C-Class', 'Elantra', 'Sportage'], 
              selectedModel, 
              (val) => setState(() => selectedModel = val)
            ),

            const SizedBox(height: 25),

            // رقم اللوحة
            _buildLabel("PLATE NUMBER"),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration("e.g., 6593 ج ي ب"),
            ),

            const SizedBox(height: 25),

            // رفع صورة اللوحة
            _buildLabel("UPLOAD LICENSE PLATE PHOTO"),
            const SizedBox(height: 10),
            
            GestureDetector(
              onTap: () => _showImagePickerOptions(context),
              child: DottedBorder(
                color: neonGreen.withOpacity(0.7),
                strokeWidth: 2,
                dashPattern: const [8, 4],
                borderType: BorderType.RRect,
                radius: const Radius.circular(15),
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0E1108),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: plateImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(plateImage!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, color: neonGreen, size: 45),
                            const SizedBox(height: 15),
                            Text(
                              "Tap to capture or upload", 
                              style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold, fontSize: 16)
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "JPEG, PNG up to 5MB", 
                              style: TextStyle(color: Colors.white38, fontSize: 12)
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
      
      // الزرار السفلي المربوط بصفحة 6
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(25.0),
        child: ElevatedButton(
          onPressed: () {
            // الانتقال لصفحة رقم التليفون
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PhoneNumberScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: neonGreen,
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 10,
            shadowColor: neonGreen.withOpacity(0.3),
          ),
          child: const Text(
            "NEXT", 
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18)
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets عشان الكود يكون منظم ---

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text, 
      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.1)
    ),
  );

  Widget _buildDropdown(String hint, List<String> items, String? val, Function(String?) onChanged) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: const Color(0xFF0E0E0E),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: neonGreen.withOpacity(0.3), width: 1.5),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: val,
        hint: Text(hint, style: const TextStyle(color: Colors.white24)),
        dropdownColor: const Color(0xFF1A1A1A),
        icon: Icon(Icons.keyboard_arrow_down, color: neonGreen),
        isExpanded: true,
        items: items.map((e) => DropdownMenuItem(
          value: e, 
          child: Text(e, style: const TextStyle(color: Colors.white))
        )).toList(),
        onChanged: onChanged,
      ),
    ),
  );

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Colors.white12),
    fillColor: const Color(0xFF0E0E0E),
    filled: true,
    contentPadding: const EdgeInsets.all(20),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), 
      borderSide: BorderSide(color: neonGreen.withOpacity(0.3))
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12), 
      borderSide: BorderSide(color: neonGreen, width: 2)
    ),
  );
}