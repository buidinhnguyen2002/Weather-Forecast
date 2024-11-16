import 'dart:ui';

import 'package:flutter/material.dart';

class API {
  static const baseURLApi = "https://api.weatherapi.com/v1";
  static const String forecast = '$baseURLApi/forecast.json';
  static const String moreForecast = '$baseURLApi/more-forecast';
  static const String registerNotification =
      '$baseURLApi/register-notification';
  static const String unsubscribeNotification = '$baseURLApi/unsubscribe';
}

class AppColors {
  static const Color background = Color.fromRGBO(227, 242, 253, 1);
  static const Color primaryColor = Color.fromRGBO(83, 114, 240, 1);
  static const Color secondaryColor = Color.fromRGBO(108, 117, 125, 1);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
}

class AssetConstants {
  static const basePathAnimation = "assets/animations/";
  static const animationTick = "${basePathAnimation}tick.json";
}

class BoxEmpty {
  static const SizedBox sizeBox5 = SizedBox(height: 5, width: 5);
  static const SizedBox sizeBox7 = SizedBox(height: 7, width: 7);
  static const SizedBox sizeBox10 = SizedBox(height: 10, width: 10);
  static const SizedBox sizeBox15 = SizedBox(height: 15, width: 15);
  static const SizedBox sizeBox20 = SizedBox(height: 20, width: 20);
  static const SizedBox sizeBox25 = SizedBox(height: 25, width: 25);
}
