import 'package:daily_weather_app/pages/SettingPage.dart';
import 'package:daily_weather_app/provider/weather_provider.dart';
import 'package:daily_weather_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  @override
  didChangeDependencies() {
    Provider.of<WeatherProvider>(context, listen: false).getCurrentWeather();
    Provider.of<WeatherProvider>(context, listen: false).getForecastWeather();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Daily Weather'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.my_location),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const SettingPage()));
            },
            icon: const Icon(Icons.settings),
          )
        ],
      ),
      body: const Center(

      )
    );
  }
}
