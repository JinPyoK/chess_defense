import 'dart:math' hide log;

import 'package:chess_defense/domain/in_game/entity/black_piece/black_bishop_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_knight_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_pawn_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_queen_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_rook_entity.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/minimax_node_tree.dart';
import 'package:chess_defense/domain/in_game/entity/piece_actionable_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/provider/in_game/in_game_black_status.dart';
import 'package:chess_defense/provider/in_game/in_game_move_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_piece_set_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_system_notification_provider.dart';
import 'package:chess_defense/ui/audio/controller/audio_play.dart';
import 'package:chess_defense/ui/common/controller/global_context.dart';
import 'package:chess_defense/ui/common/controller/show_custom_dialog.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_selected_piece_entity.dart';
import 'package:chess_defense/ui/in_game/widget/in_game_result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_game_black_minimax.dart';
part 'in_game_turn_provider.g.dart';

@Riverpod()
final class InGameTurn extends _$InGameTurn {
  @override
  bool build() {
    return true;
  }

  Future<void> changeTurn() async {
    ref.read(inGameMoveProvider.notifier).nextMove();

    state = !state;

    /// 흑 착수
    if (state == false) {
      /// 시스템 노티피케이션 리스트 비워주기
      ref
          .read(inGameSystemNotificationProvider.notifier)
          .clearNotificationList();

      /// 흑 기물 부활
      _blackSpawn();

      ref.read(inGameOnTheRopesProvider.notifier).checkOnTheRopes();

      /// 흑 기물의 수가 50을 넘으면 게임 종료
      if (inGameBoardStatus.getNumOfBlack() > 40) {
        if (globalContext!.mounted) {
          Future.delayed(const Duration(seconds: 1), () {
            showCustomDialog(
              globalContext!,
              const InGameResult(reason: 1),
              defaultAction: false,
              barrierColor: const Color(0x20000000),
            );
          });
        }
        return;
      }

      /// 흑 착수
      final PieceActionableEntity? targetPieceActionable = await _blackAction();

      /// 만약 흑이 백의 왕을 먹었다면 게임 종료
      if (targetPieceActionable != null) {
        if (targetPieceActionable.targetValue >= 1000) {
          if (globalContext!.mounted) {
            Future.delayed(const Duration(seconds: 1), () {
              showCustomDialog(
                globalContext!,
                const InGameResult(reason: 0),
                defaultAction: false,
                barrierColor: const Color(0x20000000),
              );
            });
          }
          return;
        }
      }

      /// 흑 착수 후 장군 체크
      determineIfCheck();

      changeTurn();
    }
  }

