import 'package:chess_defense/data/in_game/repository/in_game_saved_data_repository.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_bishop_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_knight_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_pawn_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_queen_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_rook_entity.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_actionable_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_bishop_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_king_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_queen_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_rook_entity.dart';
import 'package:chess_defense/provider/in_game/in_game_black_status.dart';
import 'package:chess_defense/provider/in_game/in_game_gold_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_move_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_system_notification_provider.dart';
import 'package:chess_defense/provider/in_game/in_game_turn_provider.dart';
import 'package:chess_defense/ui/audio/controller/audio_play.dart';
import 'package:chess_defense/ui/in_game/controller/get_gold_notification.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_selected_piece_entity.dart';
import 'package:chess_defense/ui/in_game/widget/in_game_piece.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_game_piece_set_provider.g.dart';

Map<PieceType, int> _numOfPiece = {
  PieceType.king: 1,
  PieceType.queen: 1,
  PieceType.rook: 2,
  PieceType.knight: 2,
  PieceType.bishop: 2,
  PieceType.pawn: 8,
};

@Riverpod()
final class InGamePieceSet extends _$InGamePieceSet {
  @override
  List<InGamePiece> build() {
    return <InGamePiece>[];
  }

  void initPieceSet() {
    /// 상태보드 백기화
    inGameBoardStatus.initStatusBoard();

    inGameBlackStatusProvider.upgradeBlack(0);

    selectedPieceEntity = null;
    lastTurnPiece = null;

    _numOfPiece = {
      PieceType.king: 1,
      PieceType.queen: 1,
      PieceType.rook: 2,
      PieceType.knight: 2,
      PieceType.bishop: 2,
      PieceType.pawn: 8,
    };

    ref.read(inGameOnTheRopesProvider.notifier).initOnTheRopes();

    /// 백 기물 세팅
    spawnPiece(WhiteKingEntity(x: 4, y: 7), true);

    spawnPiece(WhiteQueenEntity(x: 3, y: 7), true);
    //
    spawnPiece(WhiteRookEntity(x: 0, y: 7), true);
    spawnPiece(WhiteRookEntity(x: 7, y: 7), true);
    //
    // spawnPiece(WhiteKnightEntity(x: 1, y: 7), true);
    // spawnPiece(WhiteKnightEntity(x: 6, y: 7), true);
    //
    spawnPiece(WhiteBishopEntity(x: 2, y: 7), true);
    spawnPiece(WhiteBishopEntity(x: 5, y: 7), true);
    //
    // spawnPiece(WhitePawnEntity(x: 0, y: 6), true);
    // spawnPiece(WhitePawnEntity(x: 1, y: 6), true);
    // spawnPiece(WhitePawnEntity(x: 2, y: 6), true);
    // spawnPiece(WhitePawnEntity(x: 3, y: 6), true);
    // spawnPiece(WhitePawnEntity(x: 4, y: 6), true);
    // spawnPiece(WhitePawnEntity(x: 5, y: 6), true);
    // spawnPiece(WhitePawnEntity(x: 6, y: 6), true);
    // spawnPiece(WhitePawnEntity(x: 7, y: 6), true);

    /// 흑 기물 세팅
    spawnPiece(BlackQueenEntity(x: 3, y: 0), true);

    spawnPiece(BlackRookEntity(x: 0, y: 0), true);
    spawnPiece(BlackRookEntity(x: 7, y: 0), true);

    spawnPiece(BlackKnightEntity(x: 1, y: 0), true);
    spawnPiece(BlackKnightEntity(x: 6, y: 0), true);

    spawnPiece(BlackBishopEntity(x: 2, y: 0), true);
    spawnPiece(BlackBishopEntity(x: 5, y: 0), true);

    spawnPiece(BlackPawnEntity(x: 0, y: 1), true);
    spawnPiece(BlackPawnEntity(x: 1, y: 1), true);
    spawnPiece(BlackPawnEntity(x: 2, y: 1), true);
    spawnPiece(BlackPawnEntity(x: 3, y: 1), true);
    spawnPiece(BlackPawnEntity(x: 4, y: 1), true);
    spawnPiece(BlackPawnEntity(x: 5, y: 1), true);
    spawnPiece(BlackPawnEntity(x: 6, y: 1), true);
    spawnPiece(BlackPawnEntity(x: 7, y: 1), true);

    state = List.from(state);
    makeGameStartSound();
  }

