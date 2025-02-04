import 'package:chess_defense/domain/in_game/entity/piece_actionable_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';

final class InGameBoardStatus {
  List<List<PieceOrJustActionable>> boardStatus = List.generate(
      8,
      (x) => List<PieceOrJustActionable>.generate(
          8,
          (y) =>
              PieceActionableEntity(targetX: x, targetY: y, targetValue: 0)));

  void initStatusBoard() {
    boardStatus = List.generate(
        8,
        (x) => List<PieceOrJustActionable>.generate(
            8,
            (y) =>
                PieceActionableEntity(targetX: x, targetY: y, targetValue: 0)));
  }

  PieceOrJustActionable getStatus(int x, int y) => boardStatus[x][y];

  void changeStatus(int x, int y, PieceOrJustActionable pieceModel) =>
      boardStatus[x][y] = pieceModel;

  /// 흑 행마 조사 (미니맥스, 체크)
  List<PieceBaseEntity> getBlackAll() {
    final blackList = <PieceBaseEntity>[];

    for (List<PieceOrJustActionable> pieceList in boardStatus) {
      for (PieceOrJustActionable piece in pieceList) {
        if (piece is PieceBaseEntity) {
          if (piece.team == Team.black) {
            blackList.add(piece);
          }
        }
      }
    }

    return blackList;
  }

  /// 흑 기물 개수 -> 한나라 기물이 40개 이상이면 게임 종료
  /// 흑이 공격을 안하고 무한 반복수 하는 경우를 방비
  int getNumOfRed() {
    final redList = getBlackAll();

    return redList.length;
  }

  /// 백 행마 조사 (미니맥스)
  List<PieceBaseEntity> getBlueAll() {
    final whiteList = <PieceBaseEntity>[];

    for (List<PieceOrJustActionable> pieceList in boardStatus) {
      for (PieceOrJustActionable piece in pieceList) {
        if (piece is PieceBaseEntity) {
          if (piece.team == Team.white) {
            whiteList.add(piece);
          }
        }
      }
    }

    return whiteList;
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
        }
      }
    }

    return inGameSaveDataList;
  }

  /// 저장된 게임 데이터로 초기화
  // void initStatusBoardWithSavedData(List<String> savedData) {
  //   initStatusBoard();
  //
  //   for (int i = 2; i < savedData.length; i += 4) {
  //     late PieceBaseEntity pieceEntity;
  //
  //     final team = Team.values.byName(savedData[i + 0]);
  //     final pieceType = PieceType.values.byName(savedData[i + 1]);
  //     final x = int.parse(savedData[i + 2]);
  //     final y = int.parse(savedData[i + 3]);
  //
  //     /// 백
  //     if (team == Team.white) {
  //       switch (pieceType) {
  //         case PieceType.king:
  //         case PieceType.queen:
  //         case PieceType.rook:
  //         case PieceType.knight:
  //         case PieceType.bishop:
  //         case PieceType.pawn:
  //       }
  //       // if (pieceType == PieceType.king) {
  //       //   pieceModel = BlueKingModel(x: x, y: y);
  //       // } else if (pieceType == PieceType.sa) {
  //       //   pieceModel = BlueSaModel(x: x, y: y);
  //       // } else if (pieceType == PieceType.cha) {
  //       //   pieceModel = BlueChaModel(x: x, y: y);
  //       // } else if (pieceType == PieceType.po) {
  //       //   pieceModel = BluePoModel(x: x, y: y);
  //       // } else if (pieceType == PieceType.ma) {
  //       //   pieceModel = BlueMaModel(x: x, y: y);
  //       // } else if (pieceType == PieceType.sang) {
  //       //   pieceModel = BlueSangModel(x: x, y: y);
  //       // } else {
  //       //   pieceModel = BlueZolModel(x: x, y: y);
  //       // }
  //     }
  //
  //     /// 흑
  //     else {
  //       switch (pieceType) {
  //         case PieceType.queen:
  //         case PieceType.rook:
  //         case PieceType.knight:
  //         case PieceType.bishop:
  //         case PieceType.pawn:
  //         default:
  //       }
  //       // if (pieceType == PieceType.cha) {
  //       //   pieceModel = RedChaModel(x: x, y: y);
  //       // } else if (pieceType == PieceType.po) {
  //       //   pieceModel = RedPoModel(x: x, y: y);
  //       // } else if (pieceType == PieceType.ma) {
  //       //   pieceModel = RedMaModel(x: x, y: y);
  //       // } else if (pieceType == PieceType.sang) {
  //       //   pieceModel = RedSangModel(x: x, y: y);
  //       // } else {
  //       //   pieceModel = RedByungModel(x: x, y: y);
  //       // }
  //     }
  //     changeStatus(pieceEntity.x, pieceEntity.y, pieceEntity);
  //   }
  // }

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
          };

          boardStatusJsonList.add(refineData);
        }
      }
    }

    return boardStatusJsonList;
  }

  /// 저장된 게임 데이터로 초기화 (미니맥스)
