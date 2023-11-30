import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Classes/user.dart';

class StaffMapPage extends StatefulWidget {
  final User user;

  const StaffMapPage({required this.user});


  @override
  _StaffMapPageState createState() => _StaffMapPageState();
}

class _StaffMapPageState extends State<StaffMapPage> {
  GoogleMapController? _controller;
  Set<Marker> _markers = Set<Marker>();
  late LatLng _point1;
  late LatLng _point2;

  Future<String> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? ''; // Get the token, or an empty string if not found
  }


  Future<void> _CreateRoute(String address1, String startLat, String startLon, String address2, String endLat, String endLon)
  async {
    var url = Uri.http('51.20.192.129:80', '/routes');
    var response = await http.post(
      url,
      headers: {'Authorization': 'Bearer ${await _loadAuthToken()}',
        'Content-Type': 'application/json',},
      body: json.encode({"startPoint": address1,
        "startLat": startLat,
        "startLon": startLon,
        "endPoint": address2,
        "endLat": endLat,
        "endLon": endLon}),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode >= 200 && response.statusCode <= 300) {
      print("YAY");
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Route created successfully!'),
            duration: Duration(seconds: 2), // Adjust the duration as needed
          ));
    }


}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Points on Map'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) => _controller = controller,
        markers: _markers,
        onTap: _onMapTap,
        initialCameraPosition: CameraPosition(
          target: LatLng(51.0905, 71.3982),
          zoom: 10,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _savePoints(),
        child: Icon(Icons.save),
      ),
    );
  }

  void _onMapTap(LatLng point) {
    setState(() {
      if (_markers.length < 2) {
        _markers.add(Marker(
          markerId: MarkerId(point.toString()),
          position: point,
        ));

        if (_markers.length == 1) {
          _point1 = point;
        } else {
          _point2 = point;
        }
      }
    });
  }

  void _savePoints() async {
    // Reverse geocode to get addresses for the selected points
    List<Placemark> placemarks1 = await placemarkFromCoordinates(_point1.latitude, _point1.longitude);
    List<Placemark> placemarks2 = await placemarkFromCoordinates(_point2.latitude, _point2.longitude);

    String address1 = placemarks1.first.name ?? "";
    String address2 = placemarks2.first.name ?? "";

    // TODO: Save the latitude, longitude, and addresses as needed
    print('Point 1: $_point1, Address: $address1');
    print('Point 2: $_point2, Address: $address2');

    _CreateRoute(address1, _point1.latitude.toString(), _point1.longitude.toString(), address2, _point2.latitude.toString(), _point2.longitude.toString());

  }
}