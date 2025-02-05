import 'package:chess_defense/core/constant/asset_path.dart';
import 'package:chess_defense/data/sound/repository/sound_repository.dart';
import 'package:chess_defense/domain/in_game/entity/piece_enum.dart';
import 'package:just_audio/just_audio.dart';

Future<void> makePieceSpawnSound(PieceType pieceType) async {
  switch (pieceType) {
    case PieceType.queen:
      await _makeSound(soundSpawnQueenPath);
    case PieceType.rook:
      await _makeSound(soundSpawnRookPath);
    case PieceType.knight:
      await _makeSound(soundSpawnKnightPath);
    case PieceType.bishop:
      await _makeSound(soundSpawnBishopPath);
    case PieceType.pawn:
      await _makeSound(soundSpawnPawnPath);
    default:
      await _makeSound(soundSpawnPawnPath);
  }
}

Future<void> makePieceKilledSound(Team team) async {
  switch (team) {
    case Team.black:
      await _makeSound(soundBlackKilledPath);
    default:
      await _makeSound(soundWhiteKilledPath);
  }
}

Future<void> makeGameStartSound() async {
  await _makeSound(soundGameStartPath);
}

Future<void> makePieceTapSound() async {
  await _makeSound(soundPieceTapPath);
}

Future<void> makePieceMoveSound() async {
  await _makeSound(soundPieceMovePath);
}

Future<void> makeSystemErrorSound() async {
  await _makeSound(soundWhiteKilledPath);
}

Future<void> makeExecuteOrCheckSound() async {
  await _makeSound(soundExecuteCheckPath);
}

double _volume = 0.5;

Future<void> _makeSound(String soundPath) async {
  final player = AudioPlayer();

  await player.setAsset(soundPath);

  await player.setVolume(_volume);

  await player.seek(const Duration());

  await player.play();

  await player.stop();

  await player.dispose();
}

Future<void> soundInit() async {
  _volume = await SoundVolumeRepository().getSoundVolume();
}
