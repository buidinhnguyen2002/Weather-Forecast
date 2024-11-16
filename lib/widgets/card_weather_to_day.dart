import 'package:flutter/material.dart';
import 'package:weather_dashboard/utils/constants.dart';

class CardWeatherToDay extends StatelessWidget {
  const CardWeatherToDay(
      {super.key,
      required this.location,
      required this.date,
      required this.temperature,
      required this.wind,
      required this.humidity,
      required this.textCondition,
      required this.icon,
      required this.onPress});
  final String location;
  final String date;
  final double temperature;
  final double wind;
  final int humidity;
  final String textCondition;
  final String icon;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$location ($date)",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Temperature: $temperature °C",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Wind: $wind M/S",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Humidity: $humidity %",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.network(
                  icon,
                  fit: BoxFit.cover,
                  width: 70,
                ),
                Text(
                  textCondition,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
            BoxEmpty.sizeBox20,
          ],
        ),
      ),
    );
  }
}
