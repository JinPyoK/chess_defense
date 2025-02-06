import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/navigator_type_enum.dart';
import 'package:chess_defense/domain/in_game/entity/piece_actionable_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_base_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/ui/in_game/widget/in_game_navigator_box.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_game_navigator_provider.g.dart';

@Riverpod()
final class InGameNavigator extends _$InGameNavigator {
  @override
  List<InGameNavigatorBox> build() {
    return <InGameNavigatorBox>[];
  }

  void clearNavigator() {
    state = [];
  }

  void showPieceMoveNavigator(List<PieceActionableEntity> pieceActionableList) {
    clearNavigator();
    final navigatorBoxList = <InGameNavigatorBox>[];

    for (PieceActionableEntity actionableModel in pieceActionableList) {
      navigatorBoxList
          .add(InGameNavigatorBox(pieceActionable: actionableModel));
    }

    state = List.from(navigatorBoxList);
  }

  void showSpawnNavigator(PieceType pieceType) {
    clearNavigator();
    final navigatorBoxList = <InGameNavigatorBox>[];

    for (int i = 0; i < 8; i++) {
      for (int j = 5; j < 8; j++) {
        final pieceModel = inGameBoardStatus.getStatus(i, j);
        if (pieceModel is PieceActionableEntity) {
          navigatorBoxList.add(
            InGameNavigatorBox(
              pieceActionable:
                  PieceActionableEntity(targetX: i, targetY: j, targetValue: 0),
              navigatorType: NavigatorType.spawn,
              spawnPieceType: pieceType,
            ),
          );
        }
      }
    }

    state = navigatorBoxList;
  }

  void showExecuteNavigator() {
    clearNavigator();
    final navigatorBoxList = <InGameNavigatorBox>[];

    for (int i = 0; i < 8; i++) {
      for (int j = 0; j < 8; j++) {
        final pieceModel = inGameBoardStatus.getStatus(i, j);
        if (pieceModel is PieceBaseEntity) {
          if (pieceModel.pieceType != PieceType.king) {
            navigatorBoxList.add(
              InGameNavigatorBox(
                pieceActionable: PieceActionableEntity(
                    targetX: i, targetY: j, targetValue: 0),
                navigatorType: NavigatorType.execute,
              ),
            );
          }
        }
      }

      state = navigatorBoxList;
    }
  }
}
