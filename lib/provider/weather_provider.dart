import 'dart:convert';

import 'package:daily_weather_app/models/current_weather.dart';
import 'package:daily_weather_app/models/forecast_weather.dart';
import 'package:daily_weather_app/utils/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class WeatherProvider extends ChangeNotifier {
  static const lat = 23.8103;
  static const lon = 90.4125;
  String unit = metric;
  CurrentWeather? currentWeather;
  ForecastWeather? forecastWeather;

  Future<void> getCurrentWeather() async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=$unit&appid=$weatherApiKey');
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

  Future<void> getForecastWeather() async {
    final uri = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=$unit&appid=$weatherApiKey');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final map = jsonDecode(response.body);
        forecastWeather = ForecastWeather.fromJson(map);
        if (kDebugMode) {
          print(forecastWeather?.list?.length);
        }notifyListeners();
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
