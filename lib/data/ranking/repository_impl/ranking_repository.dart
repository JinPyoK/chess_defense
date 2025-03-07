import 'package:chess_defense/data/ranking/model/rank_model.dart';
import 'package:firebase_database/firebase_database.dart';

final _realtime = FirebaseDatabase.instance;

final class RankingRepository {
  factory RankingRepository() => RankingRepository._();

  RankingRepository._();

  /// 랭크 데이터 가져오기
  Future<List<RankModel>> readRank() async {
    final snapShot = await _realtime.ref().child('ranking').get();
    if (snapShot.value == null) return <RankModel>[];
    return _makeSortedRankList(snapShot.value);
  }

  Future<void> writeRank({required RankModel rankModel}) async {
    /// 동시성 문제 방지
    await _realtime.ref('ranking').runTransaction(
      (rankSnapshotValue) {
        try {
          final rankList = _makeSortedRankList(rankSnapshotValue);

          /// 마지막 순위의 데이터 제거 후 랭크 데이터 쓰기 => 데이터 100개만 유지
          if (rankList.length < 100) {
            rankList.add(rankModel);
          } else {
            if (rankList.last.moves > rankModel.moves) {
              /// 100위보다 낮으므로 랭크에 등록될 수 없다.
              return Transaction.abort();
            }

            /// 100위보다 높으면 마지막 데이터를 지우고 해당 데이터 추가
            rankList.removeLast();
            rankList.add(rankModel);
          }

          Map<String, dynamic> rankData = {};

          for (RankModel model in rankList) {
            rankData.addAll({
              model.id: {
                'moves': model.moves,
                'nickName': model.nickName,
              },
            });
          }

          return Transaction.success(rankData);
        } catch (_) {
          return Transaction.abort();
        }
      },
    );
  }
}

List<RankModel> _makeSortedRankList(Object? data) {
  List<RankModel> rankList = [];

  if (data == null) return rankList;

  /// 리얼타임 데이터베이스는 Object? 로 반환한다.
  final rankListObject =
      (data as Map<Object?, Object?>).cast<String, dynamic>();

  for (String key in rankListObject.keys) {
    rankList.add(
      RankModel.fromJson(
        {
          'id': key,
          'moves': rankListObject[key]['moves'] as int,
          'nickName': rankListObject[key]['nickName'] as String,
        },
      ),
    );
  }

  /// 순위대로 오름차순 정렬
  rankList.sort((p, n) => n.moves.compareTo(p.moves));

  return rankList;
}
