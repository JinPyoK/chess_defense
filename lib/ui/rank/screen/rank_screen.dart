import 'package:chess_defense/data/rank/model/rank_model.dart';
import 'package:chess_defense/domain/rank/entity/rank_entity.dart';
import 'package:chess_defense/provider/rank/rank_provider.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/widget/loading_skeleton.dart';
import 'package:chess_defense/ui/rank/widget/rank_refresh_button.dart';
import 'package:chess_defense/ui/rank/widget/rank_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RankScreen extends ConsumerStatefulWidget {
  const RankScreen({super.key});

  @override
  ConsumerState<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends ConsumerState<RankScreen>
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
      ref.read(rankProvider.notifier).getRankList();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final rankEntity = ref.watch(rankProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20 * wu),
              child: Text(
                "랭크",
                style: TextStyle(
                  fontSize: 36 * hu,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const RankRefreshButton(),
          ],
        ),
        if (rankEntity.rankState == RankState.loading)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: LoadingSkeleton(),
          ),
        if (rankEntity.rankState == RankState.error)
          Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Center(
              child: Text(rankEntity.errorMessage),
            ),
          ),
        if (rankEntity.rankState == RankState.fetch)
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

                return RankTile(
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
