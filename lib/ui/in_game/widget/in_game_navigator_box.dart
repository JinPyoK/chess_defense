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
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_selected_piece_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  void _onNavigatorTaped() {
    if (widget.navigatorType == NavigatorType.pieceMove) {
      /// 네비게이터 삭제
      ref.read(inGameNavigatorProvider.notifier).clearNavigator();

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

      /// 움직인 자리에 흑 기물이 있다면 제거하기
      final status = inGameBoardStatus.getStatus(
          widget.pieceActionable.targetX, widget.pieceActionable.targetY);
      if (status is PieceBaseEntity) {
        if (status.team == Team.black) {
          ref
              .read(inGamePieceSetProvider.notifier)
              .removePiece(widget.pieceActionable);
        }
      }

      inGameBoardStatus.changeStatus(widget.pieceActionable.targetX,
          widget.pieceActionable.targetY, selectedPieceEntity!);

      /// 최근 탭한 기물 setState
      if (selectedPieceEntity != null) {
        selectedPieceEntity!.justTapped = false;
        selectedPieceEntity!.setStateThisPiece!(() {});
      }

      /// 최근 기물 착수 ui 구현 위해서
      if (lastTurnPiece != null) {
        lastTurnPiece!.justTurn = false;
        lastTurnPiece!.setStateThisPiece!(() {});
      }

      lastTurnPiece = selectedPieceEntity;
      lastTurnPiece!.justTurn = true;

      /// 기물 착수
      selectedPieceEntity!.x = widget.pieceActionable.targetX;
      selectedPieceEntity!.y = widget.pieceActionable.targetY;
      selectedPieceEntity!.setStateThisPiece!(() {});
      ref.read(inGameTurnProvider.notifier).changeTurn();

      selectedPieceEntity = null;

      makePieceMoveSound();
    } else if (widget.navigatorType == NavigatorType.spawn) {
      ref.read(inGameNavigatorProvider.notifier).clearNavigator();

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

      ref.read(inGamePieceSetProvider.notifier).spawnPiece(spawnPieceEntity);
    } else if (widget.navigatorType == NavigatorType.execute) {
      ref.read(inGameNavigatorProvider.notifier).clearNavigator();
      ref
          .read(inGamePieceSetProvider.notifier)
          .removePiece(widget.pieceActionable, true);
      ref.read(inGameTurnProvider.notifier).determineIfCheck();
    }
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
      left: boardPositionXValue[widget.pieceActionable.targetX]! +
          pieceIconSize / 5,
      bottom: boardPositionYValue[widget.pieceActionable.targetY]! +
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
                color: widget.navigatorType == NavigatorType.spawn
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
