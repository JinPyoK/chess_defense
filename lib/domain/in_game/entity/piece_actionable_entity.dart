import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';

final class PieceActionableEntity extends PieceOrJustActionable {
  final int targetX;
  final int targetY;
  final int targetValue;
  final PieceActionType actionType;

  PieceActionableEntity({
    required this.targetX,
    required this.targetY,
    required this.targetValue,
    this.actionType = PieceActionType.move,
  });
}
