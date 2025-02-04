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
  Widget _renderChessBoard() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 8, // 8칸씩 배치
            childAspectRatio: 1, // 정사각형 유지
          ),
          physics: const NeverScrollableScrollPhysics(), // 스크롤 방지
          itemCount: 64, // 총 64개
          itemBuilder: (context, index) {
            // 번갈아 가며 색상 지정 (체스판 스타일)
            bool isBlack = (index ~/ 8 + index) % 2 == 1;
            return ColoredBox(
              color: isBlack ? Color(0xffC78E53) : Color(0xffF7D0A4),
            );
          },
        ),
      ),
    );
  }

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
            _renderChessBoard(),
            // ...pieceSet,
            // ...navigatorBoxList,
            // ...systemNotification,
          ],
        ),
      ),
    );
  }
}
