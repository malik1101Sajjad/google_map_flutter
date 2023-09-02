import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  MapType _currentMapType = MapType.normal;
  late GoogleMapController mapController;

  Position? _currentPosition;
  double zoom = 15;

  //Change Map Type
  void _onMapTypeButtonPress() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.hybrid : MapType.normal;
    });
  }

//current Location
  void _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permission denied';
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
      });

      if (_currentPosition != null) {
        mapController.animateCamera(
          CameraUpdate.newLatLngZoom(
              LatLng(
                _currentPosition!.latitude,
                _currentPosition!.longitude,
              ),
              zoom = 18),
        );
      }
    } catch (e) {
      '$e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          GoogleMap(
            mapType: _currentMapType,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                mapController = controller;
              });
            },
            initialCameraPosition: CameraPosition(
                target: LatLng(_currentPosition?.latitude ?? 29.355787699320555,
                    _currentPosition?.longitude ?? 71.69159327364335),
                zoom: zoom),
          ),
          SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: SearchMapPlaceWidget(
                      apiKey: 'AIzaSyCICMJRt-pqrMXohC84WQOfAvF8gmnEC2o',
                      bgColor: Colors.white,
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      onSelected: (place) async {
                        Geolocation? geolocation = await place.geolocation;
                        mapController.animateCamera(
                            CameraUpdate.newLatLng(geolocation!.coordinates));
                        mapController.animateCamera(
                            CameraUpdate.newLatLngBounds(
                                geolocation.bounds, 0));
                      },
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: () {
                            _onMapTypeButtonPress();
                          },
                          child: const Icon(Icons.layers_outlined)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          _getCurrentLocation();
        },
        child: const Icon(Icons.my_location),
      ),
    );
  }
}


/*
  final List<Marker> _marker = [];
  int id = 1;
  final List<Marker> _list = const [
    Marker(
        markerId: MarkerId('1'),
        position: _firstLocation,
        infoWindow: InfoWindow(title: 'My Location', snippet: 'Bahawalpur')),
    Marker(
        markerId: MarkerId('2'),
        position: _secondLocation,
        infoWindow:
            InfoWindow(title: 'My Park Location', snippet: 'Bahawalpur'))
  ];
  onTap: (LatLng latLng) {
              Marker markers = Marker(
                  markerId: MarkerId('$id'),
                  position: LatLng(latLng.latitude, latLng.longitude),
                  infoWindow: const InfoWindow(title: 'My New Add Location'),
                  icon: BitmapDescriptor.defaultMarker);
              _marker.add(markers);
              id = id + 1;
              setState(() {});
            },
            markers: _marker.map((e) => e).toSet(), 
  */