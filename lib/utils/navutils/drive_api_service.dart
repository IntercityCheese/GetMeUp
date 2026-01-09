import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DriveAPIService {
  final String accessToken =
      "YOURAPIKEY";

  /// Returns travel time in minutes between two points (lng,lat)
  Future<double?> getTravelTime(String start, String end) async {
    try {
      final url =
          'https://api.mapbox.com/directions/v5/mapbox/driving-traffic/'
          '$start;$end?geometries=geojson&overview=full&access_token=$accessToken';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg: "Routing API error: ${response.statusCode}",
        );
        return null;
      }

      final data = jsonDecode(response.body);

      if (data["routes"] == null || data["routes"].isEmpty) {
        Fluttertoast.showToast(msg: "No route found between these points");
        return null;
      }

      final duration = data["routes"][0]["duration"];
      if (duration == null) {
        Fluttertoast.showToast(msg: "Route duration not available");
        return null;
      }

      return (duration as num) / 60; // seconds → minutes
    } catch (e) {
      Fluttertoast.showToast(msg: "Routing service error: $e");
      return null;
    }
  }
}

class GeocodingService {
  final String accessToken;

  GeocodingService(this.accessToken);

  /// Returns [longitude, latitude] as a List<double>
  Future<List<double>?> forwardGeocode(String query) async {
    try {
      final url =
          "https://api.mapbox.com/geocoding/v5/mapbox.places/"
          "${Uri.encodeComponent(query + ', UK')}.json"
          "?access_token=$accessToken&limit=1";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        Fluttertoast.showToast(
          msg: "Geocoding API error: ${response.statusCode}",
        );
        return null;
      }

      final data = jsonDecode(response.body);

      if (data["features"] == null || data["features"].isEmpty) {
        Fluttertoast.showToast(msg: "Could not find coordinates for '$query'");
        return null;
      }

      final coords = data["features"][0]["geometry"]["coordinates"];
      if (coords == null || coords.length < 2) {
        Fluttertoast.showToast(
          msg: "Invalid coordinates returned for '$query'",
        );
        return null;
      }

      return [coords[0], coords[1]]; // lon, lat
    } catch (e) {
      Fluttertoast.showToast(msg: "Geocoding service error: $e");
      return null;
    }
  }
}
