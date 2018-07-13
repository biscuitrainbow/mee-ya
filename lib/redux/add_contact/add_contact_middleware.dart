import 'package:medical_app/data/network/user_repository.dart';
import 'package:medical_app/redux/add_contact/add_contact_action.dart';
import 'package:medical_app/redux/app/app_state.dart';
import 'package:medical_app/redux/contract/contact_action.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAddContactMiddleware(
  UserRepository userRepository,
) {
  return [
    new TypedMiddleware<AppState, AddContactAction>(addContact(userRepository)),
    new TypedMiddleware<AppState, EditContactAction>(editContact(userRepository)),
    new TypedMiddleware<AppState, DeleteContactAction>(deleteContact(userRepository)),
  ];
}

Middleware<AppState> addContact(
  UserRepository userRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is AddContactAction) {
      try {
        next(RequestAddContactAction());

        await userRepository.addContact(action.contact, '1');
        action.completer.complete(null);

        next(SuccessAddContactAction());
        store.dispatch(FetchContactsAction('1'));
      } catch (error) {
        next(ErrorAddContactAction());
      }

      next(action);
    }
  };
}

Middleware<AppState> editContact(
  UserRepository userRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is EditContactAction) {
      try {
        next(RequestEditContactAction());

        await userRepository.updateContact(action.contact);
        action.completer.complete(null);

        next(SuccessEditContactAction());
        store.dispatch(FetchContactsAction('1'));
      } catch (error) {
        next(ErrorEditContactAction());
      }

      next(action);
    }
  };
}

Middleware<AppState> deleteContact(
  UserRepository userRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is DeleteContactAction) {
      print('delete');

      try {
        await userRepository.deleteContact(action.contact.id);
        action.completer.complete(null);

        store.dispatch(FetchContactsAction('1'));
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}
