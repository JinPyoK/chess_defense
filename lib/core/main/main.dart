import 'dart:async';

import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/core/firebase/firebase_options.dart';
import 'package:chess_defense/data/privacy_policy/repository/privacy_policy_repository.dart';
import 'package:chess_defense/ui/agreement/screen/privacy_policy_screen.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/screen/main_navigation_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _initGame();

  runApp(const ChessDefense());
}

class ChessDefense extends StatelessWidget {
  const ChessDefense({super.key});

  @override
  Widget build(BuildContext context) {
    wu = MediaQuery.of(context).size.width / 320;
    hu = MediaQuery.of(context).size.height / 690;

    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _customTheme,
        title: 'Chess Defense',
        home: FutureBuilder(
          future: PrivacyPolicyRepository().getPrivacyPolicy(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data!
                  ? const MainNavigationScreen()
                  : const PrivacyPolicyScreen();
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(color: blackColor),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

Future<void> _initGame() async {
  /// 기기 세로 모드 고정
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// 파이어베이스
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// 구글 애드몹
  await MobileAds.instance.initialize();
}

final _customTheme = ThemeData(
  textTheme: GoogleFonts.nanumGothicTextTheme(),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: blackColor,
    actionTextColor: whiteColor,
  ),
  scaffoldBackgroundColor: whiteColor,
  navigationBarTheme: const NavigationBarThemeData(
    backgroundColor: whiteColor,
    indicatorColor: woodColor,
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 3),
        borderRadius: BorderRadius.circular(5),
      ),
      foregroundColor: blackColor,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      foregroundColor: whiteColor,
      backgroundColor: woodColor,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      disabledBackgroundColor: Colors.grey,
    ),
  ),
);
