import 'package:chess_defense/ui/common/controller/show_custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LaunchUrlTextButton extends StatelessWidget {
  const LaunchUrlTextButton({super.key, required this.url, required this.text});

  final String url;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        try {
          await launchUrlString(url);
        } catch (_) {
          if (context.mounted) {
            showCustomSnackBar(context, "Unable to access the site.");
          }
        }
      },
      child: Text(text),
    );
  }
}
