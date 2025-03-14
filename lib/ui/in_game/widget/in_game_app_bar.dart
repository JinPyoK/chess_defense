import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/provider/in_game/in_game_gold_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_move_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_turn_provider.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/widget/gold_widget.dart';
import 'package:chess_defense/ui/in_game/controller/get_gold_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InGameAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const InGameAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inGameGold = ref.watch(inGameGoldProvider);
    final inGameMove = ref.watch(inGameMoveProvider);
    final isMyTurn = ref.watch(inGameTurnProvider);
    final goldNotification = ref.watch(getGoldNotificationWidgetProvider);

    return AppBar(
      backgroundColor: inGameBlackColor,
      leading: isMyTurn
          ? Container()
          : const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(color: whiteColor),
            ),
      centerTitle: true,
      title: Text(
        inGameMove.toString(),
        style: const TextStyle(fontWeight: FontWeight.bold, color: whiteColor),
      ),
      actions: [
        goldNotification,
        const SizedBox(width: 10),
        Padding(
          padding: EdgeInsets.only(right: 10 * wu),
          child: GoldWidget(
            gold: inGameGold,
            goldTextColor: whiteColor,
          ),
        ),
      ],
    );
  }
}
