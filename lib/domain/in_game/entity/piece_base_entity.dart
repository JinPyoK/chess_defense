import 'package:chess_defense/domain/in_game/entity/black_piece/black_bishop_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_knight_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_pawn_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_queen_entity.dart';
import 'package:chess_defense/domain/in_game/entity/black_piece/black_rook_entity.dart';
import 'package:chess_defense/domain/in_game/entity/in_game_board_status.dart';
import 'package:chess_defense/domain/in_game/entity/piece_actionable_entity.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_bishop_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_king_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_knight_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_pawn_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_queen_entity.dart';
import 'package:chess_defense/domain/in_game/entity/white_piece/white_rook_entity.dart';
import 'package:flutter/cupertino.dart';

abstract base class PieceOrJustActionable {}

abstract base class PieceBaseEntity extends PieceOrJustActionable {
  /// 기물의 팀 소속
  final Team team;

  /// 기물 타입
  final PieceType pieceType;

  /// 기물 가치 -> 봇 기물: 흑의 미니맥스 알고리즘 가치 / 유저 기물: 흑 기물을 취했을 때 얻는 골드
  final int value;

  /// 기물 아이콘
  final SizedBox pieceIcon;

  /// 기물을 방금 착수했는지 -> UI 표시
  bool justTurn = false;

  /// 기물을 방금 탭했는지 -> UI 표시
  bool justTapped = false;

  /// 기물이 방금 처음 움직였는지 -> 체스에는 first move로 인한 규칙이 있음 -> pawn 2칸 전진, 캐슬링
  bool firstMove = false;

  /// 기물의 현재 좌표
  int x;
  int y;

  /// 이 기물이 취할 수 있는 액션
  List<PieceActionableEntity> pieceActionable = [];

  PieceBaseEntity({
    required this.team,
    required this.pieceType,
    required this.value,
    required this.pieceIcon,
    required this.x,
    required this.y,
  });

  PieceBaseEntity getNewPieceInstance() {
    late PieceBaseEntity pieceEntity;

    /// 백
    if (team == Team.white) {
      switch (pieceType) {
        case PieceType.king:
          pieceEntity = WhiteKingEntity(x: x, y: y);
        case PieceType.queen:
          pieceEntity = WhiteQueenEntity(x: x, y: y);
        case PieceType.rook:
          pieceEntity = WhiteRookEntity(x: x, y: y);
        case PieceType.knight:
          pieceEntity = WhiteKnightEntity(x: x, y: y);
        case PieceType.bishop:
          pieceEntity = WhiteBishopEntity(x: x, y: y);
        case PieceType.pawn:
          pieceEntity = WhitePawnEntity(x: x, y: y);
      }
    }

    /// 흑
    else {
      switch (pieceType) {
        case PieceType.queen:
          pieceEntity = BlackQueenEntity(x: x, y: y);
        case PieceType.rook:
          pieceEntity = BlackRookEntity(x: x, y: y);
        case PieceType.knight:
          pieceEntity = BlackKnightEntity(x: x, y: y);
        case PieceType.bishop:
          pieceEntity = BlackBishopEntity(x: x, y: y);
        case PieceType.pawn:
          pieceEntity = BlackPawnEntity(x: x, y: y);
        default:
          pieceEntity = BlackPawnEntity(x: x, y: y);
      }
    }

    return pieceEntity;
  }

  /// 기물의 움직임 애니메이션 setState
  void Function(void Function())? setStateThisPiece;

  /// 기물 길 찾기 함수
  void searchActionable(InGameBoardStatus statusBoard) {}
}

abstract base class WhitePieceBaseEntity extends PieceBaseEntity {
  WhitePieceBaseEntity({
    required super.x,
    required super.y,
    required super.team,
    required super.pieceType,
    required super.pieceIcon,
    required super.value,
  }) : super();
}

abstract base class BlackPieceBaseEntity extends PieceBaseEntity {
  /// 현재 이 기물이 채크? (흑 기물만 해당)
  bool isTargetingKing = false;

  /// 장군인지 파악
  void doesThisPieceCallCheck() {
    isTargetingKing = false;

    for (PieceActionableEntity actionable in pieceActionable) {
      if (actionable.targetValue == 1000) {
        isTargetingKing = true;
        break;
      }
    }
  }

  BlackPieceBaseEntity({
    required super.x,
    required super.y,
    required super.team,
    required super.pieceType,
    required super.pieceIcon,
    required super.value,
  }) : super();
}
