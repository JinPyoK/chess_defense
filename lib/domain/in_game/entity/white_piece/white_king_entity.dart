import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
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

// @override
// void searchActionable(InGameBoardStatus statusBoard) {
//   /// 현재 액션 가능한 리스트를 비워준다.
//   pieceActionable.clear();
//
//   /// 기물이 갈 수 있는 길을 찾아서 리스트에 넣는다.
//
//   // /// 왕 액션 탐색
//   // void findKingActions(List<PieceOrJustActionable> statusList) {
//   //   for (PieceOrJustActionable status in statusList) {
//   //     findBlueActions(status, pieceActionable);
//   //   }
//   // }
//   //
//   // if (x == 3 && y == 9) {
//   //   final statusList = <PieceOrJustActionable>[
//   //     statusBoard.getStatus(3, 8),
//   //     statusBoard.getStatus(4, 9),
//   //     statusBoard.getStatus(4, 8),
//   //   ];
//   //
//   //   findKingActions(statusList);
//   // } else if (x == 4 && y == 9) {
//   //   final statusList = <PieceOrJustActionable>[
//   //     statusBoard.getStatus(3, 9),
//   //     statusBoard.getStatus(4, 8),
//   //     statusBoard.getStatus(5, 9),
//   //   ];
//   //
//   //   findKingActions(statusList);
//   // } else if (x == 5 && y == 9) {
//   //   final statusList = <PieceOrJustActionable>[
//   //     statusBoard.getStatus(4, 9),
//   //     statusBoard.getStatus(4, 8),
//   //     statusBoard.getStatus(5, 8),
//   //   ];
//   //
//   //   findKingActions(statusList);
//   // } else if (x == 3 && y == 8) {
//   //   final statusList = <PieceOrJustActionable>[
//   //     statusBoard.getStatus(3, 7),
//   //     statusBoard.getStatus(4, 8),
//   //     statusBoard.getStatus(3, 9),
//   //   ];
//   //
//   //   findKingActions(statusList);
//   // } else if (x == 4 && y == 8) {
//   //   final statusList = <PieceOrJustActionable>[
//   //     statusBoard.getStatus(3, 7),
//   //     statusBoard.getStatus(4, 7),
//   //     statusBoard.getStatus(5, 7),
//   //     statusBoard.getStatus(3, 8),
//   //     statusBoard.getStatus(5, 8),
//   //     statusBoard.getStatus(3, 9),
//   //     statusBoard.getStatus(4, 9),
//   //     statusBoard.getStatus(5, 9),
//   //   ];
//   //
//   //   findKingActions(statusList);
//   // } else if (x == 5 && y == 8) {
//   //   final statusList = <PieceOrJustActionable>[
//   //     statusBoard.getStatus(5, 7),
//   //     statusBoard.getStatus(4, 8),
//   //     statusBoard.getStatus(5, 9),
//   //   ];
//   //
//   //   findKingActions(statusList);
//   // } else if (x == 3 && y == 7) {
//   //   final statusList = <PieceOrJustActionable>[
//   //     statusBoard.getStatus(4, 7),
//   //     statusBoard.getStatus(4, 8),
//   //     statusBoard.getStatus(3, 8),
//   //   ];
//   //
//   //   findKingActions(statusList);
//   // } else if (x == 4 && y == 7) {
//   //   final statusList = <PieceOrJustActionable>[
//   //     statusBoard.getStatus(3, 7),
//   //     statusBoard.getStatus(4, 8),
//   //     statusBoard.getStatus(5, 7),
//   //   ];
//   //
//   //   findKingActions(statusList);
//   // } else if (x == 5 && y == 7) {
//   //   final statusList = <PieceOrJustActionable>[
//   //     statusBoard.getStatus(4, 7),
//   //     statusBoard.getStatus(4, 8),
//   //     statusBoard.getStatus(5, 8),
//   //   ];
//   //
//   //   findKingActions(statusList);
//   // }
// }
}
