double boardSize = 1;

double pieceIconSize = 1;

Map<int, double> boardPositionValue = {
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
  final positionValue = boardSize / 360;

  boardPositionValue[0] = positionValue * 0.7;
  boardPositionValue[1] = positionValue * 39.7;
  boardPositionValue[2] = positionValue * 79.7;
  boardPositionValue[3] = positionValue * 119.7;
  boardPositionValue[4] = positionValue * 159.7;
  boardPositionValue[5] = positionValue * 199.7;
  boardPositionValue[6] = positionValue * 239.7;
  boardPositionValue[7] = positionValue * 279.7;
}
