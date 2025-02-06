import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_actionable_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final class BlackPawnEntity extends BlackPieceBaseEntity {
  BlackPawnEntity({
    required super.x,
    required super.y,
  }) : super(
          team: Team.black,
          pieceType: PieceType.pawn,
          value: 1,
          pieceIcon: SizedBox(
            width: pieceIconSize,
            height: pieceIconSize,
            child: FittedBox(
              child: FaIcon(
                FontAwesomeIcons.solidChessPawn,
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

    /// 전진
    if (y < 7) {
      final status = statusBoard.getStatus(x, y + 1);

      if (status is PieceActionableEntity) {
        pieceActionable.add(
          PieceActionableEntity(
            targetX: status.targetX,
            targetY: status.targetY,
            targetValue: 0,
          ),
        );
      }
    }

    /// 처음 움직일 때 2칸 전진
    if (!firstMove) {
      if (y < 6) {
        final status = statusBoard.getStatus(x, y + 1);

        if (status is PieceActionableEntity) {
          final status = statusBoard.getStatus(x, y + 2);

          if (status is PieceActionableEntity) {
            pieceActionable.add(
              PieceActionableEntity(
                targetX: status.targetX,
                targetY: status.targetY,
                targetValue: 0,
              ),
            );
          }
        }
      }
    }

    /// 대각선 잡기
    ///
    /// 대각선 왼쪽
    if (x > 0 && y < 7) {
      final status = statusBoard.getStatus(x - 1, y + 1);

      if (status is WhitePieceBaseEntity) {
        pieceActionable.add(
          PieceActionableEntity(
            targetX: status.x,
            targetY: status.y,
            targetValue: status.value,
          ),
        );
      }
    }

    /// 대각선 오른쪽
    if (x < 7 && y < 7) {
      final status = statusBoard.getStatus(x + 1, y + 1);

      if (status is WhitePieceBaseEntity) {
        pieceActionable.add(
          PieceActionableEntity(
            targetX: status.x,
            targetY: status.y,
            targetValue: status.value,
          ),
        );
      }
    }
  }
}
