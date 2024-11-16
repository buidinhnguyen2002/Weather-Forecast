import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter/material.dart';

import 'package:weather_dashboard/models/weather_data.dart';
import 'package:http/http.dart' as http;
import 'package:weather_dashboard/utils/constants.dart';

class WeatherForecastProvider with ChangeNotifier {
  final String weatherApiKey = "0bc886e8433f491f86252026241311";
  List<WeatherData> _weatherForecast = [];
  WeatherData? _todayWeather;
  List<WeatherData> _weatherFuture = [];
  int numForecast = 4;
  List<WeatherData> get weatherForecast {
    return _weatherForecast;
  }

  WeatherData? get todayWeather {
    return _todayWeather;
  }

  List<WeatherData> get weatherFuture {
    if (_weatherFuture.length > numForecast) {
      return _weatherFuture.sublist(0, numForecast);
    }
    return _weatherFuture;
  }

  Future<void> fetchWeatherForecast(String location) async {
    List<WeatherData>? existingData = await loadWeatherDataTemp(location);
    if (existingData != null) {
      _weatherForecast = existingData;
      _splitWeatherDataByDate();
      notifyListeners();
      return;
    }
    try {
      final String url =
          '${API.forecast}?q=${Uri.encodeQueryComponent(location)}&days=14&aqi=no&key=$weatherApiKey';
      final response = await http.get(Uri.parse(url), headers: {
        'Content-Type': 'application/json',
      });
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (response.statusCode == 400) {
        // throw Exception(responseData['error']['message']);
        throw responseData['error']['message'];
      }
      final String locationResponse = responseData["location"]["name"];
      final List<dynamic> forecastData =
          responseData["forecast"]["forecastday"];
      if (response.statusCode == 200) {
        List<WeatherData> weatherData = forecastData
            .map((weather) => WeatherData.fromJson(weather, locationResponse))
            .toList();
        _weatherForecast = weatherData;
        List<Map<String, dynamic>> jsonWeather =
            weatherData.map((data) => data.toJson()).toList();
        saveHistory(jsonWeather, locationResponse);
        _splitWeatherDataByDate();
      } else {
        throw Exception("ERROR");
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void saveHistory(List<Map<String, dynamic>> weather, String location) async {
    String? historyString = html.window.localStorage['weatherHistory'];
    List<Map<String, dynamic>> weatherHistory = [];
    String lowerCaseLocation = location.toLowerCase();
    if (historyString != null && historyString.isNotEmpty) {
      weatherHistory =
          List<Map<String, dynamic>>.from(jsonDecode(historyString));
    }
    Map<String, dynamic> weatherLocation = {lowerCaseLocation: weather};
    weatherHistory.add(weatherLocation);
    String saveString = jsonEncode(weatherHistory);
    html.window.localStorage['weatherHistory'] = saveString;
  }

  Future<List<WeatherData>?> loadWeatherDataTemp(String location) async {
    String? weatherDataTemp = html.window.localStorage['weatherHistory'];
    String lowerCaseLocation = location.toLowerCase();
    if (weatherDataTemp != null) {
      List<dynamic> jsonWeatherTemp = jsonDecode(weatherDataTemp);
      var locationData = jsonWeatherTemp.firstWhere(
        (data) =>
            data is Map<String, dynamic> && data.containsKey(lowerCaseLocation),
        orElse: () => null,
      );
      if (locationData == null) return null;
      List<dynamic> hourlyData = locationData[lowerCaseLocation];
      List<WeatherData> weatherDataList = hourlyData
          .map((weather) => WeatherData.fromJsonTemp(weather))
          .toList();
      return weatherDataList;
    }
    return null;
  }

  void loadMoreWeatherForecast() {
    int newNumForecast = numForecast + 4;
    if (newNumForecast > _weatherFuture.length) {
      numForecast = _weatherFuture.length;
    }
    numForecast = newNumForecast;
    notifyListeners();
  }

  void _splitWeatherDataByDate() {
    DateTime today = DateTime.now();
    _todayWeather = _weatherForecast.firstWhere(
      (weather) => _isSameDay(weather.date, today),
      orElse: () => _weatherForecast.first,
    );
    _weatherFuture = _weatherForecast
        .where((weather) => !_isSameDay(weather.date, today))
        .toList();
  }

  bool _isSameDay(String dateStr, DateTime date) {
    DateTime weatherDate = DateTime.parse(dateStr);
    return weatherDate.year == date.year &&
        weatherDate.month == date.month &&
        weatherDate.day == date.day;
  }

  String registerNotification(String email, String location) {
    String? historyString = html.window.localStorage['emailsRegister'];
    List<Map<String, dynamic>> emailHistory = [];
    if (historyString != null && historyString.isNotEmpty) {
      emailHistory = List<Map<String, dynamic>>.from(jsonDecode(historyString));
    }
    Map<String, dynamic> newRegister = {
      'email': email,
      'location': location,
    };
    emailHistory.add(newRegister);
    String saveString = jsonEncode(emailHistory);
    html.window.localStorage['emailsRegister'] = saveString;
    return 'Notification registered successfully!';
  }

  String unsubscribeNotification(String email) {
    try {
      String? historyString = html.window.localStorage['emailsRegister'];
      if (historyString != null && historyString.isNotEmpty) {
        List<Map<String, dynamic>> emailHistory =
            List<Map<String, dynamic>>.from(jsonDecode(historyString));
        emailHistory.removeWhere((register) => register['email'] == email);
        String saveString = jsonEncode(emailHistory);
        html.window.localStorage['emailsRegister'] = saveString;
        return 'Notification unsubscribed successfully!';
      } else {
        return 'No notifications found for this email.';
      }
    } catch (error) {
      throw 'An error occurred while unsubscribing the notification: $error';
    }
  }

  Future<bool> sendEmail({email, subject, message}) async {
    const serviceId = "service_qywphos";
    const templateId = "template_z4kw6m3";
    const userId = "5ta-5ayEBFN4cZsre";
    try {
      final response = await http.post(
        Uri.parse("https://api.emailjs.com/api/v1.0/email/send"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'user_name': 'Nguyen',
              'message': message,
              'user_subject': subject,
              'to_email': email,
            }
          },
        ),
      );
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  WeatherData finWeatherByLocation(String location, String date) {
    DateTime weatherDate = DateTime.parse(date);
    return _weatherForecast.firstWhere((weather) {
      DateTime date = DateTime.parse(weather.date);
      return weather.location == location &&
          date.year == weatherDate.year &&
          date.month == weatherDate.month &&
          date.day == weatherDate.day;
    });
  }
}
