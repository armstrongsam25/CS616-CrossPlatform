// import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:google_maps_routes/google_maps_routes.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_js/flutter_js.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<LatLng>> getDirections({required LatLng origin, required LatLng destination, required String apiKey}) async {
  final endpointUrl = 'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey';

  final response = await http.get(Uri.parse(endpointUrl));
  print("helo");
  print(response);
  print(response.statusCode);
  if (response.statusCode == 200) {
    Map<String, dynamic> values = json.decode(response.body);
    print(values);
    if (values["routes"].isEmpty) return [];
    final leg = values["routes"][0]["legs"][0];
    print(leg["steps"]);
    List<LatLng> directions = [];
    for (var step in leg["steps"]) {
        var lat = step["start_location"]["lat"];
        var lng = step["start_location"]["lng"];
        directions.add(LatLng(lat, lng));
        print(LatLng(lat, lng));
    }
    return directions;

  } else {
    throw Exception('Error fetching directions');
  }
}


Future<MapsRoutes> getRoute(LatLng currentUserLocation, LatLng destination, MapsRoutes route) async{

  // MapsRoutes route = new MapsRoutes();
  DistanceCalculator distanceCalculator = new DistanceCalculator();
  String totalDistance = '';
  List<LatLng> points = await getDirections(origin:currentUserLocation, 
                                            destination:destination, apiKey: "AIzaSyA-IdEbSqz6C8NL0-RLzPF-17Byi5cIxNE");
  print('points!');
  print(points);
  await route.drawRoute(
    points,
    'name',
    Colors.blue,
    "AIzaSyA-IdEbSqz6C8NL0-RLzPF-17Byi5cIxNE",
    travelMode: TravelModes.driving
  );
  // await route.drawRoute(points, routeName, routeColor, googleApiKey)
  print("you are here: $currentUserLocation, and are going to $destination");
  return route;
}