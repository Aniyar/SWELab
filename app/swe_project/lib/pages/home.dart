

import 'dart:convert';

import 'package:location/location.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Classes/task_route.dart';
import 'navbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:http/http.dart' as http;

import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;



class HomePage extends StatefulWidget {

  final int driverId;

  const HomePage({required this.driverId});

  @override
  _MyAppState createState() => _MyAppState();
}





class _MyAppState extends State<HomePage> {
  Set<Marker> markers = {};
  late int driverId;
  late double tasklat;
  late double tasklong;
  late double Current_User_Lat = 51.0905;
  late double Current_User_Long = 71.3982;

  late GoogleMapController mapController;
  Location location = Location();
  List<LatLng> polylineCoordinates = [];
  late PolylinePoints polylinePoints;
  LocationData? currentLocation;
  late bool isActiveRoute = false;
  late List<Task_route> waiting_routes = [];
  late Task_route task_route;



  @override
  void initState() {

    addCustomIcon(Colors.blue, Colors.deepOrange);
    super.initState();
    driverId = widget.driverId;
    _Initializevalues();
    print("HELLO THERE");
    print(waiting_routes);

  }






  Future<String> _loadAuthToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? ''; // Get the token, or an empty string if not found
  }


  Future<List<Task_route>> _fetchRoutes(String driverId, String status) async {
    var authresponse = await http.get(
      Uri.parse('http://51.20.192.129:80/routes/all?driverId=$driverId&status=$status'),
      headers: {
        'Authorization': 'Bearer ${await _loadAuthToken()}',
        'Content-Type': 'application/json',
      },
    );
    if(authresponse.statusCode == 200)
    {
      Map<String, dynamic> jsonMap = json.decode(authresponse.body) as Map<String, dynamic>;

      List<dynamic> taskListJson = jsonMap['content'];

      List<Task_route> taskList = taskListJson
          .map((taskJson) => Task_route.fromJson(taskJson))
          .toList();
      return taskList;
    } else {
      throw Exception('Failed to load routes');
    }
  }

void _Initializevalues() async
  {
    await _getCurrentLocation();
    await _isActiveTask();
    await Future.delayed(const Duration(seconds: 3));
    await _createRoutes();
    await Future.delayed(const Duration(seconds: 3));
    await _addMarkers();
    await Future.delayed(const Duration(seconds: 3));
    setState(() {

    });

  }


    Future<void> _getCurrentLocation() async {
      location.getLocation().then((location) {
        currentLocation = location;
      });
      location.changeSettings(
        interval: 1000,
        distanceFilter: 10,
        accuracy: LocationAccuracy.high
      );
      location.onLocationChanged.listen((newLoc)
      {
        currentLocation = newLoc;

            if (mounted) {
              setState(() {
                Current_User_Lat = currentLocation!.latitude!;
                Current_User_Long = currentLocation!.longitude!;
              });
            }
            if(isActiveRoute)
              {
                _sendLocation(Current_User_Lat, Current_User_Long);
                _getPolyline(tasklat,tasklong);
                _createRoutes();
              }

      },
      );
    }

  @override
  void dispose() {

    // Cancel location updates when the widget is disposed
    location.onLocationChanged.listen((LocationData newLoc) {}).cancel();
    super.dispose();
  }



Future<void> _sendLocation(double longitude, double latitude) async
{
  String token = await _loadAuthToken();
  var authresponse = await http.post(
      Uri.parse('http://51.20.192.129:80/vehicles/update-location'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String,String>{
        'longitude' : longitude.toString(),
        'latitude' : latitude.toString(),
      })

  );
}





  void _getPolyline(double tasklat, double tasklong) async {
    List<LatLng> tempPolylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyArJEBe7KfGf8m8nU5WzTtMZWk1Q9e7kGU",
        PointLatLng(Current_User_Lat, Current_User_Long),
        PointLatLng(tasklat, tasklong),
      );

      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) =>
            tempPolylineCoordinates.add(LatLng(point.latitude, point.longitude)));
      }

      // Check if the widget is still mounted before updating the state
      if (mounted) {
        setState(() {
          polylineCoordinates = tempPolylineCoordinates;
        });
      }
    } catch (e) {
      // Handle any exceptions or errors here
      print('Error in _getPolyline: $e');
    }
  }

Future<void> _isActiveTask() async
{
  List<Task_route> tasks = await _fetchRoutes(driverId.toString(), "IN_PROGRESS");


  setState(() {
    if(tasks.isEmpty)
    {
      isActiveRoute = false;
    }
    else
    {
      isActiveRoute = true;
    }
  });
}

