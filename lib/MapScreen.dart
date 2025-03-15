import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'Navigations/appbar.dart';
import 'contact/Contact_screen.dart';

class MapScreen extends StatefulWidget {
  final Position userLocation;
  const MapScreen({Key? key, required this.userLocation}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Location _location = Location();
  LatLng _initialPosition = LatLng(28.6139, 77.2090); // Default to Delhi, India
  late Stream<LocationData> _locationStream;
  List<Marker> _markers = [];
  bool hasContacts = false; // Variable to track if contacts exist

  // Replace with your actual Google Maps API key
  final String _googleApiKey = 'AIzaSyAbBqiZ1L2UHiZhLGWxdaSPXHGSeuK23p8';

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _locationStream = _location.onLocationChanged;
  }

  Future<void> _getUserLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    final _currentLocation = await _location.getLocation();
    setState(() {
      _initialPosition = LatLng(_currentLocation.latitude!, _currentLocation.longitude!);
    });

    _fetchNearbyPoliceStations(_initialPosition);
  }

  // Fetch nearby police stations using Google Places API
  Future<void> _fetchNearbyPoliceStations(LatLng position) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=${position.latitude},${position.longitude}&radius=5000&type=police&key=$_googleApiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        List<Marker> markers = [];

        for (var result in data['results']) {
          final LatLng markerPosition = LatLng(
            result['geometry']['location']['lat'],
            result['geometry']['location']['lng'],
          );

          markers.add(
            Marker(
              markerId: MarkerId(result['place_id']),
              position: markerPosition,
              infoWindow: InfoWindow(
                title: result['name'],
                snippet: result['vicinity'],
              ),
            ),
          );
        }

        setState(() {
          _markers = markers;
        });
      } else {
        print('Error fetching police stations: ${data['status']}');
      }
    } else {
      print('Failed to fetch police stations. Status code: ${response.statusCode}');
    }
  }

  void _onLocationChanged(LocationData locationData) {
    final LatLng newPosition = LatLng(locationData.latitude!, locationData.longitude!);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _initialPosition = newPosition;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(newPosition),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          StreamBuilder<LocationData>(
            stream: _locationStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData) {
                final locationData = snapshot.data!;
                _onLocationChanged(locationData);
              }

              return GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 14.0,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                markers: Set<Marker>.of(_markers),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              );
            },
          ),
          Positioned(
            left: 0,
            right: 0,
            child: AddContactWidget(),
          ),
        ],
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onEditProfile: () {
        // Implement logic to refresh profile after editing if needed
      }),
      body: Center(
        child: Text('Contact Screen Content Here'),
      ),
    );
  }
}

class AddContactWidget extends StatelessWidget {
  const AddContactWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0, bottom: 15.0, left: 15.0, right: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Text(
                      'Add Contact',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 2.0),
                  Text(
                    'Add close contacts to share live location with',
                    style: TextStyle(
                      fontSize: 9,
                      fontFamily: 'Poppins',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) =>  ContactsScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(5),
                  backgroundColor: const Color(0xFFCE0450),
                  shape: const CircleBorder(),
                ),
                child: const Icon(Icons.person_add_rounded, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



