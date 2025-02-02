import 'package:chess_defense/data/rank/model/rank_model.dart';

enum RankState {
  fetch,
  loading,
  error,
}

final class RankEntity {
  RankState rankState;
  final List<RankModel> rankList;
  String errorMessage;

  RankEntity({
    this.rankState = RankState.loading,
    this.rankList = const <RankModel>[],
    this.errorMessage = '',
  });
}
