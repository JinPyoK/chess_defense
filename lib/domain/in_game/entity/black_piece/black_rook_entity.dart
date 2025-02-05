import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/ui/in_game/controller/in_game_control_value.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final class BlackRookEntity extends WhitePieceBaseEntity {
  BlackRookEntity({
    required super.x,
    required super.y,
  }) : super(
          team: Team.black,
          pieceType: PieceType.rook,
          value: 5,
          pieceIcon: FaIcon(
            FontAwesomeIcons.solidChessRook,
            color: blackColor,
            size: pieceIconSize,
          ),
        );

  @override
  void searchActionable(InGameBoardStatus statusBoard) {
    /// 현재 액션 가능한 리스트를 비워준다.
    pieceActionable.clear();

    /// 기물이 갈 수 있는 길을 찾아서 리스트에 넣는다.
  }
}
