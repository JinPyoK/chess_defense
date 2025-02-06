import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/provider/in_game/in_game_system_notification_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_game_black_status.g.dart';

/// 흑 상태 정보
/// 미니맥스 트리 깊이, 부활 수, 기물 부활 확률
final class _InGameRedStatusProvider {
  int minimaxTreeDepth = 3;

  int spawnMove = 8;

  int queenSpawnStartRange = 0;
  int queenSpawnEndRange = 5;

  int rookSpawnStartRange = 5;
  int rookSpawnEndRange = 15;

  int knightSpawnStartRange = 15;
  int knightSpawnEndRange = 30;

  int bishopSpawnStartRange = 30;
  int bishopSpawnEndRange = 60;

  /// 흑 알고리즘 강화
  void upgradeBlack(int level) {
    switch (level) {
      case 0:
        minimaxTreeDepth = 3;

        spawnMove = 8;

        queenSpawnStartRange = 0;
        queenSpawnEndRange = 5;

        rookSpawnStartRange = 5;
        rookSpawnEndRange = 15;

        knightSpawnStartRange = 15;
        knightSpawnEndRange = 30;

        bishopSpawnStartRange = 30;
        bishopSpawnEndRange = 60;
        break;

      case 1:
        minimaxTreeDepth = 3;

        spawnMove = 4;

        queenSpawnStartRange = 0;
        queenSpawnEndRange = 5;

        rookSpawnStartRange = 5;
        rookSpawnEndRange = 15;

        knightSpawnStartRange = 15;
        knightSpawnEndRange = 30;

        bishopSpawnStartRange = 30;
        bishopSpawnEndRange = 70;
        break;

      case 2:
        minimaxTreeDepth = 4;

        spawnMove = 8;

        queenSpawnStartRange = 0;
        queenSpawnEndRange = 5;

        rookSpawnStartRange = 5;
        rookSpawnEndRange = 15;

        knightSpawnStartRange = 15;
        knightSpawnEndRange = 40;

        bishopSpawnStartRange = 40;
        bishopSpawnEndRange = 60;
        break;

      case 3:
        minimaxTreeDepth = 4;

        spawnMove = 4;

        queenSpawnStartRange = 0;
        queenSpawnEndRange = 10;

        rookSpawnStartRange = 10;
        rookSpawnEndRange = 30;

        knightSpawnStartRange = 30;
        knightSpawnEndRange = 60;

        bishopSpawnStartRange = 60;
        bishopSpawnEndRange = 80;
        break;

      case 4:
        minimaxTreeDepth = 5;

        spawnMove = 8;

        queenSpawnStartRange = 0;
        queenSpawnEndRange = 15;

        rookSpawnStartRange = 15;
        rookSpawnEndRange = 45;

        knightSpawnStartRange = 45;
        knightSpawnEndRange = 70;

        bishopSpawnStartRange = 70;
        bishopSpawnEndRange = 90;
        break;

      default:
        minimaxTreeDepth = 5;

        spawnMove = 4;

        queenSpawnStartRange = 0;
        queenSpawnEndRange = 25;

        rookSpawnStartRange = 25;
        rookSpawnEndRange = 45;

        knightSpawnStartRange = 45;
        knightSpawnEndRange = 75;

        bishopSpawnStartRange = 75;
        bishopSpawnEndRange = 90;
        break;
    }
  }
}

final inGameBlackStatusProvider = _InGameRedStatusProvider();

/// 기물 수가 30을 넘을 때 노티피케이션 한번만 호출하기
bool _notifyOnce = false;

@Riverpod()
final class InGameOnTheRopes extends _$InGameOnTheRopes {
  @override
  bool build() {
    return false;
  }

  void initOnTheRopes() {
    _notifyOnce = false;
  }

  void checkOnTheRopes() {
    final numOfBlackPieces = inGameBoardStatus.getNumOfBlack();

    if (numOfBlackPieces >= 30) {
      state = true;
      if (!_notifyOnce) {
        ref.read(inGameSystemNotificationProvider.notifier).notifyOnTheRopes();
        _notifyOnce = true;
      }
    } else {
      state = false;
      _notifyOnce = false;
    }

    state = numOfBlackPieces >= 30;
  }
}
