import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:weather_app/secrets.dart';
import 'package:http/http.dart' as http;

class LocationService {
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them in your device settings.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied. Please grant permissions.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied. Please grant permissions via device settings.');
    }

    try {
      // Configure location settings
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      // Fetch the current position
      return await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );
    } catch (e) {
      throw Exception('Failed to fetch the location. Error: $e');
    }
  }

  // Provide a default fallback location
  Map<String, dynamic> getDefaultLocation() {
    return {
      'latitude': 51.5074, // Default latitude (e.g., London)
      'longitude': -0.1278, // Default longitude
      'city': 'London',
    };
  }

  // Get the city name from coordinates (use a geocoding API)
  // Future<String> getCityFromCoordinates(double latitude, double longitude) async {
  //   // Mocked API call or actual API integration (e.g., Google Geocoding API)
  //   // Replace this with actual API implementation
  //   return 'London';
  // }

  Future<String> getCityFromCoordinates(double latitude, double longitude) async {
  final String apiUrl =
      'http://api.openweathermap.org/geo/1.0/reverse?lat=$latitude&lon=$longitude&limit=1&appid=$openWeatherApiKey';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data.isNotEmpty) {
        return data[0]['name']; // City name
      } else {
        throw 'City not found for the provided coordinates';
      }
    } else {
      throw 'Failed to fetch data: ${response.statusCode}';
    }
  } catch (e) {
    // print('Error fetching city from coordinates: $e');
    return 'London'; // Fallback city
  }
}
}
