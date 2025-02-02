import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/data/gold/repository/gold_repository.dart';
import 'package:chess_defense/ui/common/controller/compare_store_version.dart';
import 'package:chess_defense/ui/common/controller/show_custom_dialog.dart';
import 'package:chess_defense/ui/common/controller/util_function.dart';
import 'package:chess_defense/ui/common/widget/gold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  final _pageController = PageController();

  int _currentIndex = 0;
  int _myGolds = 0;

  Future<void> _getGolds() async {
    _myGolds = await GoldRepository().getGolds();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setStateGold = setState;

    // globalContext = context;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getGolds();
      compareStoreVersionAndShowDialog(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) {
        showCustomDialog(
            context,
            defaultAction: false,
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text("게임을 종료하시겠습니까?"),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: const Text("취소"),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: redColor,
                      ),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                      child: const Text("게임 종료"),
                    )
                  ],
                )
              ],
            ));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: whiteColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 24),
              child: GoldWidget(gold: _myGolds),
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            // HomeScreen(),
            // RankScreen(),
            // AdScreen(),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
            setState(() {});
          },
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.houseChimney),
              selectedIcon: FaIcon(
                FontAwesomeIcons.houseChimney,
                color: whiteColor,
              ),
              label: "Home",
            ),
            NavigationDestination(
              icon: FaIcon(FontAwesomeIcons.rankingStar),
              selectedIcon: FaIcon(
                FontAwesomeIcons.rankingStar,
                color: whiteColor,
              ),
              label: "Rank",
            ),
            NavigationDestination(
              icon: Icon(Icons.live_tv_outlined),
              selectedIcon: Icon(
                Icons.live_tv_outlined,
                color: whiteColor,
              ),
              label: "Ad",
            ),
          ],
        ),
      ),
    );
  }
}
