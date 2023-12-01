// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:Skywalk/views/main_page/controllers/main_page_controller.dart';
import 'package:Skywalk/views/route_history.dart';
import 'package:Skywalk/views/user_settings.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart' as gmaps;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:Skywalk/views/login_page/login_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late GoogleMapController mapController;
  late gmaps.GoogleMapsPlaces _places;
  final LatLng _center = const LatLng(37.422060, -122.084057);
  Set<Marker> _markers = {};
  String userId = '';
  String userEmail = '';
  gmaps.PlaceDetails? _selectedPlaceDetails;

  bool addWarningMark = false;
  bool isCollapsed = true; // Track whether the panel is collapsed
  Set<Polyline> _polylines = {};
  LatLng? _currentUserLocation;
  List<Report> reportList = [];

  Future<void> _getCurrentUserLocation() async {
    final locationService = Location();
    final permission = await locationService.hasPermission();

    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.deniedForever) {
      await locationService.requestPermission();
    }

    final currentLocation = await locationService.getLocation();
    setState(() {
      _currentUserLocation =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);
    });

    if (mapController != null) {
      mapController.moveCamera(CameraUpdate.newLatLng(_currentUserLocation!));
    }
  }

  Future<List<LatLng>> getWalkingDirections(
      LatLng start, LatLng destination) async {
    const String apiKey =
        'AIzaSyA-IdEbSqz6C8NL0-RLzPF-17Byi5cIxNE'; // Replace with your API key
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${destination.latitude},${destination.longitude}&mode=walking&key=$apiKey'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);

      if (data['status'] == "OK") {
        List<LatLng> result = [];

        // Extract LatLng points from steps
        for (var route in data['routes']) {
          for (var leg in route['legs']) {
            for (var step in leg['steps']) {
              var start_location = step['start_location'];
              var end_location = step['end_location'];
              result.add(LatLng(start_location['lat'], start_location['lng']));
              result.add(LatLng(end_location['lat'], end_location['lng']));
            }
          }
        }

        print(result);
        return result;
      }
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    _places = gmaps.GoogleMapsPlaces(
        apiKey: "AIzaSyA-IdEbSqz6C8NL0-RLzPF-17Byi5cIxNE");
    _fetchUserId();
    _getCurrentUserLocation();

    if (!Get.isRegistered<MainPageController>()) {
      Get.put(MainPageController());
    }
  }

  Future<void> _fetchUserId() async {
    try {
      final user = await Amplify.Auth.getCurrentUser();
      final attributes = await Amplify.Auth.fetchUserAttributes();

      final emailAttribute = attributes.firstWhere(
        (attribute) => attribute.userAttributeKey.toString() == "email",
        orElse: () => AuthUserAttribute(
          userAttributeKey: AuthUserAttributeKey.email,
          value: "",
        ),
      );

      setState(() {
        userId = user.userId;
        userEmail = emailAttribute.value;
      });
    } catch (e) {
      print("Error getting user ID: $e");
    }
  }

  Future<void> _signOut() async {
    try {
      await Amplify.Auth.signOut();
      Get.offAll(() => LoginPage());
    } catch (e) {
      print("Error signing out: $e");
    }
  }

  Future<void> _displayPrediction(gmaps.Prediction? p) async {
    try {
      if (p == null) {
        print("Prediction is null");
        return;
      }
      final detail = await _places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry?.location.lat;
      final lng = detail.result.geometry?.location.lng;

      if (lat == null || lng == null) {
        print("Location details are null");
        return;
      }

      // Move the camera to the location
      mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));

      // final route = await getWalkingDirections(_currentUserLocation ?? _center, LatLng(lat, lng));

      setState(() {
        _selectedPlaceDetails = detail.result;
        isCollapsed = false;

        // Clear existing markers
        _markers.clear();

        // Add the new marker
        _markers.add(Marker(
          markerId: MarkerId(p.placeId!),
          position: LatLng(lat, lng),
        ));

        _markers = Set.of(_markers);
      });
      _panelController.open();
    } catch (e) {
      print("Error in _displayPrediction: $e");
    }
  }

  final PanelController _panelController = PanelController();
  //final _titles = ['Report Warning','Report Crash', 'Q&A'];
  //final _icons = [Icons.warning, Icons.car_crash, Icons.question_answer ];
  TextEditingController _textFieldController = TextEditingController();

  String action = 'Choose an action';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              final p = await PlacesAutocomplete.show(
                context: context,
                apiKey: "AIzaSyA-IdEbSqz6C8NL0-RLzPF-17Byi5cIxNE",
                mode: Mode.overlay,
                language: "en",
                components: [gmaps.Component(gmaps.Component.country, "us")],
              );
              await _displayPrediction(p);
            },
          ),
          IconButton(
            icon: Icon(Icons.warning),
            onPressed: () async {
              if (!reportList.isEmpty) _showBottomSheet(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(userId),
              accountEmail: Text(userEmail),
              currentAccountPicture: CircleAvatar(
                backgroundColor:
                    Theme.of(context).platform == TargetPlatform.iOS
                        ? Colors.amberAccent
                        : Colors.white,
                child: Text(
                  userId.isNotEmpty ? userId.substring(0, 1) : "A",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              title: Text('Sign out'),
              onTap: _signOut,
            ),
            ListTile(
              title: Text('Route History'),
              onTap: () => Get.to(RouteHistory()),
            ),
            ListTile(
              title: Text('User Settings'),
              onTap: () => Get.to(UserSettings()),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            polylines: _polylines,
            onMapCreated: (controller) {
              mapController = controller;
              if (_currentUserLocation != null) {
                mapController
                    .moveCamera(CameraUpdate.newLatLng(_currentUserLocation!));
              }
            },
            initialCameraPosition: CameraPosition(
              target: _currentUserLocation ?? _center,
              zoom: 15.0,
            ),
            markers: _markers,
            onLongPress: (LatLng position) {
              log("Message from long press: " +
                  position.latitude.toString() +
                  " " +
                  position.longitude.toString());
            },
            onTap: (LatLng position) async {
              if (_panelController.isPanelOpen) {
                _panelController.close();
                setState(() {
                  isCollapsed = true;
                });
              }
            },
          ),
          SlidingUpPanel(
            controller: _panelController,
            onPanelSlide: (double position) {
              if (position == 0 && !isCollapsed) {
                setState(() {
                  isCollapsed = true;
                });
              } else if (position > 0 && isCollapsed) {
                setState(() {
                  isCollapsed = false;
                });
              }
            },
            panel: Padding(
              padding: const EdgeInsets.all(15.0),
              child: IgnorePointer(
                ignoring: isCollapsed,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedPlaceDetails?.name ?? "No Location Selected",
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      _selectedPlaceDetails?.formattedAddress ?? "",
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_selectedPlaceDetails?.geometry?.location !=
                                    null) {
                                  final route = await getWalkingDirections(
                                      _currentUserLocation ?? _center,
                                      LatLng(
                                          _selectedPlaceDetails!
                                              .geometry!.location.lat,
                                          _selectedPlaceDetails!
                                              .geometry!.location.lng));
                                  setState(() {
                                    _polylines.clear();
                                    _polylines.add(Polyline(
                                      polylineId: PolylineId(
                                          _selectedPlaceDetails?.placeId ??
                                              "0"),
                                      color: Colors.blue,
                                      width: 3,
                                      points: route,
                                    ));
                                    _polylines = Set.of(_polylines);
                                  });
                                }
                              },
                              child: Text("Get Directions"),
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blue,
                                onPrimary: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              await _displayTextInputDialog(context);
                              if (_panelController.isPanelOpen) {
                                _panelController.close();
                                setState(() {
                                  isCollapsed = true;
                                });
                              }
                            },
                            child: Text("Report Warning"),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red[300],
                              onPrimary: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            minHeight: 50.0,
            maxHeight: 250.0,
          ),
        ],
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Warning'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Write your message here"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                //addWarningMark=false;
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                reportList.add(Report(
                    message: _textFieldController.text, latLng: LatLng(0, 0)));
                //addWarningMark=true;
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              for (Report r in reportList)
                Card(
                  child: ListTile(
                    title: Text("Warning"),
                    subtitle: Text(r.message),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class Report {
  String message;
  LatLng latLng;
  Report({
    required this.message,
    required this.latLng,
  });
}
