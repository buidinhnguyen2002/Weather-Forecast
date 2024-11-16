import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../utils/constants.dart';

class NotificationDialog extends StatelessWidget {
  const NotificationDialog({super.key, required this.content});
  final String content;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(15),
      backgroundColor: Theme.of(context).colorScheme.background,
      content: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(AssetConstants.animationTick, width: 100),
            BoxEmpty.sizeBox10,
            Text(
              content,
              style: GoogleFonts.rubik(color: Colors.green, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
    ;
  }
}
