import 'package:chess_defense/data/rank/model/rank_model.dart';
import 'package:chess_defense/data/rank/repository_impl/rank_repository.dart';
import 'package:chess_defense/domain/rank/entity/rank_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'rank_provider.g.dart';

@Riverpod(keepAlive: true)
final class Rank extends _$Rank {
  @override
  RankEntity build() {
    return RankEntity();
  }

  Future<void> getRankList() async {
    try {
      final repo = RankRepository();

      state =
          RankEntity(rankState: RankState.loading, rankList: state.rankList);

      final newRankList = await repo.readRank();

      /// 랭크 데이터가 없을 경우
      if (newRankList.isEmpty) {
        state = RankEntity(
            rankState: RankState.error, errorMessage: '랭크 데이터가 존재하지 않습니다');
        return;
      }

      state = RankEntity(rankState: RankState.fetch, rankList: newRankList);
    } catch (_) {
      state = RankEntity(
          rankState: RankState.error,
          errorMessage: '랭크 데이터를 불러오는 도중 에러가 발생했습니다');
    }
  }

  Future<void> registerRank({required RankModel rankModel}) async {
    final repo = RankRepository();

    await repo.writeRank(rankModel: rankModel);
  }
}
