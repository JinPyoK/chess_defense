import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class BlackUpgradeSystemNotification extends StatelessWidget {
  const BlackUpgradeSystemNotification({super.key, required this.level});

  final int level;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          color: inGameBlackColor.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(
            horizontal: pieceIconSize, vertical: pieceIconSize / 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Black Algorithm',
              style: GoogleFonts.roboto(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: pieceIconSize / 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Level',
                  style: GoogleFonts.roboto(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: pieceIconSize / 2,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    level.toString(),
                    style: GoogleFonts.roboto(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: pieceIconSize,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
          .animate()
          .fadeIn(
            duration: const Duration(seconds: 1),
          )
          .then()
          .shimmer(
            delay: const Duration(milliseconds: 500),
            duration: const Duration(seconds: 1),
          )
          .then()
          .fadeOut(
            delay: const Duration(milliseconds: 500),
            duration: const Duration(seconds: 1),
          ),
    );
  }
}
