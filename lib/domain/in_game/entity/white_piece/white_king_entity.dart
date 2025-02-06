import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/find_white_piece.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final class WhiteKingEntity extends WhitePieceBaseEntity {
  WhiteKingEntity({
    required super.x,
    required super.y,
  }) : super(
          team: Team.white,
          pieceType: PieceType.king,
          value: 1000,
          pieceIcon: FaIcon(
            FontAwesomeIcons.solidChessKing,
            color: whiteColor,
            size: pieceIconSize,
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
  }
}
