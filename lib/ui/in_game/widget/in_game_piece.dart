import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/provider/in_game/in_game_black_status.dart';
import 'package:chess_defense/provider/in_game/in_game_navigator_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_turn_provider.dart';
import 'package:chess_defense/ui/audio/controller/audio_play.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_selected_piece_entity.dart';
import 'package:chess_defense/ui/in_game/widget/system_notification/piece_check_notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InGamePiece extends ConsumerStatefulWidget {
  const InGamePiece({super.key, required this.pieceEntity});

  final PieceBaseEntity pieceEntity;

  @override
  ConsumerState<InGamePiece> createState() => _InGamePieceState();
}

class _InGamePieceState extends ConsumerState<InGamePiece> {
  double _spawnOpacity = 0;
  double _spawnScale = 1;

  bool _callJanggoon = false;

  void _onPieceTaped() {
    final isMyTurn = ref.read(inGameTurnProvider);

    if (widget.pieceEntity.team == Team.white && isMyTurn) {
      if (selectedPieceEntity != null) {
        selectedPieceEntity!.justTapped = false;
        selectedPieceEntity!.setStateThisPiece!(() {});
      }
      selectedPieceEntity = widget.pieceEntity..justTapped = true;
      setState(() {});

      widget.pieceEntity.searchActionable(inGameBoardStatus);

      ref
          .read(inGameNavigatorProvider.notifier)
          .showPieceMoveNavigator(widget.pieceEntity.pieceActionable);

      makePieceTapSound();
    }
  }

  List<Color> _justTurnPieceColor() {
    /// 흑 기물의 수가 30 이상
    final onTheRopes = ref.watch(inGameOnTheRopesProvider);

    if (widget.pieceEntity.justTapped) {
      return [whiteColor, Colors.green];
    }

    if (widget.pieceEntity.team == Team.black) {
      if (onTheRopes) {
        return [blackColor, redColor];
      } else {
        if (widget.pieceEntity.justTurn) {
          return [blackColor, redColor];
        } else {
          return [blackColor, blackColor];
        }
      }
    } else {
      if (widget.pieceEntity.justTurn) {
        return [whiteColor, Colors.blueAccent];
      } else {
        return [whiteColor, whiteColor];
      }
    }
  }

  @override
  void initState() {
    super.initState();

    widget.pieceEntity.setStateThisPiece = setState;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _spawnOpacity = 1;
      _spawnScale = 1.5;
      setState(() {});

      Future.delayed(const Duration(milliseconds: 500), () {
        _spawnScale = 1;
        setState(() {});
      });
    });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      if (widget.pieceEntity is BlackPieceBaseEntity) {
        final redPieceModel = widget.pieceEntity as BlackPieceBaseEntity;

        _callJanggoon = redPieceModel.isTargetingKing;
      }
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      left: boardPositionXValue[widget.pieceEntity.x]! + screenOffset,
      bottom: boardPositionYValue[widget.pieceEntity.y],
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          AnimatedScale(
            scale: _spawnScale,
            duration: const Duration(milliseconds: 500),
            curve: Curves.bounceInOut,
            child: AnimatedOpacity(
              opacity: _spawnOpacity,
              duration: const Duration(seconds: 2),
              curve: Curves.easeOut,
              child: GestureDetector(
                onTap: _onPieceTaped,
                child: ShaderMask(
                  shaderCallback: (rect) {
                    return RadialGradient(
                      colors: _justTurnPieceColor(),
                    ).createShader(rect);
                  },
                  blendMode: BlendMode.srcIn,
                  child: widget.pieceEntity.pieceIcon,
                ),
              ),
            ),
          ),
          if (_callJanggoon)
            Positioned(
              bottom: pieceIconSize / 1.2,
              child: const PieceCheckNotification(),
            ),
        ],
      ),
    );
  }
}
