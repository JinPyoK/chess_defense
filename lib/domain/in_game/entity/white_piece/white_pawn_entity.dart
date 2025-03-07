import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_pawn_entity.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_actionable_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/domain/in_game/entity/special_moves_constant_value.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final class WhitePawnEntity extends WhitePieceBaseEntity {
  WhitePawnEntity({
    required super.x,
    required super.y,
    super.firstMove,
    super.doubleMove,
  }) : super(
         team: Team.white,
         pieceType: PieceType.pawn,
         value: 10,
         pieceIcon: SizedBox(
           width: pieceIconSize,
           height: pieceIconSize,
           child: FittedBox(
             child: FaIcon(FontAwesomeIcons.solidChessPawn, color: whiteColor),
           ),
         ),
       );

  @override
  void searchActionable(InGameBoardStatus statusBoard) {
    /// 현재 액션 가능한 리스트를 비워준다.
    pieceActionable.clear();

    /// 기물이 갈 수 있는 길을 찾아서 리스트에 넣는다.

    /// 전진
    if (y > 0) {
      final status = statusBoard.getStatus(x, y - 1);

      if (status is PieceActionableEntity) {
        /// 프로모션 가치 더해주기
        final promotionValue = status.targetY == 0 ? promotionVal : 0;

        pieceActionable.add(
          PieceActionableEntity(
            targetX: status.targetX,
            targetY: status.targetY,
            targetValue: promotionValue,
          ),
        );
      }
    }

    /// 처음 움직일 때 2칸 전진
    if (!firstMove) {
      if (y > 1) {
        final status = statusBoard.getStatus(x, y - 1);

        if (status is PieceActionableEntity) {
          final status = statusBoard.getStatus(x, y - 2);

          if (status is PieceActionableEntity) {
            pieceActionable.add(
              PieceActionableEntity(
                targetX: status.targetX,
                targetY: status.targetY,
                targetValue: 0,
                actionType: PieceActionType.doubleMove,
              ),
            );
          }
        }
      }
    }

    /// 대각선 잡기
    ///
    /// 대각선 왼쪽
    if (x > 0 && y > 0) {
      final status = statusBoard.getStatus(x - 1, y - 1);

      if (status is BlackPieceBaseEntity) {
        /// 프로모션 가치 더해주기
        final promotionValue = status.y == 0 ? promotionVal : 0;

        pieceActionable.add(
          PieceActionableEntity(
            targetX: status.x,
            targetY: status.y,
            targetValue: status.value + promotionValue,
          ),
        );
      }
    }

    /// 대각선 오른쪽
    if (x < 7 && y > 0) {
      final status = statusBoard.getStatus(x + 1, y - 1);

      if (status is BlackPieceBaseEntity) {
        /// 프로모션 가치 더해주기
        final promotionValue = status.y == 0 ? promotionVal : 0;

        pieceActionable.add(
          PieceActionableEntity(
            targetX: status.x,
            targetY: status.y,
            targetValue: status.value + promotionValue,
          ),
        );
      }
    }

    /// 앙파상

    /// 왼쪽
    if (x > 0 && y > 0) {
      final leftSide = statusBoard.getStatus(x - 1, y);
      final leftBehind = statusBoard.getStatus(x - 1, y - 1);

      /// 왼쪽 흑의 폰이 방금 double move를 했고 그 뒤에 아무것도 없어야 함
      if (leftSide is BlackPawnEntity &&
          leftSide.doubleMove &&
          leftBehind is PieceActionableEntity) {
        pieceActionable.add(
          PieceActionableEntity(
            targetX: leftBehind.targetX,
            targetY: leftBehind.targetY,
            targetValue: leftSide.value,
            actionType: PieceActionType.enPassant,
          ),
        );
      }
    }

    /// 오른쪽
    if (x < 7 && y > 0) {
      final rightSide = statusBoard.getStatus(x + 1, y);
      final rightBehind = statusBoard.getStatus(x + 1, y - 1);

      /// 오른쪽 흑의 폰이 방금 double move를 했고 그 뒤에 아무것도 없어야 함
      if (rightSide is BlackPawnEntity &&
          rightSide.doubleMove &&
          rightBehind is PieceActionableEntity) {
        pieceActionable.add(
          PieceActionableEntity(
            targetX: rightBehind.targetX,
            targetY: rightBehind.targetY,
            targetValue: rightSide.value,
            actionType: PieceActionType.enPassant,
          ),
        );
      }
    }
  }
}
