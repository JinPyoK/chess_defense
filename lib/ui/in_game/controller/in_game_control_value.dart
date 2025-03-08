import 'package:flutter/material.dart';

double boardSize = 1;

double pieceIconSize = 1;

/// 체스판을 센터에 배치할 때 왼쪽 여백 만큼 이동
double screenOffset = 0;

Map<int, double> boardPositionXValue = {
  0: 0,
  1: 0,
  2: 0,
  3: 0,
  4: 0,
  5: 0,
  6: 0,
  7: 0,
};

Map<int, double> boardPositionYValue = {
  0: 0,
  1: 0,
  2: 0,
  3: 0,
  4: 0,
  5: 0,
  6: 0,
  7: 0,
};

void initBoardPositionValue(BuildContext context) {
  final positionXValue = boardSize / 360;
  final positionYValue = boardSize / 720;

  screenOffset = (MediaQuery.of(context).size.width - boardSize) / 2;

  boardPositionXValue[0] = positionXValue * 4.1;
  boardPositionXValue[1] = positionXValue * 50.1;
  boardPositionXValue[2] = positionXValue * 95.1;
  boardPositionXValue[3] = positionXValue * 139.9;
  boardPositionXValue[4] = positionXValue * 185;
  boardPositionXValue[5] = positionXValue * 230.1;
  boardPositionXValue[6] = positionXValue * 275;
  boardPositionXValue[7] = positionXValue * 320;

  boardPositionYValue[0] = positionYValue * 642;
  boardPositionYValue[1] = positionYValue * 550;
  boardPositionYValue[2] = positionYValue * 460;
  boardPositionYValue[3] = positionYValue * 370;
  boardPositionYValue[4] = positionYValue * 280;
  boardPositionYValue[5] = positionYValue * 190;
  boardPositionYValue[6] = positionYValue * 100;
  boardPositionYValue[7] = positionYValue * 8;
}
