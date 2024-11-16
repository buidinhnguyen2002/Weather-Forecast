import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:weather_dashboard/providers/weather_forecast_provider.dart';
import 'package:weather_dashboard/utils/constants.dart';
import 'package:weather_dashboard/widgets/notification_dialog.dart';

class OtpDialog extends StatefulWidget {
  final String otp;
  final String email;
  final String location;

  const OtpDialog(
      {Key? key,
      required this.otp,
      required this.email,
      required this.location})
      : super(key: key);

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  final TextEditingController _otpController = TextEditingController();
  String? _errorMessage;
  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'OTP Verification',
        style: GoogleFonts.rubik(
            color: AppColors.black, fontSize: 25, fontWeight: FontWeight.w500),
      ),
      content: TextField(
        controller: _otpController,
        decoration: InputDecoration(
          labelText: 'Enter OTP',
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1),
          ),
          errorText: _errorMessage,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            String message = "";
            if (widget.otp == _otpController.text) {
              message =
                  Provider.of<WeatherForecastProvider>(context, listen: false)
                      .registerNotification(widget.email, widget.location);
              // message = "Notification registered successfully!";
            } else {
              setState(() {
                _errorMessage = "OTP is incorrect";
              });
              return;
            }
            Navigator.of(context).pop(true);
            showDialog(
                context: context,
                builder: (context) {
                  Future.delayed(
                    const Duration(seconds: 1, microseconds: 50),
                    () {
                      Navigator.of(context).pop(true);
                    },
                  );
                  return NotificationDialog(content: message);
                });
          },
          style: TextButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
          ),
          child: const Text('Verify'),
        ),
      ],
    );
  }
}
