import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  File? _image;
  String _errorMessage = '';

  Future<void> _register() async {
    if (_image == null) {
      setState(() {
        _errorMessage = 'Please select an image';
      });
      return;
    }

    String baseUrl = 'http://192.168.1.50:3000/api/register';
    var uri = Uri.parse(baseUrl);

    try {
      var request = http.MultipartRequest('POST', uri)
        ..fields['username'] = _usernameController.text
        ..fields['password'] = _passwordController.text
        ..fields['nama'] = _namaController.text
        ..fields['alamat'] = _alamatController.text
        ..files.add(await http.MultipartFile.fromPath('foto', _image!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        if (data['status']) {
          // Save photo path to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('photoPath', _image!.path);

          Navigator.pop(context); // Go back to previous page
        } else {
          setState(() {
            _errorMessage = 'Register failed: ' + data['message'];
          });
        }
      } else {
        final responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);
        setState(() {
          _errorMessage = 'Register failed: ${data['message']}';
        });
      }
    } catch (e) {
      print('Error during register: $e');
      setState(() {
        _errorMessage = 'Register failed: $e';
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (_image != null)
              Image.file(
                _image!,
                height: 100,
                width: 100,
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.camera),
                  child: Text('Camera'),
                ),
                ElevatedButton(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  child: Text('Gallery'),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _alamatController,
              decoration: InputDecoration(labelText: 'Alamat'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: Text('Register'),
            ),
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: 20),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Register App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RegisterPage(),
    );
  }
}
