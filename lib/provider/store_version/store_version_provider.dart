import 'dart:io';

import 'package:chess_defense/data/store_version/repository/store_version_repository.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<bool?> compareVersionWithStoreUploadedVersion() async {
  final repo = StoreVersionRepository();
  String? storeVersion;

  if (Platform.isAndroid) {
    storeVersion = await repo.androidStoreVersion();
  } else {
    storeVersion = await repo.iosStoreVersion();
  }

  /// 스토어애 등록된 버전을 불러오지 못했을 때
  if (storeVersion == null) {
    return null;
  }

  final packageInfo = await PackageInfo.fromPlatform();

  final appVersion = packageInfo.version;

  return storeVersion != appVersion;
}
