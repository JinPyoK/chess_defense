import 'package:chess_defense/ui/common/screen/main_navigation_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_game_gold_provider.g.dart';

@Riverpod(keepAlive: true)
final class InGameGold extends _$InGameGold {
  @override
  int build() {
    return myGolds >= 3000 ? 3000 : myGolds;
  }

  void setInGameGold(int gold) {
    state = gold;
  }
}
