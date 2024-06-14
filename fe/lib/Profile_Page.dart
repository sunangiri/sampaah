import 'dart:io'; // Import dart:io untuk menggunakan kelas File
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  String _nama = '';
  String _alamat = '';
  String _photoPath = ''; // Variable to store photo path

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? '';
      _nama = prefs.getString('nama') ?? '';
      _alamat = prefs.getString('alamat') ?? '';
      _photoPath = prefs.getString('photoPath') ?? ''; // Load photo path
    });
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TrashTrack'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (_photoPath.isNotEmpty && File(_photoPath).existsSync()) // Check if photo path is not empty and file exists
              Image.file(
                File(_photoPath), // Menggunakan kelas File untuk membaca path foto
                height: 100,
                width: 100,
              ),
            SizedBox(height: 10),
            Text('Username: $_username', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Nama: $_nama', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Alamat: $_alamat', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _logout,
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
