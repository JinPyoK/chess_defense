import 'package:chess_defense/data/gold/repository/gold_repository.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/controller/show_custom_snackbar.dart';
import 'package:chess_defense/ui/common/controller/util_function.dart';
import 'package:chess_defense/ui/common/screen/main_navigation_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdReward extends StatefulWidget {
  const AdReward({super.key, required this.adUnitId});

  final String adUnitId;

  @override
  State<AdReward> createState() => _AdRewardState();
}

class _AdRewardState extends State<AdReward> {
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    RewardedAd.load(
      adUnitId: widget.adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        /// Called when an ad is successfully received.
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            /// Called when the ad showed the full screen content.
            onAdShowedFullScreenContent: (ad) {},

            /// Called when an impression occurs on the ad.
            onAdImpression: (ad) {},

            /// Called when the ad failed to show full screen content.
            onAdFailedToShowFullScreenContent: (ad, err) {
              /// Dispose the ad here to free resources.
              _rewardedAd = null;

              _loadAd();

              ad.dispose();
            },

            /// Called when the ad dismissed full screen content.
            onAdDismissedFullScreenContent: (ad) {
              /// Dispose the ad here to free resources.
              _rewardedAd = null;

              _loadAd();

              ad.dispose();
            },

            /// Called when a click is recorded for an ad.
            onAdClicked: (ad) {},
          );

          // Keep a reference to the ad so you can show it later.
          _rewardedAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (_) {
          showCustomSnackBar(context, "Failed to load ad");
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10 * wu),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(minimumSize: Size(100 * wu, 40 * hu)),
        onPressed: () {
          if (_rewardedAd == null) {
            showCustomSnackBar(context, "Please try again later");
          } else {
            try {
              _rewardedAd!.show(
                onUserEarnedReward: (_, __) async {
                  myGolds += 1000;

                  if (setStateGold != null) {
                    setStateGold!(() {});
                  }

                  await GoldRepository().setGolds(golds: myGolds);
                },
              );
            } catch (_) {
              showCustomSnackBar(context, "Please try again later");
            }
          }
        },
        child: const Text("Earn 1000 Gold after watching the ad"),
      ),
    );
  }
}
