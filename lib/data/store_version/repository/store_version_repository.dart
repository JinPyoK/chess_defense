import 'dart:convert';

import 'package:chess_defense/core/constant/store_url.dart';
import 'package:dio/dio.dart';

final class StoreVersionRepository {
  final _dio = Dio();

  Future<String?> androidStoreVersion() async {
    try {
      final response = await _dio.get(androidPlayStoreUrl);

      if (response.statusCode == 200) {
        final RegExp regexp = RegExp(
          r'\[\[\["(\d+\.\d+(\.[a-z]+)?(\.([^"]|\\")*)?)"\]\]',
        );
        final String? version = regexp.firstMatch(response.data)?.group(1);
        return version;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  Future<String?> iosStoreVersion() async {
    try {
      final response = await _dio.get(iosAppStoreUrl);

      if (response.statusCode == 200) {
        final jsonObj = json.decode(response.data);
        String? version = jsonObj['results'][0]['version'];
        return version;
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
