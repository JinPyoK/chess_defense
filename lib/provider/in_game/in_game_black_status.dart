import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/provider/in_game/in_game_system_notification_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_game_black_status.g.dart';

/// 흑 상태 정보
/// 미니맥스 트리 깊이, 부활 수, 기물 부활 확률
final class _InGameRedStatusProvider {
  int minimaxTreeDepth = 3;

  int spawnMove = 8;

  int chaSpawnStartRange = 0;
  int chaSpawnEndRange = 5;

  int poSpawnStartRange = 5;
  int poSpawnEndRange = 15;

  int maSpawnStartRange = 15;
  int maSpawnEndRange = 30;

  int sangSpawnStartRange = 30;
  int sangSpawnEndRange = 60;

  /// 흑 알고리즘 강화
  void upgradeBlack(int level) {
    switch (level) {
      case 0:
        minimaxTreeDepth = 3;

        spawnMove = 8;

        chaSpawnStartRange = 0;
        chaSpawnEndRange = 5;

        poSpawnStartRange = 5;
        poSpawnEndRange = 15;

        maSpawnStartRange = 15;
        maSpawnEndRange = 30;

        sangSpawnStartRange = 30;
        sangSpawnEndRange = 60;
        break;

      case 1:
        minimaxTreeDepth = 3;

        spawnMove = 4;

        chaSpawnStartRange = 0;
        chaSpawnEndRange = 5;

        poSpawnStartRange = 5;
        poSpawnEndRange = 15;

        maSpawnStartRange = 15;
        maSpawnEndRange = 30;

        sangSpawnStartRange = 30;
        sangSpawnEndRange = 70;
        break;

      case 2:
        minimaxTreeDepth = 4;

        spawnMove = 8;

        chaSpawnStartRange = 0;
        chaSpawnEndRange = 5;

        poSpawnStartRange = 5;
        poSpawnEndRange = 15;

        maSpawnStartRange = 15;
        maSpawnEndRange = 40;

        sangSpawnStartRange = 40;
        sangSpawnEndRange = 60;
        break;

      case 3:
        minimaxTreeDepth = 4;

        spawnMove = 4;

        chaSpawnStartRange = 0;
        chaSpawnEndRange = 10;

        poSpawnStartRange = 10;
        poSpawnEndRange = 30;

        maSpawnStartRange = 30;
        maSpawnEndRange = 60;

        sangSpawnStartRange = 60;
        sangSpawnEndRange = 80;
        break;

      case 4:
        minimaxTreeDepth = 5;

        spawnMove = 8;

        chaSpawnStartRange = 0;
        chaSpawnEndRange = 15;

        poSpawnStartRange = 15;
        poSpawnEndRange = 45;

        maSpawnStartRange = 45;
        maSpawnEndRange = 70;

        sangSpawnStartRange = 70;
        sangSpawnEndRange = 90;
        break;

      default:
        minimaxTreeDepth = 5;

        spawnMove = 4;

        chaSpawnStartRange = 0;
        chaSpawnEndRange = 25;

        poSpawnStartRange = 25;
        poSpawnEndRange = 45;

        maSpawnStartRange = 45;
        maSpawnEndRange = 75;

        sangSpawnStartRange = 75;
        sangSpawnEndRange = 90;
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
    final numOfRedPieces = inGameBoardStatus.getNumOfBlack();

    if (numOfRedPieces >= 30) {
      state = true;
      if (!_notifyOnce) {
        ref.read(inGameSystemNotificationProvider.notifier).notifyOnTheRopes();
        _notifyOnce = true;
      }
    } else {
      state = false;
      _notifyOnce = false;
    }

    state = numOfRedPieces >= 30;
  }
}
