import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';

Future<Map<String, dynamic>> fetchAbout() async {
  final response =
      await http.get(Uri.parse('http://192.168.1.50:3000/api/about'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  Future<Map<String, dynamic>>? aboutData;
  List<String> imageUrls = [
    'images/sampah1.jpg',
    'images/sampah2.jpg',
    'images/sampah3.jpg',
    'images/sampah4.jpg',
  ]; // Ganti dengan path gambar yang sesuai dari folder images di dalam proyek Anda

  @override
  void initState() {
    super.initState();
    aboutData = fetchAbout();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Expanded(
              child: Text(
                'TrashTrack',
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: Colors.white, // Mengatur warna teks menjadi putih
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Tambahkan logika untuk meng-handle aksi dari ikon sampah di sini
                print('Delete icon pressed');
              },
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: aboutData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final data = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 2.0,
                      onPageChanged: (index, reason) {
                        // Kode untuk menangani perubahan halaman (opsional)
                      },
                    ),
                    items: imageUrls.map((url) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                            ),
                            child: Image.asset(
                              url,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 16),
                  Text('Name: ${data['name']}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 8),
                  Text('Version: ${data['version']}',
                      style: TextStyle(fontSize: 20)),
                  SizedBox(height: 8),
                  Text('Description: ${data['description']}',
                      style: TextStyle(fontSize: 20)),
                ],
              ),
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
