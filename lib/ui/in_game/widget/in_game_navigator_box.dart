import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/navigator_type_enum.dart';
import 'package:chess_defense/domain/in_game/entity/piece_actionable_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_bishop_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_knight_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_pawn_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_queen_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_rook_entity.dart';
import 'package:chess_defense/provider/in_game/in_game_navigator_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_piece_set_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_turn_provider.dart';
import 'package:chess_defense/ui/audio/controller/audio_play.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/controller/show_custom_dialog.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_selected_piece_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InGameNavigatorBox extends ConsumerStatefulWidget {
  const InGameNavigatorBox({
    super.key,
    required this.pieceActionable,
    this.navigatorType = NavigatorType.pieceMove,
    this.spawnPieceType = PieceType.queen,
  });

  final PieceActionableEntity pieceActionable;
  final NavigatorType navigatorType;
  final PieceType spawnPieceType;

  @override
  ConsumerState<InGameNavigatorBox> createState() => _InGameNavigatorState();
}

class _InGameNavigatorState extends ConsumerState<InGameNavigatorBox> {
  double _navigatorOpacity = 0;

  /// 백, 즉 유저에게만 작용하는 함수
  Future<void> _onNavigatorTaped() async {
    switch (widget.navigatorType) {
      case NavigatorType.pieceMove:

        /// 보드 상태 변경
        inGameBoardStatus.changeStatus(
          selectedPieceEntity!.x,
          selectedPieceEntity!.y,
          PieceActionableEntity(
            targetX: selectedPieceEntity!.x,
            targetY: selectedPieceEntity!.y,
            targetValue: 0,
          ),
        );

        /// 캐슬링
        if (widget.pieceActionable.actionType == PieceActionType.castling) {
          /// selectedPiece는 king이다.

          /// 왼쪽 룩과 캐슬링
          if (widget.pieceActionable.targetX == 0) {
            final rook = inGameBoardStatus.getStatus(0, 7);
            final leftRook = rook as WhiteRookEntity;

            /// 상태 변경
            inGameBoardStatus.changeStatus(2, 7, selectedPieceEntity!);
            inGameBoardStatus.changeStatus(3, 7, leftRook);

            /// 기물 착수
            selectedPieceEntity!.x = 2;
            selectedPieceEntity!.y = 7;
            selectedPieceEntity!.setStateThisPiece!(() {});

            leftRook.x = 3;
            leftRook.y = 7;
            leftRook.firstMove = true;
            leftRook.setStateThisPiece!(() {});

            /// 왼쪽룩 자리 비우기
            inGameBoardStatus.changeStatus(
              0,
              7,
              PieceActionableEntity(targetX: 0, targetY: 7, targetValue: 0),
            );
          }
          /// 오른쪽 룩과 캐슬링
          else if (widget.pieceActionable.targetX == 7) {
            final rook = inGameBoardStatus.getStatus(7, 7);
            final rightRook = rook as WhiteRookEntity;

            /// 상태 변경
            inGameBoardStatus.changeStatus(6, 7, selectedPieceEntity!);
            inGameBoardStatus.changeStatus(5, 7, rightRook);

            /// 기물 착수
            selectedPieceEntity!.x = 6;
            selectedPieceEntity!.y = 7;
            selectedPieceEntity!.setStateThisPiece!(() {});

            rightRook.x = 5;
            rightRook.y = 7;
            rightRook.firstMove = true;
            rightRook.setStateThisPiece!(() {});

            /// 오른쪽룩 자리 비우기
            inGameBoardStatus.changeStatus(
              7,
              7,
              PieceActionableEntity(targetX: 7, targetY: 7, targetValue: 0),
            );
          }
        }
        /// 앙파상
        else if (widget.pieceActionable.actionType ==
            PieceActionType.enPassant) {
          /// 상태 변경
          inGameBoardStatus.changeStatus(
            widget.pieceActionable.targetX,
            widget.pieceActionable.targetY,
            selectedPieceEntity!,
          );

          /// 흑의 폰 제거
          ref
              .read(inGamePieceSetProvider.notifier)
              .removePiece(
                PieceActionableEntity(
                  targetX: widget.pieceActionable.targetX,
                  targetY: widget.pieceActionable.targetY + 1,
                  targetValue: widget.pieceActionable.targetValue,
                ),
                PieceRemoveType.captured,
              );

          /// 기물 착수
          selectedPieceEntity!.x = widget.pieceActionable.targetX;
          selectedPieceEntity!.y = widget.pieceActionable.targetY;
          selectedPieceEntity!.setStateThisPiece!(() {});
        }
        /// 단순 행마
        else {
          /// 움직인 자리에 흑 기물이 있다면 제거하기
          final status = inGameBoardStatus.getStatus(
            widget.pieceActionable.targetX,
            widget.pieceActionable.targetY,
          );
          if (status is PieceBaseEntity) {
            if (status.team == Team.black) {
              ref
                  .read(inGamePieceSetProvider.notifier)
                  .removePiece(
                    widget.pieceActionable,
                    PieceRemoveType.captured,
                  );
            }
          }

          inGameBoardStatus.changeStatus(
            widget.pieceActionable.targetX,
            widget.pieceActionable.targetY,
            selectedPieceEntity!,
          );

          /// 기물 착수
          selectedPieceEntity!.x = widget.pieceActionable.targetX;
          selectedPieceEntity!.y = widget.pieceActionable.targetY;
          selectedPieceEntity!.setStateThisPiece!(() {});

          /// 폰이 두칸 전진 했을 경우
          if (widget.pieceActionable.actionType == PieceActionType.doubleMove) {
            selectedPieceEntity!.doubleMove = true;
          }

          /// 백 폰 프로모션
          if (selectedPieceEntity is WhitePawnEntity &&
              widget.pieceActionable.targetY == 0) {
            await Future.delayed(const Duration(milliseconds: 500), () async {
              /// 폰 제거
              ref
                  .read(inGamePieceSetProvider.notifier)
                  .removePiece(
                    widget.pieceActionable,
                    PieceRemoveType.promotion,
                  );

              late PieceBaseEntity promotionPiece;

              if (mounted) {
                await showCustomDialog(
                  context,
                  defaultAction: false,
                  color: Colors.transparent,
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Promotion",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                          fontSize: 26 * hu,
                        ),
                      ),
                      SizedBox(
                        width: 300 * wu,
                        height: 500 * hu,
                        child: GridView(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2칸씩 배치
                                childAspectRatio: 0.8,
                                mainAxisSpacing: 30,
                                crossAxisSpacing: 30,
                              ),
                          children: [
                            _promotionButton(
                              "Queen",
                              FontAwesomeIcons.solidChessQueen,
                              () {
                                promotionPiece = WhiteQueenEntity(
                                  x: widget.pieceActionable.targetX,
                                  y: widget.pieceActionable.targetY,
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                            _promotionButton(
                              "Rook",
                              FontAwesomeIcons.solidChessRook,
                              () {
                                promotionPiece = WhiteRookEntity(
                                  x: widget.pieceActionable.targetX,
                                  y: widget.pieceActionable.targetY,
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                            _promotionButton(
                              "Knight",
                              FontAwesomeIcons.solidChessKnight,
                              () {
                                promotionPiece = WhiteKnightEntity(
                                  x: widget.pieceActionable.targetX,
                                  y: widget.pieceActionable.targetY,
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                            _promotionButton(
                              "Bishop",
                              FontAwesomeIcons.solidChessBishop,
                              () {
                                promotionPiece = WhiteBishopEntity(
                                  x: widget.pieceActionable.targetX,
                                  y: widget.pieceActionable.targetY,
                                );
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              /// 폰 프로모션
              ref
                  .read(inGamePieceSetProvider.notifier)
                  .spawnPiece(promotionPiece, PieceSpawnType.promotion);

              lastTurnPiece = promotionPiece;
            });
          }
        }

        /// 최근 탭한 기물 setState
        if (selectedPieceEntity != null) {
          selectedPieceEntity!.justTapped = false;
          if (selectedPieceEntity!.setStateThisPiece != null) {
            selectedPieceEntity!.setStateThisPiece!(() {});
          }
        }

        /// 최근 기물 착수 ui 구현 위해서
        if (lastTurnPiece != null) {
          lastTurnPiece!.justTurn = false;
          if (lastTurnPiece!.setStateThisPiece != null) {
            lastTurnPiece!.setStateThisPiece!(() {});
          }
        }

        lastTurnPiece = selectedPieceEntity;
        lastTurnPiece!.justTurn = true;
        lastTurnPiece!.firstMove = true;

        ref.read(inGameTurnProvider.notifier).changeTurn();

        selectedPieceEntity = null;

        makePieceMoveSound();

        break;
      case NavigatorType.spawn:
        late PieceBaseEntity spawnPieceEntity;

        switch (widget.spawnPieceType) {
          case PieceType.queen:
            spawnPieceEntity = WhiteQueenEntity(
              x: widget.pieceActionable.targetX,
              y: widget.pieceActionable.targetY,
            );
          case PieceType.rook:
            spawnPieceEntity = WhiteRookEntity(
              x: widget.pieceActionable.targetX,
              y: widget.pieceActionable.targetY,
            );
          case PieceType.knight:
            spawnPieceEntity = WhiteKnightEntity(
              x: widget.pieceActionable.targetX,
              y: widget.pieceActionable.targetY,
            );
          case PieceType.bishop:
            spawnPieceEntity = WhiteBishopEntity(
              x: widget.pieceActionable.targetX,
              y: widget.pieceActionable.targetY,
            );
          case PieceType.pawn:
            spawnPieceEntity = WhitePawnEntity(
              x: widget.pieceActionable.targetX,
              y: widget.pieceActionable.targetY,
            );
          default:
            spawnPieceEntity = WhitePawnEntity(
              x: widget.pieceActionable.targetX,
              y: widget.pieceActionable.targetY,
            );
        }

        ref
            .read(inGamePieceSetProvider.notifier)
            .spawnPiece(spawnPieceEntity, PieceSpawnType.spawn);
        break;
      case NavigatorType.execution:
        ref
            .read(inGamePieceSetProvider.notifier)
            .removePiece(widget.pieceActionable, PieceRemoveType.execution);
        ref.read(inGameTurnProvider.notifier).determineIfCheck();
        break;
    }
    ref.read(inGameNavigatorProvider.notifier).clearNavigator();
  }

  Widget _promotionButton(
    String label,
    IconData iconData,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 15 * wu,
              fontWeight: FontWeight.bold,
              color: whiteColor,
            ),
          ),
          FaIcon(iconData, color: whiteColor, size: 25 * wu),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navigatorOpacity = 1;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left:
          boardPositionXValue[widget.pieceActionable.targetX]! +
          pieceIconSize / 5 +
          screenOffset,
      bottom:
          boardPositionYValue[widget.pieceActionable.targetY]! +
          pieceIconSize / 5,
      child: AnimatedOpacity(
        opacity: _navigatorOpacity,
        duration: const Duration(milliseconds: 300),
        child: GestureDetector(
          onTap: _onNavigatorTaped,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 3,
                color:
                    widget.navigatorType == NavigatorType.spawn
                        ? Colors.lightGreenAccent
                        : redColor,
              ),
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,
            ),
            width: pieceIconSize / 1.7,
            height: pieceIconSize / 1.7,
          ),
        ),
      ),
    );
  }
}
