import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorSystemNotification extends StatelessWidget {
  const ErrorSystemNotification({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: pieceIconSize,
      bottom: pieceIconSize,
      child: IgnorePointer(
        child: Container(
              decoration: BoxDecoration(
                color: inGameBlackColor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(horizontal: pieceIconSize),
              width: pieceIconSize * 8,
              height: pieceIconSize * 1.5,
              child: FittedBox(
                child: Text(
                  errorMessage,
                  style: GoogleFonts.roboto(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: const Duration(seconds: 1))
            .then()
            .fadeOut(
              delay: const Duration(milliseconds: 500),
              duration: const Duration(seconds: 1),
            ),
      ),
    );
  }
}
