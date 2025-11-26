import 'package:http/http.dart' as http;
import 'dart:convert';

class driveAPIService {
  final String accessToken =
      "pk.eyJ1IjoiYmlnYWxmMTIzNCIsImEiOiJjbWlldGtieXAwNmRnM2RyMTM2MTYxY3kyIn0.WXE5ObH-g8765iNvqpFL9g";

  Future<double?> getTravelTime(String start, String end) async {
    final url =
        'https://api.mapbox.com/directions/v5/mapbox/driving-traffic/'
        '$start;$end?geometries=geojson&overview=full&access_token=$accessToken';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final duration = data["routes"][0]["duration"]; // seconds
      return duration / 60; // minutes
    } else {
      return null;
    }
  }
}

class GeocodingService {
  final String accessToken;

  GeocodingService(this.accessToken);

  /// Returns [longitude, latitude] as a List<double>
  Future<List<double>?> forwardGeocode(String query) async {
    final url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/"
        "${Uri.encodeComponent(query)}.json"
        "?access_token=$accessToken&limit=1";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data["features"].isEmpty) {
        return null; // no match
      }

      final coords = data["features"][0]["geometry"]["coordinates"];
      return [coords[0], coords[1]]; // lon, lat
    }

    return null;
  }
}
