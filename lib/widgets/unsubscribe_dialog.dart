import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/providers/weather_forecast_provider.dart';
import 'package:weather_dashboard/widgets/notification_dialog.dart';

class UnsubscribeDialog extends StatefulWidget {
  const UnsubscribeDialog({Key? key}) : super(key: key);

  @override
  _UnsubscribeDialogState createState() => _UnsubscribeDialogState();
}

class _UnsubscribeDialogState extends State<UnsubscribeDialog> {
  final _formKey = GlobalKey<FormState>();
  String email = '';

  Future<void> _onUnsubscribePressed(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String message = Provider.of<WeatherForecastProvider>(
        context,
        listen: false,
      ).unsubscribeNotification(email);
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 1, milliseconds: 50), () {
            Navigator.of(context).pop(true);
          });
          return NotificationDialog(content: message);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Unsubscribe',
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
          child: const Text('Unsubscribe'),
          onPressed: () => _onUnsubscribePressed(context),
        ),
      ],
    );
  }
}
