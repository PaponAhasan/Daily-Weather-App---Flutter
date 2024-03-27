import 'package:daily_weather_app/models/forecast_weather.dart';
import 'package:daily_weather_app/utils/constants.dart';
import 'package:daily_weather_app/utils/helper.dart';
import 'package:flutter/material.dart';

class ForecastSection extends StatelessWidget {
  final List<ForecastItem> items;
  final String unitSymbol;

  const ForecastSection({super.key, required this.items, required this.unitSymbol});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return AspectRatio(
              aspectRatio: 1 / 1,
              child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          Text(
                            getFormattedDateTime(item.dt!,
                                pattern: "EEE HH:mm"),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${item.main!.tempMax!.round()}$unitSymbol/${item.main!.tempMin!.round()}$unitSymbol',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          Expanded(
                            child: Image.network(
                                '$prefixWeatherIconUrl${item.weather![0].icon}$suffixWeatherIconUrl',
                                width: 50,
                                height: 50),
                          ),
                          Text(
                            '${item.weather![0].description}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  )));
        },
      ),
    ));
  }
}
