import 'package:daily_weather_app/pages/SettingPage.dart';
import 'package:daily_weather_app/provider/weather_provider.dart';
import 'package:daily_weather_app/utils/constants.dart';
import 'package:daily_weather_app/utils/helper.dart';
import 'package:daily_weather_app/utils/location_service.dart';
import 'package:daily_weather_app/widgets/current_section.dart';
import 'package:daily_weather_app/widgets/forecast_section.dart';
import 'package:daily_weather_app/widgets/parallax_background.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  late WeatherProvider provider;

  @override
  didChangeDependencies() {
    provider = Provider.of<WeatherProvider>(context, listen: false);
    // Provider.of<WeatherProvider>(context, listen: false).getCurrentWeather();
    // Provider.of<WeatherProvider>(context, listen: false).getForecastWeather();
    getCurrentLocation();
    super.didChangeDependencies();
  }

  getCurrentLocation() async {
    final location = await determinePosition();
    provider.setNewLocation(location.latitude, location.longitude);
    provider.setTempUnit(await getTempStatus());
    provider.getData();
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
              onPressed: () {
                showSearch(context: context, delegate: _CitySearchDelegate())
                    .then((value) {
                  if (value != null && value.isNotEmpty) {
                    provider
                        .convertCityToCoordinates(value)
                        .then((value) => showMsg(context, value));

                    if (kDebugMode) {
                      print(value);
                    }
                  }
                });
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                getCurrentLocation();
              },
              icon: const Icon(Icons.my_location),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()));
              },
              icon: const Icon(Icons.settings),
            )
          ],
        ),
        body: Consumer<WeatherProvider>(
          builder: (context, provider, child) => provider.isLoaded
              ? Stack(
                children: [
                  const ParallaxBackground(),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                          CurrentSection(
                            currentWeather: provider.currentWeather!,
                            unitSymbol: provider.tempUnitSymbol,
                          ),
                          ForecastSection(
                            items: provider.forecastWeather!.list!,
                            unitSymbol: provider.tempUnitSymbol,
                          )
                        ]),
                ],
              )
              : const Center(child: CircularProgressIndicator()),
        ));
  }
}

class _CitySearchDelegate extends SearchDelegate<String> {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, '');
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, '');
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.search),
      title: Text(query),
      onTap: () {
        close(context, query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filterList = query.isEmpty
        ? cities
        : cities
            .where((element) =>
                element.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
        itemCount: filterList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              close(context, filterList[index]);
            },
            title: Text(filterList[index]),
          );
        });
  }
}