  Future<void> initPieceWithSavedData() async {
    final inGameSavedData = await InGameSavedDataRepository().getSavedData();
    final move = int.parse(inGameSavedData[0]);
    final inGameGold = int.parse(inGameSavedData[1]);

    ref.read(inGameMoveProvider.notifier).setMove(move);
    ref.read(inGameGoldProvider.notifier).setInGameGold(inGameGold);

    ref.read(inGameOnTheRopesProvider.notifier).initOnTheRopes();

    if (move < 20) {
      inGameBlackStatusProvider.upgradeBlack(0);
    } else if (move < 40) {
      inGameBlackStatusProvider.upgradeBlack(1);
    } else if (move < 60) {
      inGameBlackStatusProvider.upgradeBlack(2);
    } else if (move < 80) {
      inGameBlackStatusProvider.upgradeBlack(3);
    } else if (move < 100) {
      inGameBlackStatusProvider.upgradeBlack(4);
    } else {
      inGameBlackStatusProvider.upgradeBlack(5);
    }

    inGameBoardStatus.initStatusBoardWithSavedData(inGameSavedData);

    selectedPieceEntity = null;
    lastTurnPiece = null;

    Map<PieceType, int> numOfPieceInit = {
      PieceType.king: 0,
      PieceType.queen: 0,
      PieceType.rook: 0,
      PieceType.knight: 0,
      PieceType.bishop: 0,
      PieceType.pawn: 0,
    };

    _numOfPiece = numOfPieceInit;

    final statusBoard = inGameBoardStatus.boardStatus;

    for (List<PieceOrJustActionable> statusList in statusBoard) {
      for (PieceOrJustActionable status in statusList) {
        if (status is PieceBaseEntity) {
          spawnPiece(status, true);

          if (status.team == Team.white) {
            _numOfPiece[status.pieceType] = _numOfPiece[status.pieceType]! + 1;
          }
        }
      }
    }

    state = List.from(state);

    makeGameStartSound();

    Future.delayed(const Duration(seconds: 1), () {
      ref.read(inGameTurnProvider.notifier).determineIfCheck();
    });
  }

  /// 기물 부활
  void spawnPiece(PieceBaseEntity pieceEntity, [bool isInit = false]) {
    /// ref.watch가 state가 변경될 때마다 위젯을 다시 빌드하게 하지만, state 자체가 변경된 횟수와 관계없이 최종적으로 변경된 상태에서만 빌드됩니다.
    /// Flutter와 Riverpod의 작동 방식에서 ref.watch는 state 객체가 변경되었을 때 반응하지만, 상태 변경이 하나의 이벤트처럼 처리되므로 중간에 변경된 모든 state를 각각 렌더링하지 않습니다.
    /// 출처: ChatGPT
    ///
    /// 그럼에도 불구하고 코드 분기처리하여 안전하게 작성하기
    if (isInit) {
      inGameBoardStatus.changeStatus(pieceEntity.x, pieceEntity.y, pieceEntity);
      state.add(InGamePiece(key: GlobalKey(), pieceEntity: pieceEntity));
    } else {
      if (pieceEntity.team == Team.white) {
        /// 폰은 최대 8개
        if (pieceEntity.pieceType == PieceType.pawn) {
          if (_numOfPiece[pieceEntity.pieceType]! >= 8) {
            ref
                .read(inGameSystemNotificationProvider.notifier)
                .notifySystemError(1);
            return;
          }
        }

        /// 퀸은 최대 1개
        else if (pieceEntity.pieceType == PieceType.queen) {
          if (_numOfPiece[pieceEntity.pieceType]! >= 1) {
            ref
                .read(inGameSystemNotificationProvider.notifier)
                .notifySystemError(1);
            return;
          }
        }

        /// 룩, 나이트, 비숍은 최대 2개
        else {
          if (_numOfPiece[pieceEntity.pieceType]! >= 2) {
            ref
                .read(inGameSystemNotificationProvider.notifier)
                .notifySystemError(1);
            return;
          }
        }

        final gold = ref.read(inGameGoldProvider);

        if (gold < pieceEntity.value) {
          ref
              .read(inGameSystemNotificationProvider.notifier)
              .notifySystemError(0);
          return;
        }

        /// 모든 조건이 맞을 때

        /// 골드 차감
        ref
            .read(inGameGoldProvider.notifier)
            .setInGameGold(gold - pieceEntity.value);

        /// 기물 수 증가
        _numOfPiece[pieceEntity.pieceType] =
            _numOfPiece[pieceEntity.pieceType]! + 1;

        /// 골드 노티피케이션
        ref
            .read(getGoldNotificationWidgetProvider.notifier)
            .showGoldNotification(false, pieceEntity.value);
      }

      /// 상태 변경
      inGameBoardStatus.changeStatus(pieceEntity.x, pieceEntity.y, pieceEntity);
      final newState = state;
      newState.add(InGamePiece(key: GlobalKey(), pieceEntity: pieceEntity));
      state = newState;

      makePieceSpawnSound(pieceEntity.pieceType);
    }
  }

