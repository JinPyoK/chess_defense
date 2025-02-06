double boardSize = 1;

double pieceIconSize = 1;

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

void initBoardPositionValue() {
  final positionXValue = boardSize / 360;
  final positionYValue = boardSize / 720;

  boardPositionXValue[0] = positionXValue * 1.2;
  boardPositionXValue[1] = positionXValue * 39.7;
  boardPositionXValue[2] = positionXValue * 79.7;
  boardPositionXValue[3] = positionXValue * 119.7;
  boardPositionXValue[4] = positionXValue * 159.7;
  boardPositionXValue[5] = positionXValue * 199.7;
  boardPositionXValue[6] = positionXValue * 239.7;
  boardPositionXValue[7] = positionXValue * 279.7;

  boardPositionYValue[0] = positionYValue * 643;
  boardPositionYValue[1] = positionYValue * 572;
  boardPositionYValue[2] = positionYValue * 572.7;
  boardPositionYValue[3] = positionYValue * 501.7;
  boardPositionYValue[4] = positionYValue * 430.7;
  boardPositionYValue[5] = positionYValue * 288.7;
  boardPositionYValue[6] = positionYValue * 100.7;
  boardPositionYValue[7] = positionYValue * 12.7;
}