  void _blackSpawn() {
    final move = ref.read(inGameMoveProvider);

    /// 흑 알고리즘 강화
    if (move == 20) {
      inGameBlackStatusProvider.upgradeBlack(1);
      ref.read(inGameSystemNotificationProvider.notifier).notifyBlackUpgrade(1);
    } else if (move == 40) {
      inGameBlackStatusProvider.upgradeBlack(2);
      ref.read(inGameSystemNotificationProvider.notifier).notifyBlackUpgrade(2);
    } else if (move == 60) {
      inGameBlackStatusProvider.upgradeBlack(3);
      ref.read(inGameSystemNotificationProvider.notifier).notifyBlackUpgrade(3);
    } else if (move == 80) {
      inGameBlackStatusProvider.upgradeBlack(4);
      ref.read(inGameSystemNotificationProvider.notifier).notifyBlackUpgrade(4);
    } else if (move == 100) {
      inGameBlackStatusProvider.upgradeBlack(5);
      ref.read(inGameSystemNotificationProvider.notifier).notifyBlackUpgrade(5);
    }

    /// spawnMove 마다 백 기물 부활
    if (move % inGameBlackStatusProvider.spawnMove != 0) {
      return;
    }

    final blackSpawnPositionList = <PieceActionableEntity>[];

    /// 흑 기물 부활 자리 찾기
    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 3; j++) {
        final whitePlace = inGameBoardStatus.getStatus(i, j);
        if (whitePlace is PieceActionableEntity) {
          blackSpawnPositionList.add(whitePlace);
        }
      }
    }

    /// 흑 진영에 부활할 자리가 없으면 백 진영 포함 나머지 구역 조사
    if (blackSpawnPositionList.isEmpty) {
      for (int i = 0; i < 8; i++) {
        for (int j = 3; j < 6; j++) {
          final whitePlace = inGameBoardStatus.getStatus(i, j);
          if (whitePlace is PieceActionableEntity) {
            blackSpawnPositionList.add(whitePlace);
          }
        }
      }
    }

    /// 그래도 없으면 함수 종료
    if (blackSpawnPositionList.isEmpty) {
      return;
    }

    final pieceTypeNumberRange = Random().nextInt(100);
    final blackSpawnPositionNumber =
        Random().nextInt(blackSpawnPositionList.length);

    late PieceBaseEntity spawnBlackPiece;
    final blackPiecePlace = blackSpawnPositionList[blackSpawnPositionNumber];

    /// 기물 부활 확률
    if (pieceTypeNumberRange >=
            inGameBlackStatusProvider.queenSpawnStartRange &&
        pieceTypeNumberRange < inGameBlackStatusProvider.queenSpawnEndRange) {
      spawnBlackPiece = BlackQueenEntity(
          x: blackPiecePlace.targetX, y: blackPiecePlace.targetY);
    } else if (pieceTypeNumberRange >=
            inGameBlackStatusProvider.rookSpawnStartRange &&
        pieceTypeNumberRange < inGameBlackStatusProvider.rookSpawnEndRange) {
      spawnBlackPiece = BlackRookEntity(
          x: blackPiecePlace.targetX, y: blackPiecePlace.targetY);
    } else if (pieceTypeNumberRange >=
            inGameBlackStatusProvider.knightSpawnStartRange &&
        pieceTypeNumberRange < inGameBlackStatusProvider.knightSpawnEndRange) {
      spawnBlackPiece = BlackKnightEntity(
          x: blackPiecePlace.targetX, y: blackPiecePlace.targetY);
    } else if (pieceTypeNumberRange >=
            inGameBlackStatusProvider.bishopSpawnStartRange &&
        pieceTypeNumberRange < inGameBlackStatusProvider.bishopSpawnEndRange) {
      spawnBlackPiece = BlackBishopEntity(
          x: blackPiecePlace.targetX, y: blackPiecePlace.targetY);
    } else {
      spawnBlackPiece = BlackPawnEntity(
          x: blackPiecePlace.targetX, y: blackPiecePlace.targetY);
    }

    ref
        .read(inGamePieceSetProvider.notifier)
        .spawnPiece(spawnBlackPiece, PieceSpawnType.spawn);
  }

  Future<PieceActionableEntity?> _blackAction() async {
    final minimaxResult =
        await _minimaxIsolate(inGameBlackStatusProvider.minimaxTreeDepth);

    if (minimaxResult.isEmpty) {
      return null;
    }

    final pieceX = minimaxResult[0];
    final pieceY = minimaxResult[1];
    final targetX = minimaxResult[2];
    final targetY = minimaxResult[3];
    final targetValue = minimaxResult[4];

    if (pieceX == null ||
        pieceY == null ||
        targetX == null ||
        targetY == null ||
        targetValue == null) {
      return null;
    }

    final piece =
        inGameBoardStatus.getStatus(pieceX, pieceY) as PieceBaseEntity;

    final pieceActionable = PieceActionableEntity(
        targetX: targetX, targetY: targetY, targetValue: targetValue);

    /// 기물 착수 ui 구현 위해서
    if (lastTurnPiece != null) {
      lastTurnPiece!.justTurn = false;
      lastTurnPiece!.setStateThisPiece!(() {});
    }

    piece.justTurn = true;
    piece.firstMove = true;
    lastTurnPiece = piece;

    /// 보드 상태 변경
    inGameBoardStatus.changeStatus(
      piece.x,
      piece.y,
      PieceActionableEntity(
        targetX: piece.x,
        targetY: piece.y,
        targetValue: 0,
      ),
    );

    /// 움직인 자리에 백 기물이 있다면 제거하기
    final status = inGameBoardStatus.getStatus(
        pieceActionable.targetX, pieceActionable.targetY);
    if (status is PieceBaseEntity) {
      if (status.team == Team.white) {
        ref
            .read(inGamePieceSetProvider.notifier)
            .removePiece(pieceActionable, PieceRemoveType.captured);
      }
    }

    inGameBoardStatus.changeStatus(
        pieceActionable.targetX, pieceActionable.targetY, piece);

    /// 기물 착수
    piece.x = pieceActionable.targetX;
    piece.y = pieceActionable.targetY;
    piece.setStateThisPiece!(() {});

    makePieceMoveSound();

    /// 흑 폰 프로모션
    if (piece is BlackPawnEntity && pieceActionable.targetY == 7) {
      await Future.delayed(const Duration(milliseconds: 500), () {
        /// 폰 제거
        ref
            .read(inGamePieceSetProvider.notifier)
            .removePiece(pieceActionable, PieceRemoveType.promotion);

        /// 1/4 확률
        final randomNumber = Random().nextInt(4);

        late PieceBaseEntity promotionPiece;

        switch (randomNumber) {
          case 0:
            promotionPiece = BlackQueenEntity(
                x: pieceActionable.targetX, y: pieceActionable.targetY);
            break;
          case 1:
            promotionPiece = BlackRookEntity(
                x: pieceActionable.targetX, y: pieceActionable.targetY);
            break;
          case 2:
            promotionPiece = BlackKnightEntity(
                x: pieceActionable.targetX, y: pieceActionable.targetY);
            break;
          case 3:
            promotionPiece = BlackBishopEntity(
                x: pieceActionable.targetX, y: pieceActionable.targetY);
            break;
        }

        /// 폰 프로모션
        ref
            .read(inGamePieceSetProvider.notifier)
            .spawnPiece(promotionPiece, PieceSpawnType.promotion);

        lastTurnPiece = promotionPiece;
      });
    }

    return pieceActionable;
  }

  void determineIfCheck() {
    bool targetKing = false;

    /// 흑의 기물 모두 조사
    final blackList = inGameBoardStatus.getBlackAll();

    for (PieceBaseEntity piece in blackList) {
      final blackPiece = piece as BlackPieceBaseEntity;

      blackPiece.searchActionable(inGameBoardStatus);
      blackPiece.doesThisPieceCallCheck();

      if (blackPiece.setStateThisPiece != null) {
        blackPiece.setStateThisPiece!(() {});
      }

      if (blackPiece.isTargetingKing) {
        targetKing = true;
      }
    }

    if (targetKing) {
      ref.read(inGameSystemNotificationProvider.notifier).notifyCheck();
    }
  }

  Future<List<int?>> _minimaxIsolate(int treeDepth) async {
    return await compute(
        _minimax, [treeDepth, inGameBoardStatus.boardStatusToJsonList(), 0]);
  }
}
