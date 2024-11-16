import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/providers/weather_forecast_provider.dart';
import 'package:weather_dashboard/screens/weather_detail_screen.dart';
import 'package:weather_dashboard/screens/weather_screen.dart';
import 'package:weather_dashboard/utils/theme.dart';

import 'providers/theme_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ThemeProvider()),
        ChangeNotifierProvider(create: (ctx) => WeatherForecastProvider()),
      ],
      child: MaterialApp(
        title: 'Weather Dashboard',
        theme: lightMode,
        home: const WeatherScreen(),
      ),
    );
  }
}
