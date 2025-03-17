import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final List<dynamic> locations;
  const MapPage({super.key, required this.locations});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final LatLng _initialPosition = const LatLng(39.925533, 32.866287); // Ankara

  Set<Marker> _createMarkers() {
    Set<Marker> markers = {};
    for (var location in widget.locations) {
      if (location['latitude'] != null && location['longitude'] != null) {
        markers.add(
          Marker(
            markerId: MarkerId(location['city']),
            position: LatLng(
              double.parse(location['latitude'].toString()),
              double.parse(location['longitude'].toString()),
            ),
            infoWindow: InfoWindow(title: location['city']),
          ),
        );
      }
    }
    return markers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clinical Trials Map')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 5),
        markers: _createMarkers(),
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
