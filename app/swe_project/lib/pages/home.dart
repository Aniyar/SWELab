
import 'package:flutter/material.dart';
import 'navbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:swe_project/main.dart';
import 'package:geolocator/geolocator.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _MyAppState();
}
late double Current_User_Lat = 0;
late double Current_User_Long = 0;

late double tasklat = 10;
late double tasklong = 10;

class _MyAppState extends State {
  late GoogleMapController mapController;

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled)
    {
      return Future.error('Location services are disabled.');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied)
    {
      permission = await Geolocator.requestPermission();
    }
    if(permission == LocationPermission.denied)
    {
      return Future.error('Location permissions are denied');
    }

    if (permission == LocationPermission.deniedForever)
    {
      return Future.error('There is nothing we can do');
    }
    return await Geolocator.getCurrentPosition();
  }



  void_liveLocation(){
    LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100
    );
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      Current_User_Lat = position.latitude;
      Current_User_Long = position.longitude;
    }
    );
  }



  final LatLng _center = LatLng(Current_User_Lat, Current_User_Long);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        drawer:NavBar(),
        appBar: AppBar(
          title: Text('Home',
            style: TextStyle(color: Colors.yellowAccent),),
            iconTheme: IconThemeData(color: Colors.yellow),
          backgroundColor: Colors.brown
        ),
    body: GoogleMap(
    compassEnabled: true,
    onMapCreated: _onMapCreated,
    initialCameraPosition: CameraPosition(
    target: _center,
    zoom: 11,
          ),
    markers: {
      Marker(
    markerId:  MarkerId('My Location'),
    position: LatLng(Current_User_Lat,Current_User_Long)
    )
        }
    ),
floatingActionButton: FloatingActionButton(

  onPressed: ()
  {
    _getCurrentLocation().then((value){
      setState(() {
        Current_User_Lat = value.latitude;
        Current_User_Long = value.longitude;
        mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(Current_User_Lat,Current_User_Long), 11));
      });
    });
  },
  child: const Icon(Icons.location_on),
    ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,

    ),
    );
  }}




