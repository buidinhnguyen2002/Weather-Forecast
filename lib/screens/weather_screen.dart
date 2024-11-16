import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/providers/weather_forecast_provider.dart';
import 'package:weather_dashboard/responsive.dart';
import 'package:weather_dashboard/screens/weather_detail_screen.dart';
import 'package:weather_dashboard/utils/constants.dart';
import 'package:weather_dashboard/widgets/card_weather_forecast.dart';
import 'package:weather_dashboard/widgets/card_weather_to_day.dart';
import 'package:weather_dashboard/widgets/common_button.dart';
import '../widgets/register_dialog.dart';
import '../widgets/unsubscribe_dialog.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _locationController = TextEditingController();
  bool weatherLoading = false;
  String? _searchError;
  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  String _location = "Unknown location";
  Position? currentLocation;
  List<Placemark>? placemarks;
  Future<Position> _determinePosition() async {
    bool serviceEnable;
    LocationPermission permission;
    serviceEnable = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnable) {
      return Future.error("Location services are disable.");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location permissions are denied");
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location permissions are permanently denied");
    }
    return await Geolocator.getCurrentPosition();
  }

  String generateOtp(int length) {
    final random = Random();
    const digits = '0123456789';
    return List.generate(
        length, (index) => digits[random.nextInt(digits.length)]).join();
  }

  void _showFormRegisterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const RegisterDialog(),
    );
  }

  void _showFormUnsubscribeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const UnsubscribeDialog(),
    );
  }

  void _showWeatherDetailDialog(
      BuildContext context, String date, String location) {
    showDialog(
      context: context,
      builder: (BuildContext context) => WeatherDetailDialog(
        date: date,
        location: location,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final weatherForecastProvider =
        Provider.of<WeatherForecastProvider>(context);
    final weathers = weatherForecastProvider.weatherForecast;
    final todayWeather = weatherForecastProvider.todayWeather;
    final weatherFuture = weatherForecastProvider.weatherFuture;
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 25),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Center(
              child: Text(
                "Weather Dashboard",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          if (deviceSize.width < 820)
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Enter a City Name"),
                  BoxEmpty.sizeBox10,
                  TextField(
                    controller: _locationController,
                    autofocus: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: const BorderSide(
                          width: 2.0,
                        ),
                      ),
                      labelText: 'Province/City',
                      errorText: _searchError,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: BorderSide(
                          color: Colors.grey.shade400,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(7.0),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),
                  BoxEmpty.sizeBox10,
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: CommonButton(
                          text: "Search",
                          background: Theme.of(context).colorScheme.primary,
                          onPress: () async {
                            if (_locationController.text == '') {
                              setState(() {
                                _searchError =
                                    "Province/city name cannot be blank";
                              });
                              return;
                            }
                            setState(() {
                              weatherLoading = true;
                            });
                            try {
                              await Provider.of<WeatherForecastProvider>(
                                      context,
                                      listen: false)
                                  .fetchWeatherForecast(
                                      _locationController.text);
                            } catch (e) {
                              setState(() {
                                _searchError = e.toString();
                              });
                            }
                            setState(() {
                              weatherLoading = false;
                            });
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        height: 1.5,
                        width: 20,
                        color: Colors.grey,
                      ),
                      Text(
                        "or",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 7),
                        height: 1.5,
                        width: 20,
                        color: Colors.grey,
                      ),
                      Expanded(
                        flex: 2,
                        child: CommonButton(
                          text: "Use Current Location",
                          background: Theme.of(context).colorScheme.secondary,
                          // onPress: () async {
                          //   currentLocation = await _determinePosition();
                          //   placemarks = await placemarkFromCoordinates(
                          //       currentLocation?.latitude ?? 37.4219,
                          //       currentLocation?.longitude ?? -122.084);
                          //   print(placemarks);
                          // },
                          onPress: () async {
                            // _showWeatherDetailDialog(context);
                          },
                        ),
                      ),
                    ],
                  ),
                  BoxEmpty.sizeBox7,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            _showFormRegisterDialog(context);
                          },
                          child: const Text("Register notification")),
                      TextButton(
                          onPressed: () {
                            _showFormUnsubscribeDialog(context);
                          },
                          child: const Text("Unsubscribe notification")),
                    ],
                  ),
                  if (deviceSize.width > 820 && deviceSize.width < 1150) ...[
                    TextButton(
                        onPressed: () {
                          _showFormRegisterDialog(context);
                        },
                        child: const Text("Register notification")),
                    TextButton(
                        onPressed: () {
                          _showFormUnsubscribeDialog(context);
                        },
                        child: const Text("Unsubscribe notification")),
                  ]
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Row(
                children: [
                  if (deviceSize.width > 820)
                    SizedBox(
                      width: (deviceSize.width - 50) * 0.3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Enter a City Name"),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: _locationController,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                ),
                              ),
                              labelText: 'Province/City',
                              errorText: _searchError,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CommonButton(
                            text: "Search",
                            background: Theme.of(context).colorScheme.primary,
                            onPress: () async {
                              if (_locationController.text == '') {
                                setState(() {
                                  _searchError =
                                      "Province/city name cannot be blank";
                                });
                                return;
                              }
                              setState(() {
                                weatherLoading = true;
                              });
                              try {
                                await Provider.of<WeatherForecastProvider>(
                                        context,
                                        listen: false)
                                    .fetchWeatherForecast(
                                        _locationController.text);
                              } catch (e) {
                                setState(() {
                                  _searchError = e.toString();
                                });
                              }
                              setState(() {
                                weatherLoading = false;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                "or",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Expanded(
                                child: Container(
                                  height: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          CommonButton(
                            text: "Use Current Location",
                            background: Theme.of(context).colorScheme.secondary,
                            onPress: () async {
                              // currentLocation = await _determinePosition();
                              // placemarks = await placemarkFromCoordinates(
                              //     currentLocation?.latitude ?? 37.4219,
                              //     currentLocation?.longitude ?? -122.084);
                              // print(placemarks);
                              // _showWeatherDetailDialog(context);
                            },
                          ),
                          BoxEmpty.sizeBox7,
                          if (Responsive.isDesktop(context))
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      _showFormRegisterDialog(context);
                                    },
                                    child: const Text("Register notification")),
                                TextButton(
                                    onPressed: () {
                                      _showFormUnsubscribeDialog(context);
                                    },
                                    child:
                                        const Text("Unsubscribe notification")),
                              ],
                            ),
                          if (deviceSize.width > 820 &&
                              deviceSize.width < 1150) ...[
                            TextButton(
                                onPressed: () {
                                  _showFormRegisterDialog(context);
                                },
                                child: const Text("Register notification")),
                            TextButton(
                                onPressed: () {
                                  _showFormUnsubscribeDialog(context);
                                },
                                child: const Text("Unsubscribe notification")),
                          ]
                        ],
                      ),
                    ),
                  if (!Responsive.isMobile(context))
                    const SizedBox(
                      width: 30,
                    ),
                  if (weatherLoading)
                    const Expanded(
                        child: Center(child: CircularProgressIndicator()))
                  else
                    weathers.isEmpty
                        ? const Expanded(
                            child: Center(
                              child: Text(
                                  "Please enter province/city to see weather forecast"),
                            ),
                          )
                        : Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CardWeatherToDay(
                                  location: todayWeather!.location,
                                  date: todayWeather.date,
                                  temperature: todayWeather.avgTempC,
                                  wind: todayWeather.maxWindKph,
                                  humidity: todayWeather.avgHumidity,
                                  icon: todayWeather.icon,
                                  textCondition: todayWeather.textCondition,
                                  onPress: () => _showWeatherDetailDialog(
                                      context,
                                      todayWeather.date,
                                      todayWeather.location),
                                ),
                                BoxEmpty.sizeBox25,
                                const Text(
                                  "4-Day Forecast",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                                BoxEmpty.sizeBox25,
                                Expanded(
                                  child: LayoutBuilder(
                                      builder: (context, constraints) {
                                    int divide = 5;
                                    if (Responsive.isTablet(context)) {
                                      divide = 4;
                                    }
                                    if (constraints.maxWidth < 950) {
                                      divide = 3;
                                    }
                                    if (constraints.maxWidth < 550) {
                                      divide = 2;
                                    }
                                    double cardWidth = (constraints.maxWidth -
                                            8 * (divide - 1)) /
                                        divide;
                                    return SingleChildScrollView(
                                      child: Wrap(
                                          spacing: 8.0,
                                          runSpacing: 8.0,
                                          children: [
                                            ...weatherFuture.map((weatherData) {
                                              return CardWeatherForecast(
                                                date: weatherData.date,
                                                temperature:
                                                    weatherData.avgTempC,
                                                wind: weatherData.maxWindKph,
                                                humidity:
                                                    weatherData.avgHumidity,
                                                icon: todayWeather.icon,
                                                textCondition:
                                                    todayWeather.textCondition,
                                                width: cardWidth,
                                                onPress: () =>
                                                    _showWeatherDetailDialog(
                                                        context,
                                                        weatherData.date,
                                                        weatherData.location),
                                              );
                                            }).toList(),
                                            Center(
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Provider.of<WeatherForecastProvider>(
                                                          context,
                                                          listen: false)
                                                      .loadMoreWeatherForecast();
                                                },
                                                child: const Text("Load more"),
                                              ),
                                            ),
                                          ]),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
