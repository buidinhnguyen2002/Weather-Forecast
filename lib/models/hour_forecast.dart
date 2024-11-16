class HourForecast {
  final String time;
  final double tempC;
  final double tempF;
  final double windKph;
  final double precipMm;
  final int humidity;
  final int chanceOfRain;
  final String textCondition;
  final String icon;

  HourForecast({
    required this.time,
    required this.tempC,
    required this.tempF,
    required this.windKph,
    required this.precipMm,
    required this.humidity,
    required this.chanceOfRain,
    required this.textCondition,
    required this.icon,
  });

  factory HourForecast.fromJson(Map<String, dynamic> json) {
    return HourForecast(
      time: json['time'],
      tempC: json['temp_c'].toDouble(),
      tempF: json['temp_f'].toDouble(),
      windKph: json['wind_mph'].toDouble(),
      precipMm: json['precip_mm'].toDouble(),
      humidity: json['humidity'],
      chanceOfRain: json['chance_of_rain'],
      textCondition: json['condition']['text'],
      icon: json['condition']['icon'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'tempC': tempC,
      'tempF': tempF,
      'windKph': windKph,
      'precipMm': precipMm,
      'humidity': humidity,
      'chanceOfRain': chanceOfRain,
      'textCondition': textCondition,
      'icon': icon,
    };
  }

  factory HourForecast.fromJsonTemp(Map<String, dynamic> json) {
    return HourForecast(
      time: json['time'] ?? '',
      tempC: json['tempC']?.toDouble() ?? 0.0,
      tempF: json['tempF']?.toDouble() ?? 0.0,
      windKph: json['windKph']?.toDouble() ?? 0.0,
      precipMm: json['precipMm']?.toDouble() ?? 0.0,
      humidity: json['humidity']?.toDouble() ?? 0.0,
      chanceOfRain: json['chanceOfRain']?.toDouble() ?? 0.0,
      textCondition: json['textCondition'] ?? '',
      icon: json['icon'] ?? '',
    );
  }
}
