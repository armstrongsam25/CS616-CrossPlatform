import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:get/get.dart';
import 'package:Skywalk/views/login_page/login_page.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late GoogleMapController mapController;
  late GoogleMapsPlaces _places;
  final LatLng _center = const LatLng(37.422060, -122.084057);
  Set<Marker> _markers = {};
  String userId = '';
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _places =
        GoogleMapsPlaces(apiKey: "AIzaSyA-IdEbSqz6C8NL0-RLzPF-17Byi5cIxNE");
    _fetchUserId();
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

  Future<void> _displayPrediction(Prediction? p) async {
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
      print(p.description);
      print(lat);
      print(lng);

      // Move the camera to the location
      mapController.moveCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
      // Optionally add a marker on the location
      setState(() {
        // This assumes you have a markers Set declared in your state
        _markers.add(Marker(
          markerId: MarkerId(p.placeId!), // A unique id for each marker
          position: LatLng(lat, lng),
        ));
      });
    } catch (e) {
      print("Error in _displayPrediction: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              try {
                final p = await PlacesAutocomplete.show(
                  context: context,
                  apiKey: "AIzaSyA-IdEbSqz6C8NL0-RLzPF-17Byi5cIxNE",
                  mode: Mode.overlay,
                  language: "en",
                  components: [Component(Component.country, "us")],
                );

                await _displayPrediction(p);
              } catch (e) {
                print("Error: $e");
              }
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
          ],
        ),
      ),
      body: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.0,
        ),
        markers: _markers,
      ),
    );
  }
}
