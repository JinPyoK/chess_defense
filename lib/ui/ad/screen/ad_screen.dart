import 'package:chess_defense/ui/ad/controller/ad_id.dart';
import 'package:chess_defense/ui/ad/widget/ad_banner.dart';
import 'package:chess_defense/ui/ad/widget/ad_reward.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart' show AdSize;

class AdScreen extends StatefulWidget {
  const AdScreen({super.key});

  @override
  State<AdScreen> createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 20 * wu),
          child: Text(
            "Ad",
            style: TextStyle(fontSize: 36 * hu, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10 * hu),
        AdBanner(
          adSize: AdSize(width: (300 * wu).toInt(), height: (100 * hu).toInt()),
          adUnitId: bannerUnitId,
        ),
        SizedBox(height: 20 * hu),
        Padding(
          padding: EdgeInsets.all(12 * hu),
          child: AdReward(adUnitId: rewardUnitId),
        ),
        _renderCaution(
          "You may not receive a reward if the ad is not watched correctly.",
        ),
        _renderCaution("Gold will be lost if the app is deleted."),
        _renderCaution(
          "For more details, please tap the Help button in the Home tab.",
        ),
      ],
    );
  }
}

Padding _renderCaution(String text) => Padding(
  padding: EdgeInsets.symmetric(horizontal: 10 * wu, vertical: 5 * hu),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('* ', style: TextStyle(color: Colors.black54)),
      Expanded(
        child: Text(text, style: const TextStyle(color: Colors.black54)),
      ),
    ],
  ),
);
