import 'dart:convert';
import 'package:http/http.dart' as http;

const googleMapsApikey = 'AIzaSyAb8klaM40PhwiXJi6zR1sXGSQp7Wi16ek';

class LocationHelper {
  static Future<String> getPlaceAddress(double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleMapsApikey ');

    final response = await http.get(url);
    if (response.body.isEmpty) {
      return 'Place unknown';
    } else {
      return json.decode(response.body)[0]['results']['formatted_address'];
    }
  }
}
