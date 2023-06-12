import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../controllers/store_detail_controller.dart';

class StoreDetailView extends GetView<StoreDetailController> {
  const StoreDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StoreDetailView'),
        centerTitle: true,
      ),
      body: Column(
        children: [_buildGoogleMap(), _buildPanel()],
      ),
    );
  }

  Widget _buildPanel() {
    return Container(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: 150,
            height: 150,
            child: Image.network(Get.arguments["destination"].img),
          ),
          RatingBarIndicator(
            rating: Get.arguments["destination"].ratting,
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
          ),
          Text(
            Get.arguments["destination"].name,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
              "distance ${(Get.arguments["destination"].distance! / 1000).toStringAsFixed(2)} km"),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMap() {
    final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();
    return Expanded(
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: Get.arguments["currentLocation"], zoom: 14.0),
        polylines: Get.arguments["polyline"],
        onMapCreated: (GoogleMapController googleMapController) {
          _controller.complete(googleMapController);
          // showMarkerInfo
          googleMapController.showMarkerInfoWindow(const MarkerId("current"));
          googleMapController
              .showMarkerInfoWindow(const MarkerId("destination"));

          LatLngBounds bounds;
          if (Get.arguments["currentLocation"].latitude >
              Get.arguments["destination"].location.latitude) {
            print("cur > desti");
            bounds = LatLngBounds(
                southwest: LatLng(
                    Get.arguments["currentLocation"].latitude -
                        (Get.arguments["currentLocation"].latitude -
                            Get.arguments["destination"].location.latitude),
                    Get.arguments["currentLocation"].longitude),
                northeast: LatLng(
                    Get.arguments["destination"].location.latitude +
                        (Get.arguments["currentLocation"].latitude -
                            Get.arguments["destination"].location.latitude),
                    Get.arguments["destination"].location.longitude));
          } else {
            bounds = LatLngBounds(
                southwest: Get.arguments["currentLocation"],
                northeast: Get.arguments["destination"].location);
          }

          LatLng centerBounds = LatLng(
              (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
              (bounds.northeast.longitude + bounds.southwest.longitude) / 2);
          googleMapController
              .moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: centerBounds,
            zoom: 20,
          )));
          Get.put(StoreDetailController())
              .zoomToFit(googleMapController, bounds, centerBounds);
        },
        markers: {
          Marker(
              markerId: const MarkerId('current'),
              position: Get.arguments["currentLocation"],
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueCyan),
              infoWindow: const InfoWindow(title: "ตำแหน่งของคุณ")),
          Marker(
            markerId: const MarkerId('destination'),
            position: Get.arguments["destination"].location,
            infoWindow: InfoWindow(title: Get.arguments["destination"].name),
          ),
        },
      ),
    );
  }
}
