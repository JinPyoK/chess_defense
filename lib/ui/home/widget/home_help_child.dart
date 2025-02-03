import 'package:chess_defense/core/constant/asset_path.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/widget/launch_url_text_button.dart';
import 'package:flutter/material.dart';

class HomeHelpChild extends StatelessWidget {
  const HomeHelpChild({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(imageAppIconPath),
        const SizedBox(height: 30),
        _renderTitle('1. Chess Defense'),
        _renderDescription(
            'Chess Defense is a game where you must survive as long as possible against the endlessly resurrecting black pieces that attack the white pieces.'),
        _renderTitle('2. Game Start'),
        _renderDescription(
            'Players play as White and can start the game with a minimum of 0 Gold and a maximum of 3,000 Gold.'),
        _renderTitle('3. Match'),
        _renderDescription(
            'Every 20 moves, Black becomes stronger, progressing through a total of 5 stages. As Black gets stronger, its algorithm deepens, and its resurrection frequency increases.'),
        _renderDescription(
            'Black pieces can resurrect in positions where they can immediately capture the White King, so be careful.'),
        _renderDescription(
            'Do not force close the app during a match. All progress will be lost.'),
        _renderTitle('4. Gold'),
        _renderDescription('Gold is required to resurrect or execute pieces.'),
        _renderDescription(
            'You earn a small amount of Gold by capturing Black\'s pieces during the match.'),
        _renderDescription(
            'After the game ends, all remaining Gold is refunded.'),
        _renderDescription(
            'However, please note that if you delete the app, all accumulated Gold will be lost.'),
        _renderDescription(
            'You can earn 1,000 Gold as a reward by watching ads in the Ad tab below.'),
        _renderTitle('5. Piece Resurrection'),
        _renderDescription(
            'The number of White pieces that can be resurrected cannot exceed the maximum limit, and Gold is consumed accordingly.'),
        _renderDescription(
            'Pawn (Max 8) → 10 Gold\nBishop (Max 2) → 30 Gold\nKnight (Max 2) → 30 Gold\nRook (Max 2) → 50 Gold\nQueen (Max 1) → 90 Gold'),
        _renderTitle('6. Piece Execution'),
        _renderDescription(
            'You can instantly execute any Black or White piece except for the King. This action costs 300 Gold.'),
        _renderTitle('7. Game Over'),
        _renderDescription(
            'The game ends when the White King is captured by a Black piece or when the total number of Black pieces exceeds 40.'),
        _renderDescription(
            'You can temporarily save and exit the game during a match and resume it later.'),
        _renderDescription(
            'However, just like Gold, saved games will be lost if you delete the app.'),
        _renderTitle('8. Ranking'),
        _renderDescription(
            'When the game ends, you can register your final move count in the Ranking.'),
        _renderDescription(
            'The ranking records up to the Top 100 players and can be viewed in the Ranking tab below.'),
        _renderTitle('9. Privacy Policy & Terms of Use'),
        const LaunchUrlTextButton(
          url:
              'https://doc-hosting.flycricket.io/chess-defense-privacy-policy/3b274c15-7779-417c-9970-b494f18487b8/privacy',
          text: "Privacy Policy",
        ),
        const LaunchUrlTextButton(
          url:
              'https://doc-hosting.flycricket.io/chess-defense-terms-of-use/eb87f9ab-d2be-46f2-89de-c3b6874c5b6f/terms',
          text: "Terms of Use",
        ),
        _renderTitle('10. License'),
        _renderDescription(
            'The app icon and the top image in the Help section were generated using AI.'),
        _renderDescription('Sound Effects: Pixabay'),
        _renderDescription(
            'Gold, Trophy, and Piece Icons: Font Awesome Free Icons'),
      ],
    );
  }
}

Padding _renderTitle(String title) => Padding(
      padding: EdgeInsets.only(bottom: 5 * hu),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );

Padding _renderDescription(String description) => Padding(
      padding: EdgeInsets.only(bottom: 10 * hu),
      child: Text(description),
    );
