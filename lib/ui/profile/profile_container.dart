import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rootanya/data/model/user.dart';
import 'package:rootanya/redux/app/app_state.dart';
import 'package:rootanya/redux/auth/auth_action.dart';
import 'package:rootanya/redux/profile/profile_screen_state.dart';
import 'package:rootanya/ui/profile/profile_screen.dart';
import 'package:rootanya/util/widget_utils.dart';
import 'package:redux/redux.dart';

class ProfileContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      ignoreChange: (AppState state) => false,
      onDidChange: (ProfileScreenViewModel viewModel) {},
      converter: ProfileScreenViewModel.fromStore,
      builder: (BuildContext context, ProfileScreenViewModel viewModel) {
        return ProfileScreen(
          viewModel: viewModel,
        );
      },
    );
  }
}

class ProfileScreenViewModel {
  final User user;
  final bool isAuthenticated;
  final String token;
  final ProfileScreenState state;
  final Function(User, BuildContext) onUpdate;
  final Function(BuildContext context) onLogout;

  ProfileScreenViewModel({
    this.user,
    this.isAuthenticated,
    this.token,
    this.state,
    this.onUpdate,
    this.onLogout,
  });

  static ProfileScreenViewModel fromStore(Store<AppState> store) {
    return ProfileScreenViewModel(
        user: store.state.user,
        isAuthenticated: store.state.token != null,
        token: store.state.token,
        state: store.state.profileScreenState,
        onUpdate: (User user, BuildContext context) {
          Completer<Null> completer = Completer();
          completer.future.then((_) {
            showToast('บันทึกแล้ว');
          });

          store.dispatch(UpdateUserAction(user, completer));
        },
        onLogout: (BuildContext context) {
          Completer<Null> completer = Completer();
          completer.future.then((_) {
            showToast('ออกจากระบบแล้ว');
            Navigator.of(context).pop();
          });
          store.dispatch(LogoutAction(completer));
        });
  }

  @override
  String toString() {
    return 'ProfileScreenViewModel{user: $user, token: $token, state: $state, onUpdate: $onUpdate, onLogout: $onLogout}';
  }
}
