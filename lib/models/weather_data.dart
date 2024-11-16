import 'package:weather_dashboard/models/hour_forecast.dart';

class WeatherData {
  final String location;
  final String date;
  final double maxTempC;
  final double minTempC;
  final double avgTempC;
  final double maxTempF;
  final double minTempF;
  final double avgTempF;
  final double maxWindKph;
  final double totalPrecipMm;
  final int avgHumidity;
  final int dailyChanceOfRain;
  final String textCondition;
  final String icon;
  final List<HourForecast> hourForecasts;

  WeatherData({
    required this.location,
    required this.date,
    required this.maxTempC,
    required this.minTempC,
    required this.avgTempC,
    required this.maxTempF,
    required this.minTempF,
    required this.avgTempF,
    required this.maxWindKph,
    required this.totalPrecipMm,
    required this.avgHumidity,
    required this.dailyChanceOfRain,
    required this.textCondition,
    required this.icon,
    required this.hourForecasts,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json, String location) {
    List<dynamic> hourForecasts = json['hour'];
    List<HourForecast> hourForecastList = hourForecasts
        .map((hourForecast) => HourForecast.fromJson(hourForecast))
        .toList();

    return WeatherData(
      location: location,
      date: json['date'],
      maxTempC: json['day']['maxtemp_c'].toDouble(),
      minTempC: json['day']['mintemp_c'].toDouble(),
      avgTempC: json['day']['avgtemp_c'].toDouble(),
      maxTempF: json['day']['maxtemp_f'].toDouble(),
      minTempF: json['day']['mintemp_f'].toDouble(),
      avgTempF: json['day']['avgtemp_f'].toDouble(),
      maxWindKph: json['day']['maxwind_mph'].toDouble(),
      totalPrecipMm: json['day']['totalprecip_mm'].toDouble(),
      avgHumidity: json['day']['avghumidity'],
      dailyChanceOfRain: json['day']['daily_chance_of_rain'],
      textCondition: json['day']['condition']['text'],
      icon: json['day']['condition']['icon'],
      hourForecasts: hourForecastList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'location': location,
      'date': date,
      'maxTempC': maxTempC,
      'minTempC': minTempC,
      'avgTempC': avgTempC,
      'maxTempF': maxTempF,
      'minTempF': minTempF,
      'avgTempF': avgTempF,
      'maxWindKph': maxWindKph,
      'totalPrecipMm': totalPrecipMm,
      'avgHumidity': avgHumidity,
      'dailyChanceOfRain': dailyChanceOfRain,
      'textCondition': textCondition,
      'icon': icon,
      'hourForecasts': hourForecasts.map((e) => e.toJson()).toList(),
    };
  }

  factory WeatherData.fromJsonTemp(Map<String, dynamic> json) {
    return WeatherData(
      location: json['location'] ?? '',
      date: json['date'] ?? '',
      maxTempC: json['maxTempC']?.toDouble() ?? 0.0,
      minTempC: json['minTempC']?.toDouble() ?? 0.0,
      avgTempC: json['avgTempC']?.toDouble() ?? 0.0,
      maxTempF: json['maxTempF']?.toDouble() ?? 0.0,
      minTempF: json['minTempF']?.toDouble() ?? 0.0,
      avgTempF: json['avgTempF']?.toDouble() ?? 0.0,
      maxWindKph: json['maxWindKph']?.toDouble() ?? 0.0,
      totalPrecipMm: json['totalPrecipMm']?.toDouble() ?? 0.0,
      avgHumidity: json['avgHumidity']?.toDouble() ?? 0.0,
      dailyChanceOfRain: json['dailyChanceOfRain']?.toDouble() ?? 0.0,
      textCondition: json['textCondition'] ?? '',
      icon: json['icon'] ?? '',
      hourForecasts: (json['hourForecasts'] as List)
          .map((e) => HourForecast.fromJsonTemp(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
