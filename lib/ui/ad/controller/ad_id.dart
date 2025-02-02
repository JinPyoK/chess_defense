import 'dart:io';

import 'package:chess_defense/core/constant/native_key.dart';
import 'package:flutter/foundation.dart';

/// 플랫폼별 배너 아이디
final bannerTestId = Platform.isAndroid ? aosBannerTestId : iosBannerTestId;
final bannerId = Platform.isAndroid ? aosBannerId : iosBannerId;

/// 플랫폼별 리워드 아이디
final rewardTestId = Platform.isAndroid ? aosRewardTestId : iosRewardTestId;
final rewardId = Platform.isAndroid ? aosRewardId : iosRewardId;

/// 릴리스 모드이면 실제 ID 표시
final bannerUnitId = kReleaseMode ? bannerId : bannerTestId;
final rewardUnitId = kReleaseMode ? rewardId : rewardTestId;
