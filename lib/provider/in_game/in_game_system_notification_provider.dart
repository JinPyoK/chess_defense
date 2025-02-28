import 'package:chess_defense/ui/audio/controller/audio_play.dart';
import 'package:chess_defense/ui/in_game/widget/system_notification/black_upgrade_system_notification.dart';
import 'package:chess_defense/ui/in_game/widget/system_notification/check_system_notification.dart';
import 'package:chess_defense/ui/in_game/widget/system_notification/error_system_notification.dart';
import 'package:chess_defense/ui/in_game/widget/system_notification/white_on_the_ropes_system_notification.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'in_game_system_notification_provider.g.dart';

@Riverpod()
final class InGameSystemNotification extends _$InGameSystemNotification {
  @override
  List<Widget> build() {
    return <Widget>[];
  }

  void notifyCheck() {
    state = <Widget>[...state, CheckSystemNotification(key: GlobalKey())];
    makeExecuteOrCheckSound();
  }

  void notifyBlackUpgrade(int level) {
    state = <Widget>[
      ...state,
      BlackUpgradeSystemNotification(key: GlobalKey(), level: level),
    ];
    makeGameStartSound();
  }

  void notifySystemError(String errorMessage) {
    state = <Widget>[
      ...state,
      ErrorSystemNotification(key: GlobalKey(), errorMessage: errorMessage),
    ];
    makeSystemErrorSound();
  }

  void notifyOnTheRopes() {
    state = <Widget>[
      ...state,
      WhiteOnTheRopesSystemNotification(key: GlobalKey()),
    ];
    makeGameStartSound();
  }

  void clearNotificationList() {
    state.clear();
  }
}
