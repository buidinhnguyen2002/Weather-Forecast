import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/models/hour_forecast.dart';
import 'package:weather_dashboard/models/weather_data.dart';
import 'package:weather_dashboard/providers/weather_forecast_provider.dart';
import 'package:weather_dashboard/utils/constants.dart';
import 'package:weather_dashboard/widgets/weather_info.dart';

class WeatherDetailDialog extends StatefulWidget {
  const WeatherDetailDialog(
      {super.key, required this.date, required this.location});
  final String date;
  final String location;

  @override
  State<WeatherDetailDialog> createState() => _WeatherDetailDialogState();
}

class _WeatherDetailDialogState extends State<WeatherDetailDialog> {
  int row = 2;
  late WeatherData weatherData;

  late int hour;
  @override
  void initState() {
    DateTime now = DateTime.now();
    hour = now.hour;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    weatherData = Provider.of<WeatherForecastProvider>(context, listen: false)
        .finWeatherByLocation(widget.location, widget.date);
    super.didChangeDependencies();
  }

  void _changeHour(int hour) {
    setState(() {
      this.hour = hour;
    });
  }

  HourForecast getHourForecastByHour() {
    return weatherData.hourForecasts.firstWhere((forecast) {
      DateTime weatherDate = DateTime.parse(forecast.time);
      return weatherDate.hour == hour;
    });
  }

  @override
  Widget build(BuildContext context) {
    HourForecast hourForecast = getHourForecastByHour();
    final deviceSize = MediaQuery.of(context).size;
    if (deviceSize.width > 600) row = 2;
    if (deviceSize.width < 600) row = 3;
    if (deviceSize.width < 400) row = 4;
    return AlertDialog(
      backgroundColor: AppColors.white,
      content: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              weatherData.location,
              style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              hourForecast.time,
              style: GoogleFonts.rubik(color: Colors.black),
            ),
            BoxEmpty.sizeBox25,
            Row(
              children: [
                Image.network(
                  hourForecast.icon,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${hourForecast.tempC} °C",
                      style:
                          GoogleFonts.rubik(color: Colors.black, fontSize: 25),
                    ),
                    Text(hourForecast.textCondition),
                  ],
                ),
              ],
            ),
            BoxEmpty.sizeBox20,
            Row(
              children: [
                if (deviceSize.width < 600)
                  Column(
                    children: [
                      WeatherInfo(
                        title: "Humidity",
                        value: "${hourForecast.humidity}%",
                        border: false,
                      ),
                      BoxEmpty.sizeBox10,
                      WeatherInfo(
                        title: "Wind",
                        value: "${hourForecast.windKph} m/s",
                        border: false,
                      ),
                    ],
                  ),
                if (deviceSize.width > 600) ...[
                  WeatherInfo(
                    title: "Humidity",
                    value: "${hourForecast.humidity}%",
                    border: true,
                  ),
                  WeatherInfo(
                    title: "Wind",
                    value: "${hourForecast.windKph} m/s",
                    border: true,
                  ),
                ],
                if (deviceSize.width < 600)
                  Column(
                    children: [
                      WeatherInfo(
                        title: "	Precipitation",
                        value: "${hourForecast.precipMm} mm",
                        border: false,
                      ),
                      BoxEmpty.sizeBox10,
                      WeatherInfo(
                        title: "Độ ẩm",
                        value: "${hourForecast.chanceOfRain} %",
                        border: false,
                      ),
                    ],
                  ),
                if (deviceSize.width > 600) ...[
                  WeatherInfo(
                    title: "	Precipitation amount",
                    value: "${hourForecast.precipMm} mm",
                    border: true,
                  ),
                  WeatherInfo(
                    title: "Độ ẩm",
                    value: "${hourForecast.chanceOfRain} %",
                    border: false,
                  ),
                ]
              ],
            ),
            BoxEmpty.sizeBox20,
            ...List.generate(row, (indexRow) {
              int column = 24 ~/ row;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(column, (indexCol) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: "${indexRow * column + indexCol}:00",
                          child: InkWell(
                            onTap: () {
                              _changeHour(indexRow * column + indexCol);
                            },
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.blue,
                              child: Text(
                                '${indexRow * column + indexCol}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (indexCol != column - 1)
                          Container(
                            height: 2,
                            width: 10,
                            color: Colors.grey,
                          ),
                      ],
                    ),
                  );
                }),
              );
            }),
          ],
        ),
      ),
    );
  }
}
