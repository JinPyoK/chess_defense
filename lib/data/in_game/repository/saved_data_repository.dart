import 'package:shared_preferences/shared_preferences.dart';

final class SavedDataRepository {
  Future<List<String>?> getSavedData() async {
    final pref = await SharedPreferences.getInstance();

    final List<String>? savedData = pref.getStringList('savedData');

    return savedData ?? <String>[];
  }

  Future<void> saveInGameData({required List<String> inGameData}) async {
    try {
      final pref = await SharedPreferences.getInstance();

      await pref.setStringList('savedData', inGameData);
    } catch (_) {
    }
  }
}