import 'package:chess_defense/core/constant/color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InGameBody extends ConsumerStatefulWidget {
  const InGameBody({super.key, required this.gameHadSaved});

  final bool gameHadSaved;

  @override
  ConsumerState<InGameBody> createState() => _InGameBodyState();
}

class _InGameBodyState extends ConsumerState<InGameBody> {
  @override
  Widget build(BuildContext context) {
    // final pieceSet = ref.watch(inGamePieceSetProvider);
    // final navigatorBoxList = ref.watch(inGameNavigatorProvider);
    // final systemNotification = ref.watch(inGameSystemNotificationProvider);

    return ColoredBox(
      color: inGameBlackColor,
      child: Center(
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            // Align(
            //   alignment: Alignment.bottomLeft,
            //   child: Image(
            //     image: imageBoard,
            //     key: imageBoardKey,
            //   ),
            // ),
            // ...pieceSet,
            // ...navigatorBoxList,
            // ...systemNotification,
          ],
        ),
      ),
    );
  }
}
