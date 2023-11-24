
import 'dart:math';

import 'package:flutter/material.dart';
import '../Classes/Task.dart';
import 'navbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:swe_project/main.dart';
import 'package:geolocator/geolocator.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _MyAppState();
}

late double Current_User_Lat = 51.161808623949845;
late double Current_User_Long = 71.38478414136185;

late double tasklat = 43.234196832259315;
late double tasklong = 76.87903336148781;

late bool istaskactive = false;

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



  LatLng _center = LatLng(Current_User_Lat, Current_User_Long);

bool _checktaskActive (List<Task> tasks)
{
  if (tasks.isEmpty)
    {
      return false;
    }
  else
    {
      return true;
    }
}






  @override
  Widget build(BuildContext context) {

    List<Task> tasks = [Task(task_id: 1, task_lat: 43.234196832259315, task_long: 76.87903336148781), Task(task_id: 2, task_lat: 72, task_long: 52) ];
    Map<PolylineId, Polyline> polylines = {};
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    void _onMapCreated (GoogleMapController controller) async{
      /* _getCurrentLocation().then((value) {
      Current_User_Lat = value.latitude;
      Current_User_Long = value.longitude;
      mapController.animateCamera(CameraUpdate.newLatLngZoom(LatLng(Current_User_Lat,Current_User_Long), 11));
    }); */
      mapController = controller;
    }

    _addPolyLine() {
      PolylineId id = PolylineId("poly");
      Polyline polyline = Polyline(
          polylineId: id, color: Colors.red, points: polylineCoordinates);
      polylines[id] = polyline;
      setState(() {});
    }


    _getPolyline() async {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
          'AIzaSyArJEBe7KfGf8m8nU5WzTtMZWk1Q9e7kGU',
          PointLatLng(Current_User_Lat, Current_User_Long),
          PointLatLng(tasklat, tasklong),
          travelMode: TravelMode.driving);
      if (result.points.isNotEmpty) {
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
      }
      _addPolyLine();
    }



 void _setMapOrientation(double Current_User_Long,double Current_User_Lat,double tasklong, double tasklat) {
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

    Set<Marker> markers = {
      Marker(
      markerId: MarkerId("0"),
      position: LatLng(Current_User_Lat,Current_User_Long)
      ),

      if(_checktaskActive(tasks)) ...
        {
          for(int i = 0; i < tasks.length; i++) ...
            {
              Marker(
                markerId: MarkerId("Task + ${i+1}"),
                position: LatLng(tasks[i].task_lat, tasks[i].task_long),

                infoWindow: InfoWindow(title: "Task + ${i+1}"),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
                onTap: () {
                  _getPolyline();
                  _setMapOrientation(Current_User_Long, Current_User_Lat, tasklong, tasklat);
                  },
              ),

            }
        }
    };
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
    scrollGesturesEnabled: true,
    zoomGesturesEnabled: true,
    onMapCreated: _onMapCreated,
    initialCameraPosition: CameraPosition(
    target: _center,
    zoom: 11,
    ),
markers: Set.from(markers),
      polylines: Set<Polyline>.of(polylines.values),
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

  }

}




