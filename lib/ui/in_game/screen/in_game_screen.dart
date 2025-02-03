import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InGameScreen extends ConsumerWidget {
  const InGameScreen({super.key, required this.gameHadSaved});

  final bool gameHadSaved;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: true,
      // canPop: false,
      child: GestureDetector(
        onTap: () {
          // ref.read(inGameNavigatorProvider.notifier).clearNavigator();
          //
          // /// 최근 탭한 기물 setState
          // if (selectedPieceModel != null) {
          //   selectedPieceModel!.justTapped = false;
          //   selectedPieceModel!.setStateThisPiece!(() {});
          // }
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(title: const Text("InGameScreen"),),
          body: Center(child: Text("screen"),),
          // appBar: const InGameAppBar(),
          // body: Column(
          //   crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: [
          //     Expanded(
          //       flex: 2,
          //       child: InGameBody(gameHadSaved: gameHadSaved),
          //     ),
          //     const Expanded(
          //       flex: 1,
          //       child: InGameFooter(),
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}