import 'package:flutter/material.dart';

class WeatherInfo extends StatelessWidget {
  const WeatherInfo(
      {super.key,
      required this.title,
      required this.value,
      required this.border});
  final String title;
  final String value;
  final bool border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border: Border(
          right: border
              ? BorderSide(color: Colors.grey.shade500, width: 1)
              : BorderSide.none,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            softWrap: true,
          ),
          Text(value),
        ],
      ),
    );
  }
}
