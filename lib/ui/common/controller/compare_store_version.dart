import 'dart:io' show Platform;

import 'package:chess_defense/core/constant/store_url.dart';
import 'package:chess_defense/provider/store_version/store_version_provider.dart';
import 'package:chess_defense/ui/common/controller/screen_size.dart';
import 'package:chess_defense/ui/common/controller/show_custom_dialog.dart';
import 'package:chess_defense/ui/common/controller/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

Future<void> compareStoreVersionAndShowDialog(BuildContext context) async {
  final canUpdate = await compareVersionWithStoreUploadedVersion();

  if (canUpdate == null || canUpdate == false) {
    return;
  } else {
    if (context.mounted) {
      showCustomDialog(
        context,
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("A new version has been released!"),
            SizedBox(height: 10 * hu),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const FittedBox(child: Text("Cancel")),
                  ),
                ),
                SizedBox(width: 10 * wu),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await launchUrlString(
                          Platform.isAndroid
                              ? androidPlayStoreUrl
                              : iosAppStoreUrl,
                        );
                      } catch (_, _) {
                        if (context.mounted) {
                          showCustomSnackBar(
                            context,
                            "Unable to access the website.",
                          );
                        }
                      }
                    },
                    child: const FittedBox(child: Text("Update")),
                  ),
                ),
              ],
            ),
          ],
        ),
        defaultAction: false,
      );
    }
  }
}
