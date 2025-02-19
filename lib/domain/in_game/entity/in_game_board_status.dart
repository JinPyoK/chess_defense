import 'package:chess_defense/domain/in_game/entity/black_piece/black_bishop_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_knight_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_pawn_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_queen_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_rook_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_actionable_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_bishop_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_king_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_knight_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_pawn_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_queen_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_rook_entity.dart';

final class InGameBoardStatus {
  List<List<PieceOrJustActionable>> boardStatus = List.generate(
    8,
    (x) => List<PieceOrJustActionable>.generate(
      8,
      (y) => PieceActionableEntity(targetX: x, targetY: y, targetValue: 0),
    ),
  );

  void initStatusBoard() {
    boardStatus = List.generate(
      8,
      (x) => List<PieceOrJustActionable>.generate(
        8,
        (y) => PieceActionableEntity(targetX: x, targetY: y, targetValue: 0),
      ),
    );
  }

  PieceOrJustActionable getStatus(int x, int y) => boardStatus[x][y];

  void changeStatus(int x, int y, PieceOrJustActionable pieceModel) =>
      boardStatus[x][y] = pieceModel;

  /// 흑 기물 조사 (미니맥스, 체크)
  List<PieceBaseEntity> getBlackAll() {
    final blackList = <PieceBaseEntity>[];

    for (List<PieceOrJustActionable> pieceList in boardStatus) {
      for (PieceOrJustActionable piece in pieceList) {
        if (piece is BlackPieceBaseEntity) {
          blackList.add(piece);
        }
      }
    }

    return blackList;
  }

  /// 흑 기물 개수 -> 흑 기물이 40개 이상이면 게임 종료
  /// 흑이 공격을 안하고 무한 반복수 하는 경우를 방비
  int getNumOfBlack() {
    final blackList = getBlackAll();

    return blackList.length;
  }

  /// 백 기물 조사 (미니맥스)
  List<PieceBaseEntity> getWhiteAll() {
    final whiteList = <PieceBaseEntity>[];

    for (List<PieceOrJustActionable> pieceList in boardStatus) {
      for (PieceOrJustActionable piece in pieceList) {
        if (piece is WhitePieceBaseEntity) {
          whiteList.add(piece);
        }
      }
    }

    return whiteList;
  }

  /// 흑의 모든 행마 조사 (캐슬링 조건: 왕이 움직이는 자리에 흑이 공격할 수 있는지 조사)
  List<PieceActionableEntity> getBlackActionableAll() {
    final blackActionableList = <PieceActionableEntity>[];

    for (List<PieceOrJustActionable> pieceList in boardStatus) {
      for (PieceOrJustActionable piece in pieceList) {
        if (piece is BlackPieceBaseEntity) {
          piece.searchActionable(inGameBoardStatus);
          blackActionableList.addAll(piece.pieceActionable);
        }
      }
    }

    return blackActionableList;
  }

  /// 앙파상: 흑 기물의 모든 doubleMove를 false로 초기화
  void initBlackDoubleMove() {
    for (List<PieceOrJustActionable> pieceList in boardStatus) {
      for (PieceOrJustActionable piece in pieceList) {
        if (piece is BlackPieceBaseEntity) {
          piece.doubleMove = false;
        }
      }
    }
  }

  /// 앙파상: 백 기물의 모든 doubleMove를 false로 초기화
  void initWhiteDoubleMove() {
    for (List<PieceOrJustActionable> pieceList in boardStatus) {
      for (PieceOrJustActionable piece in pieceList) {
        if (piece is WhitePieceBaseEntity) {
          piece.doubleMove = false;
        }
      }
    }
  }

  /// 게임 저장 데이터 수집
  List<String> refinePieceEntityForSave() {
    final inGameSaveDataList = <String>[];

    for (List<PieceOrJustActionable> statusList in boardStatus) {
      for (PieceOrJustActionable status in statusList) {
        if (status is PieceBaseEntity) {
          inGameSaveDataList.add(status.team.name);
          inGameSaveDataList.add(status.pieceType.name);
          inGameSaveDataList.add(status.x.toString());
          inGameSaveDataList.add(status.y.toString());
          inGameSaveDataList.add(status.firstMove.toString());
          inGameSaveDataList.add(status.doubleMove.toString());
        }
      }
    }

    return inGameSaveDataList;
  }

