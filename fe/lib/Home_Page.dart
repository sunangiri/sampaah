import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  late String _username;
  late String _location;
  late String _type;
  late String _info;
  late String _additionalInfo;
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _submitReport(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final uri = Uri.parse('http://192.168.1.50:3000/api/reportTrash');
    final request = http.MultipartRequest('POST', uri)
      ..fields['username'] = _username
      ..fields['location'] = _location
      ..fields['type'] = _type
      ..fields['info'] = _info
      ..fields['additionalInfo'] = _additionalInfo;

    if (_image != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        filename: basename(_image!.path),
      ));
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content:
                    Text('Laporan Anda Sukses, Tunggu Pengambilan Sampah.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Error'),
                content: Text('Maaf laporan anda gagal'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      }
    } catch (e) {
      print('Error: $e');
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text('An error occurred. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          });
    }
  }

  Future<void> _saveUsername(String username) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<String?> _getUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  @override
  void initState() {
    super.initState();
    _getUsername().then((username) {
      if (username != null) {
        setState(() {
          _username = username;
        });
      }
    });
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
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _username,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                  _saveUsername(value);
                },
                readOnly:
                    true, // Membuat field menjadi readonly atau hanya baca
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Lokasi Sampah'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Kategori Sampah'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the type of trash';
                  }
                  return null;
                },
                onSaved: (value) {
                  _type = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Informasi Penjemputan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter pickup information';
                  }
                  return null;
                },
                onSaved: (value) {
                  _info = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Informasi Tambahan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter additional information';
                  }
                  return null;
                },
                onSaved: (value) {
                  _additionalInfo = value!;
                },
              ),
              SizedBox(height: 16),
              _image == null
                  ? Text('No image selected.')
                  : Image.file(_image!, height: 200),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    child: Text('Pick Image'),
                  ),
                  ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.camera),
                    child: Text('Take Photo'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => _submitReport(context),
                child: Text('Submit Report'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
