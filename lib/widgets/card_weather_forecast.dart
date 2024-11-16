import 'package:flutter/material.dart';

class CardWeatherForecast extends StatelessWidget {
  const CardWeatherForecast(
      {super.key,
      required this.date,
      required this.temperature,
      required this.wind,
      required this.humidity,
      required this.textCondition,
      required this.icon,
      required this.width,
      required this.onPress});
  final String date;
  final double temperature;
  final double wind;
  final int humidity;
  final String textCondition;
  final String icon;
  final double width;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        width: width,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "($date)",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(
              height: 9,
            ),
            Image.network(
              icon,
              fit: BoxFit.cover,
              width: 40,
            ),
            const SizedBox(
              height: 9,
            ),
            Text(
              "Temperature: $temperature °C",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 9,
            ),
            Text(
              "Wind: $wind M/S",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 9,
            ),
            Text(
              "Humidity: $humidity %",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(
              height: 9,
            ),
          ],
        ),
      ),
    );
  }
}
