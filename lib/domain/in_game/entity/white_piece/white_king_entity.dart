import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_actionable_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/find_white_piece.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_rook_entity.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final class WhiteKingEntity extends WhitePieceBaseEntity {
  WhiteKingEntity({
    required super.x,
    required super.y,
    super.firstMove,
    super.doubleMove,
  }) : super(
         team: Team.white,
         pieceType: PieceType.king,
         value: 1000,
         pieceIcon: SizedBox(
           width: pieceIconSize,
           height: pieceIconSize,
           child: FittedBox(
             child: FaIcon(FontAwesomeIcons.solidChessKing, color: whiteColor),
           ),
         ),
       );

  @override
  void searchActionable(InGameBoardStatus statusBoard) {
    /// 현재 액션 가능한 리스트를 비워준다.
    pieceActionable.clear();

    /// 기물이 갈 수 있는 길을 찾아서 리스트에 넣는다.

    /// 위
    if (y > 0) {
      findWhiteActions(statusBoard.getStatus(x, y - 1), pieceActionable);

      /// 위 왼쪽
      if (x > 0) {
        findWhiteActions(statusBoard.getStatus(x - 1, y - 1), pieceActionable);
      }

      /// 위 오른쪽
      if (x < 7) {
        findWhiteActions(statusBoard.getStatus(x + 1, y - 1), pieceActionable);
      }
    }

    /// 왼쪽
    if (x > 0) {
      findWhiteActions(statusBoard.getStatus(x - 1, y), pieceActionable);
    }

    /// 오른쪽
    if (x < 7) {
      findWhiteActions(statusBoard.getStatus(x + 1, y), pieceActionable);
    }

    /// 아래
    if (y < 7) {
      findWhiteActions(statusBoard.getStatus(x, y + 1), pieceActionable);

      /// 아래 왼쪽
      if (x > 0) {
        findWhiteActions(statusBoard.getStatus(x - 1, y + 1), pieceActionable);
      }

      /// 아래 오른쪽
      if (x < 7) {
        findWhiteActions(statusBoard.getStatus(x + 1, y + 1), pieceActionable);
      }
    }

    /// 캐슬링

    /// 캐슬링 조건 1: 왕이 한번도 움직이지 않았음
    if (!firstMove) {
      /// 왼쪽 룩
      final leftRook = statusBoard.getStatus(0, 7);

      /// 캐슬링 조건 2: 룩이 한번도 움직이지 않았음
      if (leftRook is WhiteRookEntity && leftRook.firstMove == false) {
        /// 캐슬링 조건 3: 룩과 킹 사이에 아무것도 없음
        final place1 = statusBoard.getStatus(1, 7);
        final place2 = statusBoard.getStatus(2, 7);
        final place3 = statusBoard.getStatus(3, 7);

        if (place1 is PieceActionableEntity &&
            place2 is PieceActionableEntity &&
            place3 is PieceActionableEntity) {
          /// 캐슬링 조건 4: 킹이 움직이는 자리에 흑이 공격할 수 없음
          final blackActionableList = statusBoard.getBlackActionableAll();

          bool place1 = true;
          bool place2 = true;
          bool place3 = true;

          for (PieceActionableEntity pa in blackActionableList) {
            if (pa.targetX == 2 && pa.targetY == 7) {
              place1 = false;
            } else if (pa.targetX == 3 && pa.targetY == 7) {
              place2 = false;
            } else if (pa.targetX == 4 && pa.targetY == 7) {
              place3 = false;
            }
          }

          if (place1 && place2 && place3) {
            pieceActionable.add(
              PieceActionableEntity(
                targetX: 0,
                targetY: 7,
                targetValue: 0,
                actionType: PieceActionType.castling,
              ),
            );
          }
        }
      }

      /// 오른쪽 룩
      final rightRook = statusBoard.getStatus(7, 7);

      /// 캐슬링 조건 2: 룩이 한번도 움직이지 않았음
      if (rightRook is WhiteRookEntity && rightRook.firstMove == false) {
        /// 캐슬링 조건 3: 룩과 킹 사이에 아무것도 없음
        final place1 = statusBoard.getStatus(5, 7);
        final place2 = statusBoard.getStatus(6, 7);

        if (place1 is PieceActionableEntity &&
            place2 is PieceActionableEntity) {
          /// 캐슬링 조건 4: 킹이 움직이는 자리에 흑이 공격할 수 없음
          final blackActionableList = statusBoard.getBlackActionableAll();

          bool place1 = true;
          bool place2 = true;
          bool place3 = true;

          for (PieceActionableEntity pa in blackActionableList) {
            if (pa.targetX == 4 && pa.targetY == 7) {
              place1 = false;
            } else if (pa.targetX == 5 && pa.targetY == 7) {
              place2 = false;
            } else if (pa.targetX == 6 && pa.targetY == 7) {
              place3 = false;
            }
          }

          if (place1 && place2 && place3) {
            pieceActionable.add(
              PieceActionableEntity(
                targetX: 7,
                targetY: 7,
                targetValue: 0,
                actionType: PieceActionType.castling,
              ),
            );
          }
        }
      }
    }
  }
}
