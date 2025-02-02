import 'package:chess_defense/data/ranking/model/rank_model.dart';
import 'package:chess_defense/domain/ranking/entity/ranking_entity.dart';
import 'package:chess_defense/provider/ranking/ranking_provider.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/widget/loading_skeleton.dart';
import 'package:chess_defense/ui/ranking/widget/ranking_refresh_button.dart';
import 'package:chess_defense/ui/ranking/widget/ranking_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankScreenState();
}

class _RankScreenState extends ConsumerState<RankingScreen>
    with AutomaticKeepAliveClientMixin {
  /// 공동 순위 스택
  int rankStack = 0;
  int sameMove = 99999;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rankingProvider.notifier).getRankList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final rankEntity = ref.watch(rankingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20 * wu),
              child: Text(
                "Ranking",
                style: TextStyle(
                  fontSize: 36 * hu,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const RankingRefreshButton(),
          ],
        ),
        if (rankEntity.rankState == RankingState.loading)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: LoadingSkeleton(),
          ),
        if (rankEntity.rankState == RankingState.error)
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Text(rankEntity.errorMessage),
            ),
          ),
        if (rankEntity.rankState == RankingState.fetch)
          Expanded(
            child: ListView(
              children: rankEntity.rankList.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                /// 공동 순위 나타내기
                if (index > 0) {
                  if (item.moves == sameMove) {
                    rankStack++;
                  } else {
                    rankStack = 0;
                    sameMove = item.moves;
                  }
                } else {
                  /// index == 0
                  rankStack = 0;
                  sameMove = item.moves;
                }

                return RankingTile(
                  rank: index + 1 - rankStack,
                  model: RankModel(
                    id: item.id,
                    moves: item.moves,
                    nickName: item.nickName,
                  ),
                );
              }).toList(),
            ),
          )
      ],
    );
  }
}
