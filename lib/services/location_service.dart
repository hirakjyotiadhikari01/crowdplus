import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationService {
  static Timer? _timer; // Timer for periodic updates

  // ✅ Start Tracking Every 10 Seconds
  static void startTracking() {
    _timer = Timer.periodic(Duration(seconds: 10), (Timer t) async {
      await fetchAndSendData();
    });
    print("🚀 Tracking Started!");
  }

  // ✅ Stop Tracking
  static void stopTracking() {
    _timer?.cancel();
    print("🛑 Tracking Stopped!");
  }

  // ✅ Fetch Location & Network Data
  static Future<void> fetchAndSendData() async {
    try {
      // 📍 Get Location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // 🌐 Get Network Type
      var connectivityResult = await Connectivity().checkConnectivity();
      String networkType = (connectivityResult == ConnectivityResult.mobile)
          ? "Mobile Network"
          : (connectivityResult == ConnectivityResult.wifi)
          ? "Wi-Fi"
          : "No Network";

      print("📍 Location: ${position.latitude}, ${position.longitude} | 🌐 Network: $networkType");

      // 🔄 Send Data to Server
      await sendTrackingData(position.latitude, position.longitude, networkType);
    } catch (e) {
      print("❌ Error fetching data: $e");
    }
  }

  // ✅ Send Data to MySQL (via API)
  static Future<void> sendTrackingData(double latitude, double longitude, String networkType) async {
    print("📤 Sending Data: Latitude: $latitude, Longitude: $longitude, Network: $networkType");

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/store-tracking-data'),  // Use 10.0.2.2 for Android emulator
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "latitude": latitude,
        "longitude": longitude,
        "network_type": networkType,
      }),
    );

    print("🔄 Server Response: ${response.statusCode} | ${response.body}");

    if (response.statusCode == 201) {
      print("✅ Data stored successfully!");
    } else {
      print("❌ Failed to store tracking data. Response: ${response.body}");
    }
  }

}
