import 'package:medical_app/data/model/medicine.dart';
import 'package:medical_app/data/network/medicine_repository.dart';
import 'package:medical_app/redux/app/app_state.dart';
import 'package:medical_app/redux/medicine_list/medicine_list_action.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMedicineMiddleware(
  MedicineRepository medicineRepository,
) {
  return [
    TypedMiddleware<AppState, FetchMedicineByQuery>(
      _fetchMedicineByQuery(medicineRepository),
    ),
  ];
}

Middleware<AppState> _fetchMedicineByQuery(
  MedicineRepository medicineRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is FetchMedicineByQuery) {
      try {
        next(ShowLoading());
        var user = store.state.user;
        var medicines = await medicineRepository.fetchMedicineByQuery(action.query, user.id);
        next(FetchMedicineSuccess(medicines));
      } catch (error) {
        print(error);
        next(FetchMedicinesError());
      }
    }
  };
}
