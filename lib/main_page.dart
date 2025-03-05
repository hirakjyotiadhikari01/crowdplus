import 'package:flutter/material.dart';
import 'package:secoundapp/services/location_service.dart'; // Import the location service
import 'view_page.dart'; // Import ViewPage for navigation

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isTracking = false; // Variable to track whether tracking is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crowd Care+"),
        backgroundColor: Colors.green[800],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.green[800]),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Contact Us'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Help'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  "Start tracking?",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5)],
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isTracking = true;
                              });
                              LocationService.startTracking(); // Start continuous tracking
                              print("🚀 Tracking Started!");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Text("Start"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isTracking = false;
                              });
                              LocationService.stopTracking(); // Stop tracking
                              print("🛑 Tracking Stopped!");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: Text("Stop"),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to ViewPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewPage(title: "Tracking Data"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                        ),
                        child: Text("VIEW"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text("Are you in an emergency? Click below"),
                SizedBox(height: 20),
                Wrap(
                  spacing: 15,
                  runSpacing: 15,
                  children: [
                    IconButton(
                      icon: Icon(Icons.local_police, color: Colors.red),
                      onPressed: () {
                        print("Police Help");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.local_fire_department, color: Colors.red),
                      onPressed: () {
                        print("Fire Help");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.local_hospital, color: Colors.red),
                      onPressed: () {
                        print("Medical Help");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.warning, color: Colors.red),
                      onPressed: () {
                        print("Emergency Alert");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
