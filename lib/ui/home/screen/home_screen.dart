import 'package:chess_defense/core/constant/color.dart';
import 'package:chess_defense/data/in_game/repository/in_game_saved_data_repository.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/controller/show_custom_dialog.dart';
import 'package:chess_defense/ui/home/widget/home_game_start_child.dart';
import 'package:chess_defense/ui/home/widget/home_help_child.dart';
import 'package:chess_defense/ui/home/widget/home_setting_child.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text(
          "Chess Defense",
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: blackColor,
            fontSize: 36 * hu,
          ),
        ),
        Column(
          children: [
            _renderButton(context, 'Game Start', const HomeGameStartChild(),
                defaultAction: false),
            SizedBox(height: 20 * hu),
            _renderButton(context, 'Help', const HomeHelpChild()),
            SizedBox(height: 20 * hu),
            _renderButton(context, 'Settings', const HomeSettingChild()),
          ],
        ),
        Container(), // spaceAround 밸런스 맞추기 위한 더미 컨테이너
      ],
    );
  }
}

OutlinedButton _renderButton(BuildContext context, String text, Widget child,
        {bool defaultAction = true}) =>
    OutlinedButton(
      onPressed: () async {
        /// 앱 시작시 저장된 게임 있는지 확인
        final inGameSave = await InGameSavedDataRepository().getSavedData();

        if (context.mounted) {
          /// 게임 시작 버튼일 때
          if (defaultAction == false) {
            if (context.mounted && inGameSave.isNotEmpty) {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => const InGameScreen(gameHadSaved: true)));
            } else {
              if (context.mounted) {
                showCustomDialog(
                  context,
                  child,
                  defaultAction: defaultAction,
                );
              }
            }
          } else {
            showCustomDialog(
              context,
              child,
              defaultAction: defaultAction,
            );
          }
        }
      },
      style: OutlinedButton.styleFrom(fixedSize: Size(100 * wu, 40 * hu)),
      child: Text(text),
    );
