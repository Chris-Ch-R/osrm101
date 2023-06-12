import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MockStore {
  String name;
  LatLng location;
  double ratting;
  double distance = 0.0;
  String? img;

  MockStore(
      {Key? key,
      required this.name,
      required this.location,
      required this.ratting,
      this.img});
}
