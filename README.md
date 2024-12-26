# weather_app

A simple and responsive weather application built with Flutter that provides current weather and hourly forecasts based on your location. The app fetches weather data from the OpenWeather API and supports features such as geolocation-based weather updates and a fallback city when location services are unavailable.

Features

    Current Weather: Displays the current temperature, weather condition, humidity, wind speed, and pressure.
    Hourly Forecast: Shows a scrollable hourly forecast with temperature and weather condition icons.
    Location-Based Weather: Automatically detects the user's current location and fetches weather information based on that.
    Fallback Location: In case of failure to fetch the user's location, the app will display weather for a default location (London).
    Weather Icons: Displays relevant weather icons based on the condition (sunny, cloudy, rainy, etc.).
    Additional Information: Provides details such as humidity, wind speed, and pressure.

## Getting Started

Installation
Prerequisites

Ensure you have the following tools installed:

    Flutter SDK: Download and install from flutter.dev.
    Dart SDK: Dart comes bundled with Flutter, so you don’t need to install it separately.
    Android Studio or VS Code for development.
    OpenWeather API Key: Sign up for an API key at OpenWeather.

Steps to Run the App

    Clone the repository:

git clone https://github.com/toyosee/geolocation_weather_app
cd weather-app

Install dependencies:

flutter pub get
- http
- geolocator
- intl

Add your OpenWeather API key:

In the lib/weather_screen.dart file, replace the placeholder with your API key:

const String openWeatherApiKey = 'YOUR_OPENWEATHER_API_KEY';

Run the app:

    flutter run

Permissions

The app requests permission to access the device’s location. If the user denies the permission, the app will default to the fallback city (London).

    Android: The app requests the following permissions in the AndroidManifest.xml:

<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

iOS: The app requests location access in the Info.plist file. Ensure the following keys are included:

    <key>NSLocationWhenInUseUsageDescription</key>
    <string>We need your location to fetch weather data.</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>We need your location to fetch weather data.</string>

Technologies Used

    Flutter: The framework for building the app.
    OpenWeather API: Provides the weather data.
    Geolocator Package: Used to fetch the device's location.
    Intl Package: To get rradable time formats


Contributing

Feel free to fork this repository, open issues, and send pull requests. Any contributions are welcome!

    Fork the repository.
    Clone your fork.
    Create a new branch for your feature or bugfix.
    Commit your changes.
    Push to your fork.
    Create a pull request with a description of your changes.

Flutter Resources
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
