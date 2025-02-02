import 'package:chess_defense/provider/store_version/store_version_provider.dart';
import 'package:chess_defense/ui/common/controller/show_custom_dialog.dart';
import 'package:flutter/cupertino.dart';

Future<void> compareStoreVersionAndShowDialog(BuildContext context) async {
  final canUpdate = await compareVersionWithStoreUploadedVersion();

  if (canUpdate == null || canUpdate == false) {
    return;
  } else {
    if (context.mounted) {
      showCustomDialog(context, const Center(child: Text("새로운 버전이 출시되었습니다!")));
    }
  }
}
