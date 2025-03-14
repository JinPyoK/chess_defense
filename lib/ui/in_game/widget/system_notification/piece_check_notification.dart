import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PieceCheckNotification extends StatelessWidget {
  const PieceCheckNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: inGameBlackColor.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(8),
      child: Text(
        'Check',
        style: TextStyle(
          color: whiteColor,
          fontWeight: FontWeight.bold,
          fontSize: 8 * hu,
        ),
      ),
    )
        .animate()
        .fade(duration: const Duration(seconds: 1))
        .animate(onPlay: (controller) => controller.repeat())
        .shimmer(
          delay: const Duration(seconds: 1),
          duration: const Duration(seconds: 1),
        );
  }
}