Future<void> _createRoutes() async
{
  if(isActiveRoute) {
    task_route =
        (await _fetchRoutes(driverId.toString(), "IN_PROGRESS"))[0];
  }
  else
  {
    waiting_routes = await _fetchRoutes(driverId.toString(), "WAITING");
  }
  setState(() {
   if(isActiveRoute)
     {
       tasklat = double.parse(task_route.endLat);
       tasklong = double.parse(task_route.endLon);
     }
  });
}

  void _onMapCreated (GoogleMapController controller) async{

    mapController = controller;
  }
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconStart = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIconEnd = BitmapDescriptor.defaultMarker;
  Future<Uint8List?> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();
  }

  void addCustomIcon(Color color1, Color color2) async {
    final Uint8List? markerIconUint = await getBytesFromAsset('assets/marker.png', 150);
    final Uint8List? coloredBytes = await applyColorFilter(markerIconUint, color1);
    final Uint8List? markerIconUintStart = await getBytesFromAsset('assets/marker.png', 100);
    final Uint8List? coloredBytesStart = await applyColorFilter(markerIconUintStart, color2);
    final Uint8List? markerIconUintEnd = await getBytesFromAsset('assets/marker.png', 150);
    final Uint8List? coloredBytesEnd = await applyColorFilter(markerIconUintEnd, color2);
    markerIcon = BitmapDescriptor.fromBytes(coloredBytes!);
    markerIconStart = BitmapDescriptor.fromBytes(coloredBytesStart!);
    markerIconEnd = BitmapDescriptor.fromBytes(coloredBytesEnd!);
    setState(() {
      markerIcon = markerIcon;
      markerIconStart = markerIconStart;
      markerIconEnd = markerIconEnd;
    });
  }



  Future<Uint8List?> applyColorFilter(Uint8List? originalBytes, Color color) async {
    if (originalBytes == null) return null;

    final ui.Image image = await decodeImageFromList(originalBytes);
    final Paint paint = Paint()..colorFilter = ColorFilter.mode(color, BlendMode.srcIn);
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);

    canvas.drawImage(image, Offset(0, 0), paint);

    final ui.Image coloredImage = await recorder.endRecording().toImage(image.width, image.height);

    return (await coloredImage.toByteData(format: ui.ImageByteFormat.png))?.buffer.asUint8List();

  }


  void _setMapOrientation(double Current_User_Lat,double Current_User_Long,double tasklat, double tasklong) {
    double miny = (Current_User_Lat <= tasklat)
        ? Current_User_Lat
        : tasklat;
    double minx = (Current_User_Long <= tasklong)
        ? Current_User_Long
        : tasklong;
    double maxy = (Current_User_Lat <= tasklat)
        ? tasklat
        : Current_User_Lat;
    double maxx = (Current_User_Long <= tasklong)
        ? tasklong
        : Current_User_Long;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;
    mapController.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );
  }




Set<Marker> _addStartMarkers(List<Task_route> waiting_routes)
   {
  Set<Marker> markers = {};
  Map<int,Marker> Start_markers = {};
  for(int i = 0; i < waiting_routes.length; i++)
  { Start_markers[i] = Marker(
    markerId: MarkerId("${i+1}"),
    position: LatLng(double.parse(waiting_routes[i].startLat), double.parse(waiting_routes[i].startLon)),

    infoWindow: InfoWindow(title: waiting_routes[i].startPoint),
    icon: markerIcon,
    onTap: () {
      _setMapOrientation(Current_User_Lat, Current_User_Long, Start_markers[i]!.position.latitude, Start_markers[i]!.position.longitude);
      _getPolyline(Start_markers[i]!.position.latitude, Start_markers[i]!.position.longitude);
    },
  );
    markers.add(Start_markers[i]!);
  }
  return markers;
}
Set<Marker> _addActiveMarkers(Task_route task_route)
   {
  Set<Marker> markers = {};
  markers.add(
    Marker(
    markerId: MarkerId("Start"),
    position: LatLng(double.parse(task_route.startLat), double.parse(task_route.startLon)),
      infoWindow: InfoWindow(title: task_route.startPoint),
      icon: markerIconStart,
      onTap: () {
        _setMapOrientation(double.parse(task_route.startLat), double.parse(task_route.startLon), double.parse(task_route.endLat), double.parse(task_route.endLon));
      },
  ),
  );
  markers.add(
    Marker(
      markerId: MarkerId("End"),
      position: LatLng(double.parse(task_route.endLat), double.parse(task_route.endLon)),
      infoWindow: InfoWindow(title: task_route.endPoint),
      icon: markerIconEnd,
      onTap: () {
        _setMapOrientation( double.parse(task_route.startLat), double.parse(task_route.startLon), double.parse(task_route.endLat), double.parse(task_route.endLon));
      },
    ),
  );
  return markers;
}

Future<void> _addMarkers()
  async {
  if(!isActiveRoute)
  {
  markers = _addStartMarkers(waiting_routes);
  }
  else
  {
  markers = _addActiveMarkers(task_route);
  }
  setState(() {

  });
}

  @override
  Widget build(BuildContext context) {

    Marker user_marker = Marker(
        markerId: const MarkerId("0"),
        position: LatLng(Current_User_Lat,Current_User_Long),
        icon: BitmapDescriptor.defaultMarker
    );




    //List<Task_route> waiting_routes = [];


    //Task_route task_route;

      markers.add(user_marker);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        drawer:NavBar(),
        appBar: AppBar(
          title: const Text('Home',
            style: TextStyle(color: Colors.yellowAccent),),
            iconTheme: const IconThemeData(color: Colors.yellow),
          backgroundColor: Colors.brown
        ),
    body: GoogleMap(
    compassEnabled: true,
    scrollGesturesEnabled: true,
    zoomGesturesEnabled: true,
    myLocationEnabled: true,
    onMapCreated: _onMapCreated,
    initialCameraPosition: CameraPosition(
    target: LatLng(Current_User_Lat, Current_User_Long),
    zoom: 14,
    ),
    markers: markers,
      polylines: {
      Polyline(
          polylineId: const PolylineId("route"),
        points: polylineCoordinates,
          color: Colors.green,
        width: 6,
      ),
      },
      ),
    ),

    );

  }

}




