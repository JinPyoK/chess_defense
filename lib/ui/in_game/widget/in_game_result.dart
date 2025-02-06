import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/data/gold/repository/gold_repository.dart';
import 'package:chess_defense/data/in_game/repository/in_game_saved_data_repository.dart';
import 'package:chess_defense/data/ranking/model/rank_model.dart';
import 'package:chess_defense/provider/in_game/in_game_gold_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_move_provider.dart';
import 'package:chess_defense/provider/ranking/ranking_provider.dart';
import 'package:chess_defense/ui/common/controller/global_context.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/controller/show_custom_snackbar.dart';
import 'package:chess_defense/ui/common/controller/util_function.dart';
import 'package:chess_defense/ui/common/screen/main_navigation_screen.dart';
import 'package:chess_defense/ui/in_game/controller/check_bad_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InGameResult extends ConsumerStatefulWidget {
  const InGameResult({
    super.key,
    required this.reason,
  });

  final int reason;

  @override
  ConsumerState<InGameResult> createState() => _InGameResultState();
}

class _InGameResultState extends ConsumerState<InGameResult> {
  final _textController = TextEditingController();

  /// 랭크 1회 등록 후 버튼 비활성화
  bool _canRankRegister = true;

  /// 닉네임 체크 로딩
  bool _nicknameChecking = false;

  /// 비속어 체크
  Future<bool> _nickNameHasBadWords(String nickName) async {
    if (nickName == '') {
      if (context.mounted) {
        showCustomSnackBar(
            context, "Please enter at least one character for the nickname");
      }
      return true;
    }

    if (await hasBadWords(nickName)) {
      if (mounted) {
        showCustomSnackBar(
            context, "Profanity and consecutive numbers are not allowed");
      }
      return true;
    }

    return false;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moveResult = ref.read(inGameMoveProvider);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Game Over",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: blackColor,
              fontSize: 16 * hu,
            ),
          ),
          SizedBox(height: 5 * hu),
          Text(
            widget.reason == 0
                ? "The King has been captured."
                : "The number of Black pieces has exceeded 40.",
            style: TextStyle(
              color: blackColor,
              fontSize: 10 * hu,
            ),
          ),
          SizedBox(height: 20 * hu),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 100 * wu,
                height: 50 * hu,
                child: FittedBox(
                  child: Text(
                    moveResult.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: blackColor,
                    ),
                  ),
                ),
              ),
              const Text("Moves"),
            ],
          ),
          SizedBox(height: 30 * hu),
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              hintText: "Please enter a nickname",
            ),
            maxLength: 10,
          ),
          SizedBox(height: 30 * hu),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _canRankRegister
                    ? () async {
                        try {
                          if (!_nicknameChecking) {
                            _nicknameChecking = true;
                            setState(() {});

                            final nickName = _textController.text;

                            if (await _nickNameHasBadWords(nickName)) {
                              _nicknameChecking = false;
                              setState(() {});
                              return;
                            }

                            await ref
                                .read(rankingProvider.notifier)
                                .registerRank(
                                  rankModel: RankModel.autoId(
                                    move: moveResult,
                                    nickName: nickName,
                                  ),
                                );

                            _canRankRegister = false;
                            _nicknameChecking = false;
                            setState(() {});
                            if (context.mounted) {
                              showCustomSnackBar(
                                  context, "Your rank has been registered");
                            }
                          }
                        } catch (_) {
                          if (context.mounted) {
                            showCustomSnackBar(context,
                                "Failed to register rank. Please try again");
                          }
                        }
                      }
                    : null,
                child: _nicknameChecking
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: whiteColor,
                        ),
                      )
                    : const Text("Register Rank"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: redColor,
                ),
                onPressed: () async {
                  final inGameGold = ref.read(inGameGoldProvider);

                  myGolds += inGameGold;

                  await GoldRepository().setGolds(golds: myGolds);

                  await InGameSavedDataRepository().removeInGameData();

                  if (context.mounted) {
                    Navigator.pop(globalContext!);
                    Navigator.pop(context);
                  }

                  setStateGold!(() {});
                },
                child: const Text("Exit"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
