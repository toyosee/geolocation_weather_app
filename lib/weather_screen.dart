import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:weather_app/additional_info_item.dart';
import 'package:weather_app/hourly_forecast_item.dart';
import 'package:weather_app/location_service.dart';
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;
  String cityName = 'London'; // Default fallback city
  final LocationService locationService = LocationService();

  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    try {
      String apiUrl =
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&APPID=$openWeatherApiKey';

      final res = await http.get(Uri.parse(apiUrl));
      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'Error: Unable to fetch weather data.';
      }
      return data;
    } catch (e) {
      throw 'Failed to fetch weather data: \nCheck your Internet and Try again.';
    }
  }

  Future<void> initializeLocationAndWeather() async {
    try {
      final Position position = await locationService.getCurrentLocation();
      cityName = await locationService.getCityFromCoordinates(
        position.latitude,
        position.longitude,
      );
    } catch (e) {
      cityName; // Fallback city
      // print('Fallback to $cityName. Error: $e');
    }

    setState(() {
      weather = fetchWeatherData(cityName);
    });
  }

  String convertToCelsius(double tempKelvin) {
    return (tempKelvin - 273.15).toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    initializeLocationAndWeather();
  }

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Weather App';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          appTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = fetchWeatherData(cityName);
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchWeatherData(cityName),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;
          final baseResult = data['list'][0];
          final currentTemp = baseResult['main']['temp'];
          final condition = baseResult['weather'][0]['main'];
          final humidity = baseResult['main']['humidity'];
          final windSpeed = baseResult['wind']['speed'];
          final pressure = baseResult['main']['pressure'];
          final actualCityName = cityName;

          final convertedTemp =
              convertToCelsius(double.parse(currentTemp.toString()));

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main weather card
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(actualCityName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                '$convertedTemp °C',
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Icon(
                                condition == 'Clouds' || condition == 'Rain'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 64,
                                color: Colors.cyan,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '$condition',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Hourly forecast card
                const Text(
                  '3 Hours Forecast',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),

                // Scrollable hourly forecast
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final hourlyForecast = data['list'][index + 1];
                      final DateTime time =
                          DateTime.parse(hourlyForecast['dt_txt'].toString());
                      return HourlyForcastItem(
                        time: DateFormat.j().format(time),
                        icon: hourlyForecast['weather'][0]['main'] ==
                                    'Clouds' ||
                                hourlyForecast['weather'][0]['main'] == 'Rain'
                            ? Icons.cloud
                            : Icons.sunny,
                        temperature:
                            '${convertToCelsius(double.parse(hourlyForecast['main']['temp'].toString()))} °C',
                      );
                    },
                  ),
                ),
                const SizedBox(height: 30),

                // Additional Information
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: '$humidity%',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: '$windSpeed km/h',
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: '$pressure hPa',
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
