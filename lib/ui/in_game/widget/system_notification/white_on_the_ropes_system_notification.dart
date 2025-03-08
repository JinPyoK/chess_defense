import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class WhiteOnTheRopesSystemNotification extends StatelessWidget {
  const WhiteOnTheRopesSystemNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: IgnorePointer(
        child: Container(
              decoration: BoxDecoration(
                color: inGameBlackColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: pieceIconSize / 2),
              width: pieceIconSize * 5,
              height: pieceIconSize * 2,
              child: FittedBox(
                child: Text(
                  'WARNING',
                  style: GoogleFonts.roboto(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: const Duration(seconds: 2))
            .then()
            .fadeOut(
              delay: const Duration(milliseconds: 500),
              duration: const Duration(seconds: 2),
            ),
      ),
    );
  }
}
