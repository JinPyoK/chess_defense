import 'package:chess_defense/domain/in_game/entity/piece_actionable_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';

void findRedActions(
    PieceOrJustActionable status, List<PieceActionableEntity> pieceActionable) {
  if (status is PieceActionableEntity) {
    pieceActionable.add(
      PieceActionableEntity(
        targetX: status.targetX,
        targetY: status.targetY,
        targetValue: 0,
      ),
    );
  } else if (status is PieceBaseEntity) {
    if (status.team == Team.white) {
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
