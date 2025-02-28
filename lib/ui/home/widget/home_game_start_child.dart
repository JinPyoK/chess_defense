import 'package:chess_defense/data/gold/repository/gold_repository.dart';
import 'package:chess_defense/provider/in_game/in_game_gold_provider.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/controller/util_function.dart';
import 'package:chess_defense/ui/common/screen/main_navigation_screen.dart';
import 'package:chess_defense/ui/in_game/screen/in_game_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeGameStartChild extends ConsumerStatefulWidget {
  const HomeGameStartChild({super.key});

  @override
  ConsumerState<HomeGameStartChild> createState() => _HomeGameStartChildState();
}

class _HomeGameStartChildState extends ConsumerState<HomeGameStartChild> {
  int _startGold = 0;

  @override
  void initState() {
    super.initState();

    /// 게임 시작을 누르면 addPostFrameCallback이 또 한번 실행됨
    /// 이유를 아직 모르겠음
    WidgetsBinding.instance.addPostFrameCallback((_) {
      myGolds > 3000 ? _startGold = 3000 : _startGold = myGolds;

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Starting Gold (Max 3000 Gold)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20 * hu),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(5),
              ),
              padding: EdgeInsets.all(10 * hu),
              child: Text(
                _startGold.toString(),
                style: TextStyle(fontSize: 25 * hu),
              ),
            ),
            SizedBox(width: 10 * wu),
            FaIcon(FontAwesomeIcons.coins, color: Colors.amber, size: 30 * hu),
          ],
        ),
        SizedBox(height: 15 * hu),
        Center(
          child: FittedBox(
            child: Row(
              children: [
                OutlinedButton(
                  onPressed: () {
                    _startGold = 0;
                    setState(() {});
                  },
                  child: const Text("Min"),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    _startGold <= 100 ? _startGold = 0 : _startGold -= 100;
                    setState(() {});
                  },
                  child: const Text("-100"),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    if (_startGold + 100 >= myGolds) {
                      _startGold = myGolds;
                    } else {
                      _startGold >= 2900
                          ? _startGold = 3000
                          : _startGold += 100;
                    }

                    setState(() {});
                  },
                  child: const Text("+100"),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {
                    myGolds <= 3000 ? _startGold = myGolds : _startGold = 3000;

                    setState(() {});
                  },
                  child: const Text("Max"),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 30 * hu),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: const FittedBox(child: Text("Cancel")),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ElevatedButton(
                  onPressed: () async {
                    myGolds -= _startGold;

                    await GoldRepository().setGolds(golds: myGolds);

                    setStateGold!(() {});

                    ref
                        .read(inGameGoldProvider.notifier)
                        .setInGameGold(_startGold);

                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).pop();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => const InGameScreen(gameHadSaved: false),
                        ),
                      );
                    }
                  },
                  child: const FittedBox(child: Text("Game Start")),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
