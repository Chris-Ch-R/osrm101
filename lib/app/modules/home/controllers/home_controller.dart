import 'dart:convert';

import 'package:facgure_test/app/data/constansts/app_constanst.dart';
import 'package:facgure_test/app/data/models/store/route_model.dart';
import 'package:facgure_test/app/data/models/store/store_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  RxList<MockStore> mockStoreList = <MockStore>[
    MockStore(
        name: "ตี๋น้อยเกษตรนวมิน",
        location: const LatLng(13.84229301809948, 100.59438126622193),
        ratting: 4.8,
        img: "https://img.salehere.co.th/p/1200x0/2020/07/31/qok09ctiq3mm.jpg"),
    MockStore(
        name: "Starbucks คณะวิทย์",
        location: const LatLng(13.845889276916933, 100.57238716665881),
        ratting: 4.7,
        img:
            "https://img.wongnai.com/p/400x0/2022/05/07/867f47487b9b4dfe8f6d9b6acf26f8b3.jpg"),
    MockStore(
        name: "ร้านพี่กร ม. เกษตร บางเขน",
        location: const LatLng(13.838488079687378, 100.5693814911483),
        ratting: 4.6,
        img:
            "https://img.wongnai.com/p/1920x0/2022/03/09/a6c933098d9b484a93c1a7dabb21e78e.jpg"),
    MockStore(
        name: "SamuraiSiam",
        location: const LatLng(13.855986711601625, 100.57889510623694),
        ratting: 4.0,
        img:
            "https://lh5.googleusercontent.com/p/AF1QipPljMfLdaliS1fFIsTVP5S81IHAX95s6aLpNjlA=w408-h613-k-no"),
    MockStore(
        name: "บีบี ผ้ามือสอง",
        location: const LatLng(13.85658150720071, 100.58256842239115),
        ratting: 3.0,
        img:
            "https://streetviewpixels-pa.googleapis.com/v1/thumbnail?panoid=YphiYYgeN9gfbC0xZyYsmA&cb_client=search.gws-prod.gps&w=408&h=240&yaw=323.39224&pitch=0&thumbfov=100"),
    MockStore(
        name: "Nara Cafe",
        location: const LatLng(13.85099410500945, 100.58187439860363),
        ratting: 4.9,
        img:
            "https://lh5.googleusercontent.com/p/AF1QipMjsG8lgrA14sLMoa7RCdXrWD5Asx7l-THF5L_a=w408-h306-k-no"),
  ].obs;

  RxInt? selectedChoice = 0.obs;

  Position? currentLocation;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<Set<Polyline>> getPolyline(latitude, longtitude) async {
    RoutesModel route = await _getRoute(latitude, longtitude);
    String encodedPolyline = route.routes![0].geometry!;
    Map<PolylineId, Polyline> polylines = {};
    List<LatLng> polylineCoordinates = [];
    List<PointLatLng> result = PolylinePoints().decodePolyline(encodedPolyline);
    result.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        width: 3,
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates);
    polylines[id] = polyline;
    return Set<Polyline>.of(polylines.values);
  }

  Future<RoutesModel> _getRoute(latitude, longtitude) async {
    currentLocation = await _getCurrentPosition();
    final response = await http.get(
      Uri.parse(
          '${AppConstanst.url}/${currentLocation!.longitude},${currentLocation!.latitude};$longtitude,$latitude'),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return RoutesModel.fromJson(jsonDecode(response.body));
    } else {
      Map valueMap = json.decode(response.body);
      throw Exception(valueMap['code']);
    }
  }

  Future<double?> getDistance(index, latitude, longtitude) async {
    try {
      RoutesModel route = await _getRoute(latitude, longtitude);
      mockStoreList[index].distance = route.routes![0].distance!.toDouble();
      return route.routes![0].distance!.toDouble();
    } catch (error) {
      print(error.toString());
    }
    return null;
  }

  void sortDistanceASC() {
    mockStoreList.sort((a, b) => b.distance.compareTo(a.distance));
  }

  void sortDistanceDESC() {
    mockStoreList.sort((a, b) => a.distance.compareTo(b.distance));
  }

  void sortRattingASC() {
    mockStoreList.sort((a, b) => b.ratting.compareTo(a.ratting));
  }

  void sortRattingDESC() {
    mockStoreList.sort((a, b) => a.ratting.compareTo(b.ratting));
  }
}
