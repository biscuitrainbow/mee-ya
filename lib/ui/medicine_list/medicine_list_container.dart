import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:rootanya/data/loading_status.dart';
import 'package:rootanya/data/model/medicine.dart';
import 'package:rootanya/redux/app/app_state.dart';
import 'package:rootanya/redux/medicine_list/medicine_list_action.dart';
import 'package:rootanya/redux/medicine_notification/medicine_notification_action.dart';
import 'package:rootanya/ui/medicine_list/medicine_list_mode.dart';
import 'package:rootanya/ui/medicine_list/medicine_list_screen.dart';
import 'package:rootanya/util/widget_utils.dart';
import 'package:redux/redux.dart';

class MedicineListContainer extends StatefulWidget {
  final MedicineListMode mode;

  MedicineListContainer({this.mode});

  @override
  _MedicineListContainerState createState() => _MedicineListContainerState();
}

class _MedicineListContainerState extends State<MedicineListContainer> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector(
      onDispose: (Store store) => store.dispatch(ResetStateAction()),
      converter: MedicineListScreenViewModel.fromStore,
      builder: (BuildContext context, MedicineListScreenViewModel vm) {
        print(vm.queriedMedicines.length);

        return MedicineListScreen(
          mode: widget.mode,
          viewModel: vm,
        );
      },
    );
  }
}

class MedicineListScreenViewModel {
  final List<Medicine> queriedMedicines;
  final List<Medicine> medicines;

  final bool isSearching;
  final bool isListening;
  final Function onSearchClick;
  final Function(String) onQueryChanged;
  final Function onVoiceClicked;
  final LoadingStatus loadingStatus;
  final VoidCallback showListening;
  final VoidCallback hideListening;
  final Function(Time, Medicine) onAddNotification;

  MedicineListScreenViewModel({
    this.medicines,
    this.queriedMedicines,
    this.isSearching,
    this.isListening,
    this.onSearchClick,
    this.onVoiceClicked,
    this.onQueryChanged,
    this.loadingStatus,
    this.showListening,
    this.hideListening,
    this.onAddNotification,
  });

  static MedicineListScreenViewModel fromStore(Store<AppState> store) {
    return MedicineListScreenViewModel(
      queriedMedicines: store.state.medicineListState.queriedMedicines,
      medicines: store.state.medicineListState.medicines,
      isSearching: store.state.medicineListState.isSearching,
      isListening: store.state.medicineListState.isListening,
      loadingStatus: store.state.medicineListState.loadingStatus,
      showListening: () => store.dispatch(ActivateSpeechRecognizer()),
      hideListening: () => store.dispatch(DeactivateSpeechRecognizer()),
      onSearchClick: () => store.dispatch(ToggleSearching()),
      onQueryChanged: (String query) => store.dispatch(FetchMedicineByQuery(query)),
      onAddNotification: (Time time, Medicine medicine) {
        Completer<Null> completer = Completer();
        completer.future.then((_) {
          showToast("ตั้งแจ้งเตือนแล้ว");
        });

        store.dispatch(AddMedicineNotification(time, medicine, completer));
      },
    );
  }
}