// void boardStatusFromJsonList(List<Map<String, dynamic>> boardStatusJsonList) {
//   initStatusBoard();
//
//   for (Map<String, dynamic> boardStatusJson in boardStatusJsonList) {
//     late PieceBaseEntity pieceEntity;
//
//     final team = Team.values.byName(boardStatusJson['team']);
//     final pieceType = PieceType.values.byName(boardStatusJson['pieceType']);
//     final x = int.parse(boardStatusJson['x']);
//     final y = int.parse(boardStatusJson['y']);
//
//     /// 백
//     if (team == Team.white) {
//             switch (pieceType) {
//               case PieceType.king:
//               case PieceType.queen:
//               case PieceType.rook:
//               case PieceType.knight:
//               case PieceType.bishop:
//               case PieceType.pawn:
//             }
//       // if (boardStatusJson['pieceType'] == PieceType.king.name) {
//       //   pieceModel =
//       //       BlueKingModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // } else if (boardStatusJson['pieceType'] == PieceType.sa.name) {
//       //   pieceModel =
//       //       BlueSaModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // } else if (boardStatusJson['pieceType'] == PieceType.cha.name) {
//       //   pieceModel =
//       //       BlueChaModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // } else if (boardStatusJson['pieceType'] == PieceType.po.name) {
//       //   pieceModel =
//       //       BluePoModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // } else if (boardStatusJson['pieceType'] == PieceType.ma.name) {
//       //   pieceModel =
//       //       BlueMaModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // } else if (boardStatusJson['pieceType'] == PieceType.sang.name) {
//       //   pieceModel =
//       //       BlueSangModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // } else if (boardStatusJson['pieceType'] == PieceType.zol.name) {
//       //   pieceModel =
//       //       BlueZolModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // }
//     }
//
//     /// 흑
//     else {
//       switch (pieceType) {
//         case PieceType.queen:
//         case PieceType.rook:
//         case PieceType.knight:
//         case PieceType.bishop:
//         case PieceType.pawn:
//         default:
//       }
//       // if (boardStatusJson['pieceType'] == PieceType.cha.name) {
//       //   pieceModel =
//       //       RedChaModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // } else if (boardStatusJson['pieceType'] == PieceType.po.name) {
//       //   pieceModel =
//       //       RedPoModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // } else if (boardStatusJson['pieceType'] == PieceType.ma.name) {
//       //   pieceModel =
//       //       RedMaModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // } else if (boardStatusJson['pieceType'] == PieceType.sang.name) {
//       //   pieceModel =
//       //       RedSangModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // } else if (boardStatusJson['pieceType'] == PieceType.byung.name) {
//       //   pieceModel =
//       //       RedByungModel(x: boardStatusJson['x'], y: boardStatusJson['y']);
//       // }
//     }
//     changeStatus(pieceEntity.x, pieceEntity.y, pieceEntity);
//   }
// }
}

InGameBoardStatus inGameBoardStatus = InGameBoardStatus();
