import 'package:chess_defense/data/ranking/model/rank_model.dart';
import 'package:chess_defense/data/ranking/repository_impl/ranking_repository.dart';
import 'package:chess_defense/domain/ranking/entity/ranking_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'ranking_provider.g.dart';

@Riverpod(keepAlive: true)
final class Ranking extends _$Ranking {
  @override
  RankingEntity build() {
    return RankingEntity();
  }

  Future<void> getRankList() async {
    try {
      final repo = RankingRepository();

      state = RankingEntity(
          rankState: RankingState.loading, rankList: state.rankList);

      final newRankList = await repo.readRank();

      /// 랭크 데이터가 없을 경우
      if (newRankList.isEmpty) {
        state = RankingEntity(
            rankState: RankingState.error,
            errorMessage: "No ranking data available");
        return;
      }

      state =
          RankingEntity(rankState: RankingState.fetch, rankList: newRankList);
    } catch (_) {
      state = RankingEntity(
          rankState: RankingState.error,
          errorMessage: "An error occurred while loading ranking data");
    }
  }

  Future<void> registerRank({required RankModel rankModel}) async {
    final repo = RankingRepository();

    await repo.writeRank(rankModel: rankModel);
  }
}
