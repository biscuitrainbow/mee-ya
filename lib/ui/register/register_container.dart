import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rootanya/data/model/user.dart';
import 'package:rootanya/exception/http_exception.dart';
import 'package:rootanya/redux/app/app_state.dart';
import 'package:rootanya/redux/auth/auth_action.dart';
import 'package:rootanya/redux/register/register_screen_state.dart';
import 'package:rootanya/ui/register/register_screen.dart';
import 'package:rootanya/util/widget_utils.dart';
import 'package:redux/redux.dart';

class RegisterContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      converter: ViewModel.fromStore,
      builder: (BuildContext context, ViewModel vm) {
        return RegisterScreen(
          onRegister: vm.onRegister,
          registerScreenState: vm.registerScreenState,
        );
      },
    );
  }
}

class ViewModel {
  final Function(User, BuildContext) onRegister;
  final RegisterScreenState registerScreenState;

  ViewModel({
    this.registerScreenState,
    this.onRegister,
  });

  static ViewModel fromStore(Store<AppState> store) {
    return ViewModel(
      registerScreenState: store.state.registerScreenState,
      onRegister: (User user, BuildContext context) {
        Completer<Null> completer = Completer();
        completer.future.then((_) {
          showToast('สมัครสมาชิกแล้ว');
          Navigator.of(context).pop();
        }).catchError((error) {
          if (error is UnProcessableEntity) {
            Scaffold.of(context).showSnackBar(SnackBar(content: Text(error.message)));
          }
        });

        store.dispatch(RegisterAction(user, completer));
      },
    );
  }
}
