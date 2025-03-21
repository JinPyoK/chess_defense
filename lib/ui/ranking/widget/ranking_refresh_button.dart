import 'dart:async';

import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/provider/ranking/ranking_provider.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RankingRefreshButton extends ConsumerStatefulWidget {
  const RankingRefreshButton({super.key});

  @override
  ConsumerState<RankingRefreshButton> createState() =>
      _RankRefreshButtonState();
}

class _RankRefreshButtonState extends ConsumerState<RankingRefreshButton> {
  bool _coolTime = false;

  Future<void> _refreshCoolTime() async {
    _coolTime = true;
    setState(() {});
    await Future.delayed(const Duration(seconds: 10), () {});
    _coolTime = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20 * wu),
      child: Material(
        color: woodColor,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: _coolTime
              ? null
              : () async {
                  if (!_coolTime) {
                    await ref.read(rankingProvider.notifier).getRankList();
                    await _refreshCoolTime();
                  }
                },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: EdgeInsets.all(3 * hu),
            child: SizedBox(
              width: 30 * hu,
              height: 30 * hu,
              child: FittedBox(
                child: _coolTime
                    ? const _RankRefreshTimer()
                    : const Icon(
                        Icons.refresh,
                        color: whiteColor,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RankRefreshTimer extends StatefulWidget {
  const _RankRefreshTimer();

  @override
  State<_RankRefreshTimer> createState() => _RankRefreshTimerState();
}

class _RankRefreshTimerState extends State<_RankRefreshTimer> {
  int _seconds = 10;

  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _seconds -= 1;
      if (_seconds < 0) {
        timer.cancel();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        _seconds.toString(),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: whiteColor,
        ),
      ),
    );
  }
}
