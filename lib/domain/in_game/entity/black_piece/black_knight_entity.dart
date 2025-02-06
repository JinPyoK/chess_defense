import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/find_black_piece.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final class BlackKnightEntity extends BlackPieceBaseEntity {
  BlackKnightEntity({
    required super.x,
    required super.y,
  }) : super(
          team: Team.black,
          pieceType: PieceType.knight,
          value: 3,
          pieceIcon: SizedBox(
            width: pieceIconSize,
            height: pieceIconSize,
            child: FittedBox(
              child: FaIcon(
                FontAwesomeIcons.solidChessKnight,
                color: blackColor,
              ),
            ),
          ),
        );

  @override
  void searchActionable(InGameBoardStatus statusBoard) {
    /// 현재 액션 가능한 리스트를 비워준다.
    pieceActionable.clear();

    /// 기물이 갈 수 있는 길을 찾아서 리스트에 넣는다.

    /// 위
    if (y > 1) {
      /// 왼쪽
      if (x > 0) {
        findBlackActions(statusBoard.getStatus(x - 1, y - 2), pieceActionable);
      }

      /// 오른쪽
      if (x < 7) {
        findBlackActions(statusBoard.getStatus(x + 1, y - 2), pieceActionable);
      }
    }

    /// 아래
    if (y < 6) {
      /// 왼쪽
      if (x > 0) {
        findBlackActions(statusBoard.getStatus(x - 1, y + 2), pieceActionable);
      }

      /// 오른쪽
      if (x < 7) {
        findBlackActions(statusBoard.getStatus(x + 1, y + 2), pieceActionable);
      }
    }

    /// 왼쪽
    if (x > 1) {
      /// 위
      if (y > 0) {
        findBlackActions(statusBoard.getStatus(x - 2, y - 1), pieceActionable);
      }

      /// 아래
      if (y < 7) {
        findBlackActions(statusBoard.getStatus(x - 2, y + 1), pieceActionable);
      }
    }

    /// 오른쪽
    if (x < 6) {
      /// 위
      if (y > 0) {
        findBlackActions(statusBoard.getStatus(x + 2, y - 1), pieceActionable);
      }

      /// 아래
      if (y < 7) {
        findBlackActions(statusBoard.getStatus(x + 2, y + 1), pieceActionable);
      }
    }
  }
}
