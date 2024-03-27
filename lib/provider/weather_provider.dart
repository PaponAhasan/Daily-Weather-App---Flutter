import 'dart:convert';

import 'package:daily_weather_app/models/current_weather.dart';
import 'package:daily_weather_app/models/forecast_weather.dart';
import 'package:daily_weather_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  // static const lat = 23.8103;
  // static const lon = 90.4125;
  double _latitude = 0.0;
  double _longitude = 0.0;

  String unit = metric;
  CurrentWeather? currentWeather;
  ForecastWeather? forecastWeather;

  bool get isLoaded => currentWeather != null && forecastWeather != null;

  setNewLocation(double lat, double lon) {
    _latitude = lat;
    _longitude = lon;
  }

  setTempUnit(bool tag) {
    unit = tag ? imperial : metric;
  }

  String get tempUnitSymbol => unit == metric ? celsius : fahrenheit;

  Future<String> convertCityToCoordinates(String city) async {
    try {
      final locationList = await locationFromAddress(city);
      if(locationList.isNotEmpty) {
        final location = locationList.first;
        setNewLocation(location.latitude, location.longitude);
        getData();
        return 'Fetching data for $city';
      }else{
        return 'Could not find city';
      }
    }catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      return error.toString();
    }
  }

  getData() {
    _getCurrentWeather();
    _getForecastWeather();
  }

  Future<void> _getCurrentWeather() async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$_latitude&lon=$_longitude&units=$unit&appid=$weatherApiKey');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final map = jsonDecode(response.body);
        currentWeather = CurrentWeather.fromJson(map);
        if (kDebugMode) {
          print(currentWeather?.main?.temp);
        }
        notifyListeners();
      } else {
        final map = jsonDecode(response.body);
        if (kDebugMode) {
          print(map['message']);
        }
        throw Exception('Failed to load weather');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
    notifyListeners();
  }

  Future<void> _getForecastWeather() async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$_latitude&lon=$_longitude&units=$unit&appid=$weatherApiKey');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final map = jsonDecode(response.body);
        forecastWeather = ForecastWeather.fromJson(map);
        if (kDebugMode) {
          print(forecastWeather?.list?.length);
        }
        notifyListeners();
      } else {
        final map = jsonDecode(response.body);
        if (kDebugMode) {
          print(map['message']);
        }
        throw Exception('Failed to load weather');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
    }
    notifyListeners();
  }
}
