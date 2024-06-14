import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reports List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ReportsList(),
    );
  }
}

class Report {
  final int id;
  final String username;
  final String location;
  final String type;
  final String info;
  final String imageUrl;
  final String createdAt;

  Report({
    required this.id,
    required this.username,
    required this.location,
    required this.type,
    required this.info,
    required this.imageUrl,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'],
      username: json['username'],
      location: json['location'],
      type: json['type'],
      info: json['info'],
      imageUrl: json['image'],
      createdAt: json['created_at'],
    );
  }
}

class ReportsList extends StatefulWidget {
  @override
  _ReportsListState createState() => _ReportsListState();
}

class _ReportsListState extends State<ReportsList> {
  List<Report> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReports();
  }

  Future<void> _fetchReports() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.1.50:3000/api/reports'));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse['status']) {
          List reportsJson = jsonResponse['reports'];
          setState(() {
            _reports =
                reportsJson.map((report) => Report.fromJson(report)).toList();
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load reports');
      }
    } catch (e) {
      // Handle exception
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reports List'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _reports.length,
              itemBuilder: (context, index) {
                final report = _reports[index];
                return Card(
                  color: Colors.transparent, // Transparent background
                  elevation: 0, // Remove shadow
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.5), // Semi-transparent background
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(8.0),
                    margin:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                    child: Row(
                      children: [
                        report.imageUrl.isNotEmpty
                            ? Image.network(
                                'http://192.168.1.50:3000/uploads/${report.imageUrl}',
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                width: 50, height: 50, color: Colors.grey),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                report.username,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text('Location: ${report.location}'),
                              Text('Kategori Sampah: ${report.type}'),
                              Text('Informasi Penjemputan: ${report.info}'),
                              Text(
                                'Tanggal Lapor: ${report.createdAt}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
