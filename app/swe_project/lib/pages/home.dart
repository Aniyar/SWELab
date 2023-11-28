
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../Classes/task_route.dart';
import 'navbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart';
import 'package:swe_project/main.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:swe_project/Classes/pair.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _MyAppState();
}

late double Current_User_Lat = 51.161808623949845;
late double Current_User_Long = 71.38478414136185;

late double taskstartlat = 43.234196832259315;
late double taskstartlong = 76.87903336148781;

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

bool _checktaskActive (List<Task_route> active_routes)
{
  if (active_routes.isEmpty)
    {
      return false;
    }
  else
    {
      return true;
    }
}

BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

@override
void initState()
{
  addCustomIcon();
  super.initState();
}

void addCustomIcon()
{
  BitmapDescriptor.fromAssetImage(const ImageConfiguration(), "assets/marker.png")
      .then(
      (icon){
        setState(() {
          markerIcon = icon;
        });
      }
  );
}



  @override
  Widget build(BuildContext context) {

    List<Task_route> active_routes = [];
    Map<PolylineId, Polyline> polylines = {};
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    void _onMapCreated (GoogleMapController controller) async{
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
          PointLatLng(taskstartlat, taskstartlong),
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
    Marker user_marker = Marker(
        markerId: MarkerId("0"),
        position: LatLng(Current_User_Lat,Current_User_Long),
        icon: BitmapDescriptor.defaultMarker
    );

    Map<int,Pair> markers = {};

      if(_checktaskActive(active_routes))
        {
          for(int i = 0; i < active_routes.length; i++)
            { markers[i] = Pair(
              Marker(
                markerId: MarkerId("Start of task  + ${i+1}"),
                position: LatLng(double.parse(active_routes[i].startLat), double.parse(active_routes[i].startLon)),

                infoWindow: InfoWindow(title: "Start + ${i+1}"),
                icon: markerIcon,
                onTap: () {
                  _getPolyline();
                  _setMapOrientation(Current_User_Long, Current_User_Lat, taskstartlong, taskstartlat);
                  },
              ),
            Marker(
            markerId: MarkerId("End of task  + ${i+1}"),
            position: LatLng(double.parse(active_routes[i].endLat), double.parse(active_routes[i].endLon)),

            infoWindow: InfoWindow(title: "End + ${i+1}"),
            icon: markerIcon,
            onTap: () {
            _getPolyline();
            _setMapOrientation(Current_User_Long, Current_User_Lat, taskstartlong, taskstartlat);
            },
            ),
            );
            }
        }

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




