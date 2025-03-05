import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewPage extends StatefulWidget {
  final String title;

  const ViewPage({super.key, required this.title});

  @override
  _ViewPageState createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  Future<List<Map<String, dynamic>>> fetchTrackingData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/get-tracking-data'));

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        throw Exception("Failed to fetch tracking data.");
      }
    } catch (e) {
      print("Error fetching tracking data: $e");
      throw Exception("Error fetching tracking data.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTrackingData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No tracking data available"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var data = snapshot.data![index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Icon(Icons.location_on, color: Colors.red),
                    title: Text("Lat: ${data['latitude']}, Lng: ${data['longitude']}"),
                    subtitle: Text("Signal Strength: ${data['signal_strength']} dBm"),
                    trailing: Text("${data['timestamp']}"),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
