import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckSystemNotification extends StatelessWidget {
  const CheckSystemNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: pieceIconSize * 2.45,
      bottom: pieceIconSize * 6.5,
      child: IgnorePointer(
        child: Container(
          decoration: BoxDecoration(
            color: inGameBlackColor.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(
              horizontal: pieceIconSize, vertical: pieceIconSize / 2.5),
          child: Text(
            'Check',
            style: GoogleFonts.roboto(
              color: whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: pieceIconSize,
            ),
          ),
        )
            .animate()
            .fadeIn(
              duration: const Duration(seconds: 1),
            )
            .then()
            .fadeOut(
              delay: const Duration(milliseconds: 500),
              duration: const Duration(seconds: 1),
            ),
      ),
    );
  }
}
