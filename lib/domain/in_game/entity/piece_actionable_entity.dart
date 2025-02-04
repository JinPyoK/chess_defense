import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';

final class PieceActionableEntity extends PieceOrJustActionable {
  final int targetX;
  final int targetY;
  final int targetValue;

  PieceActionableEntity({
    required this.targetX,
    required this.targetY,
    required this.targetValue,
  });
}