  /// 저장된 게임 데이터로 백기화
  void initStatusBoardWithSavedData(List<String> savedData) {
    initStatusBoard();

    for (int i = 2; i < savedData.length; i += 6) {
      late PieceBaseEntity pieceEntity;

      final team = Team.values.byName(savedData[i + 0]);
      final pieceType = PieceType.values.byName(savedData[i + 1]);
      final x = int.parse(savedData[i + 2]);
      final y = int.parse(savedData[i + 3]);
      final firstMove = bool.parse(savedData[i + 4]);
      final doubleMove = bool.parse(savedData[i + 5]);

      /// 백
      if (team == Team.white) {
        switch (pieceType) {
          case PieceType.king:
            pieceEntity = WhiteKingEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.queen:
            pieceEntity = WhiteQueenEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.rook:
            pieceEntity = WhiteRookEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.knight:
            pieceEntity = WhiteKnightEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.bishop:
            pieceEntity = WhiteBishopEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.pawn:
            pieceEntity = WhitePawnEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
        }
      }
      /// 흑
      else {
        switch (pieceType) {
          case PieceType.queen:
            pieceEntity = BlackQueenEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.rook:
            pieceEntity = BlackRookEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.knight:
            pieceEntity = BlackKnightEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.bishop:
            pieceEntity = BlackBishopEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.pawn:
            pieceEntity = BlackPawnEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          default:
            pieceEntity = BlackPawnEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
        }
      }
      changeStatus(pieceEntity.x, pieceEntity.y, pieceEntity);
    }
  }

  /// 미니맥스 Isolate 데이터 전달 목적
  List<Map<String, dynamic>> boardStatusToJsonList() {
    final boardStatusJsonList = <Map<String, dynamic>>[];

    for (List<PieceOrJustActionable> statusList in boardStatus) {
      for (PieceOrJustActionable status in statusList) {
        if (status is PieceBaseEntity) {
          final refineData = {
            'team': status.team.name,
            'pieceType': status.pieceType.name,
            'x': status.x,
            'y': status.y,
            'firstMove': status.firstMove,
            'doubleMove': status.doubleMove,
          };

          boardStatusJsonList.add(refineData);
        }
      }
    }

    return boardStatusJsonList;
  }

  /// 저장된 게임 데이터로 초기화 (미니맥스)
  void boardStatusFromJsonList(List<Map<String, dynamic>> boardStatusJsonList) {
    initStatusBoard();

    for (Map<String, dynamic> boardStatusJson in boardStatusJsonList) {
      late PieceBaseEntity pieceEntity;

      final team = Team.values.byName(boardStatusJson['team']);
      final pieceType = PieceType.values.byName(boardStatusJson['pieceType']);
      final x = boardStatusJson['x'];
      final y = boardStatusJson['y'];
      final firstMove = boardStatusJson['firstMove'] as bool;
      final doubleMove = boardStatusJson['doubleMove'] as bool;

      /// 백
      if (team == Team.white) {
        switch (pieceType) {
          case PieceType.king:
            pieceEntity = WhiteKingEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.queen:
            pieceEntity = WhiteQueenEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.rook:
            pieceEntity = WhiteRookEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.knight:
            pieceEntity = WhiteKnightEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.bishop:
            pieceEntity = WhiteBishopEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.pawn:
            pieceEntity = WhitePawnEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
        }
      }
      /// 흑
      else {
        switch (pieceType) {
          case PieceType.queen:
            pieceEntity = BlackQueenEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.rook:
            pieceEntity = BlackRookEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.knight:
            pieceEntity = BlackKnightEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.bishop:
            pieceEntity = BlackBishopEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          case PieceType.pawn:
            pieceEntity = BlackPawnEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
          default:
            pieceEntity = BlackPawnEntity(
              x: x,
              y: y,
              firstMove: firstMove,
              doubleMove: doubleMove,
            );
        }
      }

      changeStatus(pieceEntity.x, pieceEntity.y, pieceEntity);
    }
  }
}

InGameBoardStatus inGameBoardStatus = InGameBoardStatus();
