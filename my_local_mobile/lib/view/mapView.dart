import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MapViewState();
  }
}

class _MapViewState extends State<MapView> {
  final MapController _mapController = MapController();
  static const double _defaultZoomLevel = 5;
  late LocationPermission permission;
  LatLng currentLatLng = LatLng(0.0, 0.0);

  bool isLocServiceEnabled = false;
  bool permissionGranted = false;

  @override
  void initState() {
    initLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: currentLatLng,
          zoom: _defaultZoomLevel,
        ),
        children: [
          TileLayer(
            minZoom: 2,
            maxZoom: 18,
            backgroundColor: Colors.black,
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
        ],
      ),
      Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 50.0,
            child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemExtent: 70.0,
                children: [
                  const Chip(label: Text('data')),
                  const Chip(label: Text('data')),
                  const Chip(label: Text('data')),
                ]),
          ))
    ]);
  }

  initLocation() async {
    isLocServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocServiceEnabled) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          log('Permissions are denied.');
        } else if (permission == LocationPermission.deniedForever) {
          log("'Permissions are permanently denied.");
        } else {
          permissionGranted = true;
        }
      } else {
        permissionGranted = true;
      }

      if (permissionGranted) {
        setState(() {
          log("Permissions granted");
          getLatLng();
        });
      }
    } else {
      log("Location is not enabled.");
    }
  }

  getLatLng() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentLatLng.latitude = position.latitude;
    currentLatLng.longitude = position.longitude;

    setState(() {
      _mapController.move(currentLatLng, _defaultZoomLevel);
    });
  }
}
