import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/data/gold/repository/gold_repository.dart';
import 'package:chess_defense/data/in_game/repository/in_game_saved_data_repository.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/provider/in_game/in_game_gold_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_move_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_navigator_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_turn_provider.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/controller/show_custom_dialog.dart';
import 'package:chess_defense/ui/common/controller/util_function.dart';
import 'package:chess_defense/ui/common/screen/main_navigation_screen.dart';
import 'package:chess_defense/ui/common/widget/gold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InGameFooter extends ConsumerStatefulWidget {
  const InGameFooter({super.key});

  @override
  ConsumerState<InGameFooter> createState() => _InGameFooterState();
}

class _InGameFooterState extends ConsumerState<InGameFooter> {
  PieceType _selectedPiece = PieceType.queen;

  ElevatedButton _renderSpawnButton(PieceType piece) {
    late FaIcon pieceIcon;
    late String label;
    late int gold;

    switch (piece) {
      case PieceType.queen:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessQueen,
          color: whiteColor,
        );
        label = 'Queen';
        gold = 90;
        break;
      case PieceType.rook:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessRook,
          color: whiteColor,
        );
        label = 'Rook';
        gold = 50;
        break;
      case PieceType.knight:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessKnight,
          color: whiteColor,
        );
        label = 'Knight';
        gold = 30;
        break;
      case PieceType.bishop:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessBishop,
          color: whiteColor,
        );
        label = 'Bishop';
        gold = 30;
        break;
      case PieceType.pawn:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessPawn,
          color: whiteColor,
        );
        label = 'Pawn';
        gold = 10;
        break;
      default:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessPawn,
          color: whiteColor,
        );
        label = 'Pawn';
        gold = 10;
        break;
    }

    return ElevatedButton(
      style: ElevatedButton.styleFrom(fixedSize: Size(100, 50 * hu)),
      onPressed: () {
        _selectedPiece = piece;
        setState(() {});
        Navigator.pop(context);
        ref
            .read(inGameNavigatorProvider.notifier)
            .showSpawnNavigator(_selectedPiece);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          pieceIcon,
          const SizedBox(width: 10),
          Text(
            label,
            style:
                const TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 10),
          GoldWidget(gold: gold, goldTextColor: whiteColor),
        ],
      ),
    );
  }

  Widget _renderSpawnSelectedBox(PieceType piece) {
    late FaIcon pieceIcon;
    late String label;

    switch (piece) {
      case PieceType.queen:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessQueen,
          color: whiteColor,
        );
        label = 'Queen';
        break;
      case PieceType.rook:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessRook,
          color: whiteColor,
        );
        label = 'Rook';
        break;
      case PieceType.knight:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessKnight,
          color: whiteColor,
        );
        label = 'Knight';
        break;
      case PieceType.bishop:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessBishop,
          color: whiteColor,
        );
        label = 'Bishop';
        break;
      case PieceType.pawn:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessPawn,
          color: whiteColor,
        );
        label = 'Pawn';
        break;
      default:
        pieceIcon = FaIcon(
          FontAwesomeIcons.solidChessPawn,
          color: whiteColor,
        );
        label = 'Pawn';
        break;
    }

    final isMyTurn = ref.watch(inGameTurnProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onTap: isMyTurn
            ? () {
                ref
                    .read(inGameNavigatorProvider.notifier)
                    .showSpawnNavigator(_selectedPiece);
              }
            : null,
        child: SizedBox(
          height: 50 * hu,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: 'Resurrection',
              labelStyle: const TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: whiteColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                pieceIcon,
                const SizedBox(width: 10),
                Text(
                  label,
                  style: const TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMyTurn = ref.watch(inGameTurnProvider);

    return ColoredBox(
      color: inGameBlackColor,
      child: Padding(
        padding: EdgeInsets.all(10 * hu),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(child: _renderSpawnSelectedBox(_selectedPiece)),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: redColor,
                        ),
                        onPressed: isMyTurn
                            ? () {
                                showCustomDialog(
                                  context,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      const Text(
                                        "Do you want to exit the game?\n\nIf you exit without saving, any remaining Gold will be refunded.",
                                        style: TextStyle(
                                          color: blackColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      ElevatedButton(
                                          onPressed: () async {
                                            final tempList = <String>[];

                                            final move =
                                                ref.read(inGameMoveProvider);
                                            final inGameGold =
                                                ref.read(inGameGoldProvider);
                                            final inGameSaveDataList =
                                                inGameBoardStatus
                                                    .refinePieceEntityForSave();

                                            tempList.add(move.toString());
                                            tempList.add(inGameGold.toString());

                                            final saveDataList = [
                                              ...tempList,
                                              ...inGameSaveDataList
                                            ];

                                            await InGameSavedDataRepository()
                                                .saveInGameData(
                                                    inGameData: saveDataList);

                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: const Text("Save and Exit")),
                                      const SizedBox(height: 15),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.redAccent,
                                          ),
                                          onPressed: () async {
                                            final inGameGold =
                                                ref.read(inGameGoldProvider);

                                            myGolds += inGameGold;

                                            await GoldRepository()
                                                .setGolds(golds: myGolds);

                                            await InGameSavedDataRepository()
                                                .removeInGameData();

                                            if (context.mounted) {
                                              Navigator.pop(context);
                                              Navigator.pop(context);
                                            }

                                            setStateGold!(() {});
                                          },
                                          child: const Text(
                                              "Exit Without Saving")),
                                    ],
                                  ),
                                  actionButtonColor: Colors.grey,
                                );
                              }
                            : null,
                        child: const Text("Exit")),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                      onPressed: isMyTurn
                          ? () {
                              showCustomDialog(
                                context,
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      _renderSpawnButton(PieceType.queen),
                                      const SizedBox(height: 10),
                                      _renderSpawnButton(PieceType.rook),
                                      const SizedBox(height: 10),
                                      _renderSpawnButton(PieceType.knight),
                                      const SizedBox(height: 10),
                                      _renderSpawnButton(PieceType.bishop),
                                      const SizedBox(height: 10),
                                      _renderSpawnButton(PieceType.pawn),
                                    ],
                                  ),
                                ),
                                color: Colors.transparent,
                                actionButtonColor: Colors.grey,
                              );
                            }
                          : null,
                      child: const Text("Resurrection List")),
                )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                      onPressed: isMyTurn
                          ? () {
                              ref
                                  .read(inGameNavigatorProvider.notifier)
                                  .showExecuteNavigator();
                            }
                          : null,
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Execution"),
                          GoldWidget(gold: 300, goldTextColor: whiteColor),
                        ],
                      )),
                )),
              ],
            ),
            // Dummy containers for spaceBetween in row
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
