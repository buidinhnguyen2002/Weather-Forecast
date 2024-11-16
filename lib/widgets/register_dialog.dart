import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/widgets/otp_dialog.dart';
import '../providers/weather_forecast_provider.dart';

class RegisterDialog extends StatefulWidget {
  const RegisterDialog({Key? key}) : super(key: key);

  @override
  _RegisterDialogState createState() => _RegisterDialogState();
}

class _RegisterDialogState extends State<RegisterDialog> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String city = '';

  String generateOtp(int length) {
    final random = Random();
    const digits = '0123456789';
    return List.generate(
        length, (index) => digits[random.nextInt(digits.length)]).join();
  }

  Future<void> _onRegisterPressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final otp = generateOtp(6);
      bool sendEmailSuccessful = await Provider.of<WeatherForecastProvider>(
        context,
        listen: false,
      ).sendEmail(
        email: email,
        subject: 'Confirm OTP',
        message: otp,
      );
      Navigator.of(context).pop();
      // if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (context) => OtpDialog(
          otp: otp,
          email: email,
          location: city,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Register',
        style: TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                if (!value.contains("@gmail.com")) {
                  return 'Email containing @gmail.com';
                }
                return null;
              },
              onSaved: (value) {
                email = value!;
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Province/City'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter province/city';
                }
                return null;
              },
              onSaved: (value) {
                city = value!;
              },
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          onPressed: () => _onRegisterPressed(context),
          child: const Text('Register'),
        ),
      ],
    );
  }
}
