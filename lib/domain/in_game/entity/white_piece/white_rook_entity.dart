import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/find_white_piece.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final class WhiteRookEntity extends WhitePieceBaseEntity {
  WhiteRookEntity({
    required super.x,
    required super.y,
    super.firstMove,
    super.doubleMove,
  }) : super(
         team: Team.white,
         pieceType: PieceType.rook,
         value: 50,
         pieceIcon: SizedBox(
           width: pieceIconSize,
           height: pieceIconSize,
           child: FittedBox(
             child: FaIcon(FontAwesomeIcons.solidChessRook, color: whiteColor),
           ),
         ),
       );

  @override
  void searchActionable(InGameBoardStatus statusBoard) {
    /// 현재 액션 가능한 리스트를 비워준다.
    pieceActionable.clear();

    /// 기물이 갈 수 있는 길을 찾아서 리스트에 넣는다.
    /// for문 break를 원할 시 true 반환
    bool whiteRookStatusProcessing(int x, int y) {
      final status = statusBoard.getStatus(x, y);
      if (status is PieceBaseEntity) {
        if (status.team == Team.white) {
          return true;
        } else {
          findWhiteActions(status, pieceActionable);
          return true;
        }
      } else {
        findWhiteActions(status, pieceActionable);
        return false;
      }
    }

    /// 위
    for (int i = y - 1; i >= 0; i--) {
      final breakNow = whiteRookStatusProcessing(x, i);
      if (breakNow) break;
    }

    /// 아래
    for (int i = y + 1; i <= 7; i++) {
      final breakNow = whiteRookStatusProcessing(x, i);
      if (breakNow) break;
    }

    /// 왼쪽
    for (int i = x - 1; i >= 0; i--) {
      final breakNow = whiteRookStatusProcessing(i, y);
      if (breakNow) break;
    }

    /// 오른쪽
    for (int i = x + 1; i <= 7; i++) {
      final breakNow = whiteRookStatusProcessing(i, y);
      if (breakNow) break;
    }
  }
}