  /// 기물 제거
  void removePiece(PieceActionableEntity pieceActionable,
      [bool isExecute = false]) {
    final gold = ref.read(inGameGoldProvider);
    final targetPieceModel = inGameBoardStatus.getStatus(
        pieceActionable.targetX, pieceActionable.targetY);

    if (isExecute) {
      if (gold < 300) {
        ref
            .read(inGameSystemNotificationProvider.notifier)
            .notifySystemError(0);
        return;
      }

      /// 골드 차감
      ref.read(inGameGoldProvider.notifier).setInGameGold(gold - 300);

      /// 골드 노티피케이션
      ref
          .read(getGoldNotificationWidgetProvider.notifier)
          .showGoldNotification(false, 300);

      /// 처형 기물이 방금 움직인 기물
      if (targetPieceModel == lastTurnPiece) {
        lastTurnPiece = null;
      }

      /// 처형 기물이 방금 탭한 기물
      if (targetPieceModel == selectedPieceEntity) {
        selectedPieceEntity = null;
      }

      makeExecuteOrCheckSound();
    } else {
      /// 처형이 아닌 단순 기물 공격, 백이 흑 기물을 취함
      if (targetPieceModel is PieceBaseEntity) {
        if (targetPieceModel.team == Team.black) {
          /// 골드 증액
          ref
              .read(inGameGoldProvider.notifier)
              .setInGameGold(gold + pieceActionable.targetValue);

          /// 골드 노티피케이션
          ref
              .read(getGoldNotificationWidgetProvider.notifier)
              .showGoldNotification(true, targetPieceModel.value);

          makePieceKilledSound(Team.black);
        } else {
          makePieceKilledSound(Team.white);
        }
      }
    }

    /// 제거되는 대상이 백 기물이면 기물 수 차감
    if (targetPieceModel is PieceBaseEntity) {
      if (targetPieceModel.team == Team.white) {
        _numOfPiece[targetPieceModel.pieceType] =
            _numOfPiece[targetPieceModel.pieceType]! - 1;
      }
    }

    inGameBoardStatus.changeStatus(
      pieceActionable.targetX,
      pieceActionable.targetY,
      PieceActionableEntity(
        targetX: pieceActionable.targetX,
        targetY: pieceActionable.targetY,
        targetValue: 0,
      ),
    );
    final newState = state;
    newState.removeWhere(
      (piece) =>
          pieceActionable.targetX == piece.pieceEntity.x &&
          pieceActionable.targetY == piece.pieceEntity.y,
    );
    state = List.from(newState);
  }
}
