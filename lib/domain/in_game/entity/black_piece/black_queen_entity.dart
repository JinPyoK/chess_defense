import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/find_black_piece.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final class BlackQueenEntity extends BlackPieceBaseEntity {
  BlackQueenEntity({
    required super.x,
    required super.y,
    super.firstMove,
    super.doubleMove,
  }) : super(
         team: Team.black,
         pieceType: PieceType.queen,
         value: 9,
         pieceIcon: SizedBox(
           width: pieceIconSize,
           height: pieceIconSize,
           child: FittedBox(
             child: FaIcon(FontAwesomeIcons.solidChessQueen, color: blackColor),
           ),
         ),
       );

  @override
  void searchActionable(InGameBoardStatus statusBoard) {
    /// 현재 액션 가능한 리스트를 비워준다.
    pieceActionable.clear();

    /// 기물이 갈 수 있는 길을 찾아서 리스트에 넣는다.
    /// for문 break를 원할 시 true 반환
    bool blackQueenStatusProcessing(int x, int y) {
      final status = statusBoard.getStatus(x, y);
      if (status is PieceBaseEntity) {
        if (status.team == Team.black) {
          return true;
        } else {
          findBlackActions(status, pieceActionable);
          return true;
        }
      } else {
        findBlackActions(status, pieceActionable);
        return false;
      }
    }

    /// 직선
    ///
    /// 위
    for (int i = y - 1; i >= 0; i--) {
      final breakNow = blackQueenStatusProcessing(x, i);
      if (breakNow) break;
    }

    /// 아래
    for (int i = y + 1; i <= 7; i++) {
      final breakNow = blackQueenStatusProcessing(x, i);
      if (breakNow) break;
    }

    /// 왼쪽
    for (int i = x - 1; i >= 0; i--) {
      final breakNow = blackQueenStatusProcessing(i, y);
      if (breakNow) break;
    }

    /// 오른쪽
    for (int i = x + 1; i <= 7; i++) {
      final breakNow = blackQueenStatusProcessing(i, y);
      if (breakNow) break;
    }

    /// 대각선
    ///
    /// 왼쪽 위
    for (int i = x - 1, j = y - 1; i >= 0 && j >= 0; i--, j--) {
      final breakNow = blackQueenStatusProcessing(i, j);
      if (breakNow) break;
    }

    /// 오른쪽 위
    for (int i = x + 1, j = y - 1; i <= 7 && j >= 0; i++, j--) {
      final breakNow = blackQueenStatusProcessing(i, j);
      if (breakNow) break;
    }

    /// 왼쪽 아래
    for (int i = x - 1, j = y + 1; i >= 0 && j <= 7; i--, j++) {
      final breakNow = blackQueenStatusProcessing(i, j);
      if (breakNow) break;
    }

    /// 오른쪽 아래
    for (int i = x + 1, j = y + 1; i <= 7 && j <= 7; i++, j++) {
      final breakNow = blackQueenStatusProcessing(i, j);
      if (breakNow) break;
    }
  }
}
