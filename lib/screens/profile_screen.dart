import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username = '';

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  // ambil username dari SharedPreferences
  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => username = prefs.getString('username') ?? '-');
  }

  // hapus session lalu kembali ke login (stack dibersihkan)
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loginData');
    await prefs.remove('username');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil', style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 44,
                backgroundColor: Color(0xFF3A3A3C),
                child: Icon(Icons.person, size: 48, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              const Text(
                'Aslam Arganda',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                username,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 12),
              const Text(
                'Kesan: Sangat Menyenangkan, Mobile seruh walaupun saya yang masih bodoh',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 4),
              const Text(
                'Pesan: Makasih mas Umar dan mas Zaki , semangat mas!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF44336),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text('Logout'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
