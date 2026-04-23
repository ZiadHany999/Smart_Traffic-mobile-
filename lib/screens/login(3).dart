import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'registration_screen(4).dart'; 

class LoginScreen3 extends StatefulWidget {
  const LoginScreen3({super.key});

  @override
  State<LoginScreen3> createState() => _LoginScreen3State();
}

class _LoginScreen3State extends State<LoginScreen3> {
  final Color neonGreen = const Color(0xFFCCFF00); // اللون الفسفوري
  final Color darkGrey = const Color(0xFF1E1E1E); // لون الحقول

  // --- دالة إظهار مربع استعادة كلمة السر ---
void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: const Color(0xFF121212),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            // --- الحل هنا: إضافة الـ ScrollView عشان تمنع الـ Overflow ---
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // بياخد مساحة المحتوى بس
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Reset Password",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Enter your new password below",
                    style: TextStyle(color: Colors.white54, fontSize: 14),
                  ),
                  const SizedBox(height: 25),

                  const Text("New Password", style: TextStyle(color: Colors.white, fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildTextField(hint: "********", isPassword: true),

                  const SizedBox(height: 20),

                  const Text("Confirm Password", style: TextStyle(color: Colors.white, fontSize: 14)),
                  const SizedBox(height: 8),
                  _buildTextField(hint: "********", isPassword: true),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: neonGreen,
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      "Apply",
                      style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: neonGreen.withOpacity(0.5),
                            blurRadius: 50,
                            spreadRadius: 10,
                          ),
                        ],
                        image: const DecorationImage(
                          image: AssetImage('assets/icon/smart.png'), 
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Welcome Back",
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const Text(
                      "Sign in to continue",
                      style: TextStyle(color: Colors.white54, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              const Text("Email", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField(hint: "your@email.com"),

              const SizedBox(height: 25),

              const Text("Password", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              _buildTextField(hint: "Enter your password", isPassword: true),

              const SizedBox(height: 15),

              // --- ربط زرار Forgot Password بدالة الـ Dialog ---
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: _showForgotPasswordDialog, // نداء الدالة هنا
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: neonGreen,
                  minimumSize: const Size(double.infinity, 60),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.w900, fontSize: 18),
                ),
              ),

              const SizedBox(height: 40),

              Row(
                children: [
                  const Expanded(child: Divider(color: Colors.white12)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or continue with", style: TextStyle(color: Colors.white.withOpacity(0.3))),
                  ),
                  const Expanded(child: Divider(color: Colors.white12)),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  Expanded(child: _buildSocialButton("Google", FontAwesomeIcons.google, Colors.redAccent)),
                  const SizedBox(width: 20),
                  Expanded(child: _buildSocialButton("Apple", Icons.apple, Colors.white)),
                ],
              ),

              const SizedBox(height: 40),

              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white54, fontSize: 14),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(color: neonGreen, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // ويجت بناء حقول النص
  Widget _buildTextField({required String hint, bool isPassword = false}) {
    return TextField(
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24, fontSize: 14),
        filled: true,
        fillColor: darkGrey,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ويجت بناء زراير السوشيال ميديا
  Widget _buildSocialButton(String label, IconData icon, Color iconColor) {
    return Container(
      height: 65,
      decoration: BoxDecoration(
        color: darkGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 10),
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}