import 'package:chess_defense/data/ranking/model/rank_model.dart';

enum RankingState {
  fetch,
  loading,
  error,
}

final class RankingEntity {
  RankingState rankState;
  final List<RankModel> rankList;
  String errorMessage;

  RankingEntity({
    this.rankState = RankingState.loading,
    this.rankList = const <RankModel>[],
    this.errorMessage = '',
  });
}
