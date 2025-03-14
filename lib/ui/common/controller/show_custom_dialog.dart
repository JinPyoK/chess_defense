import 'package:chess_defense/core/constant/color.dart';
import 'package:flutter/material.dart';

Future<void> showCustomDialog(
  BuildContext context,
  Widget customChild, {
  Color color = whiteColor,
  bool defaultAction = true,
  Color actionButtonColor = woodColor,
  Color barrierColor = const Color(0x80000000),
}) async {
  await showGeneralDialog(
    context: context,
    barrierColor: barrierColor,
    pageBuilder: (context, a1, a2) => Container(),
    transitionDuration: const Duration(milliseconds: 100),
    transitionBuilder: (context, a1, a2, child) {
      return ScaleTransition(
        scale: a1,
        child: AlertDialog(
          backgroundColor: color,
          scrollable: true,
          content: Padding(
            padding: const EdgeInsets.only(top: 32),
            child: customChild,
          ),
          actions: [
            if (defaultAction)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: actionButtonColor,
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: Text(actionButtonColor == woodColor ? 'OK' : 'Cancel'),
              ),
          ],
        ),
      );
    },
  );
}
