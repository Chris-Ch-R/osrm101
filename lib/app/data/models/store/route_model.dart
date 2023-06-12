class RoutesModel {
  String? code;
  List<Routes>? routes;
  List<Waypoints>? waypoints;

  RoutesModel({this.code, this.routes, this.waypoints});

  RoutesModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['routes'] != null) {
      routes = <Routes>[];
      json['routes'].forEach((v) {
        routes!.add(new Routes.fromJson(v));
      });
    }
    if (json['waypoints'] != null) {
      waypoints = <Waypoints>[];
      json['waypoints'].forEach((v) {
        waypoints!.add(new Waypoints.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.routes != null) {
      data['routes'] = this.routes!.map((v) => v.toJson()).toList();
    }
    if (this.waypoints != null) {
      data['waypoints'] = this.waypoints!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Routes {
  String? geometry;
  String? weightName;
  double? weight;
  double? duration;
  double? distance;

  Routes(
      {this.geometry,
      this.weightName,
      this.weight,
      this.duration,
      this.distance});

  Routes.fromJson(Map<String, dynamic> json) {
    geometry = json['geometry'];
    weightName = json['weight_name'];
    weight = json['weight'].toDouble();
    duration = json['duration'].toDouble();
    distance = json['distance'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['geometry'] = this.geometry;
    data['weight_name'] = this.weightName;
    data['weight'] = this.weight;
    data['duration'] = this.duration;
    data['distance'] = this.distance;
    return data;
  }
}

class Waypoints {
  String? hint;
  double? distance;
  String? name;
  List<double>? location;

  Waypoints({this.hint, this.distance, this.name, this.location});

  Waypoints.fromJson(Map<String, dynamic> json) {
    hint = json['hint'];
    distance = json['distance'];
    name = json['name'];
    location = json['location'].cast<double>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['hint'] = this.hint;
    data['distance'] = this.distance;
    data['name'] = this.name;
    data['location'] = this.location;
    return data;
  }
}
