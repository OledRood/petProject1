import 'dart:async';
import 'dart:ffi';

import 'package:pet_project1/mill/models/mill_sorting_module.dart';
import 'package:rxdart/rxdart.dart';

import '../../enums/all_enums.dart';

class Thresher {
  final String name;

  Thresher({required this.name});

  ThresherState thresherState = ThresherState.none;
  int? timer;

  Map<ItemType, int> thresherWarehouse = {
    ItemType.wheatGrain: 0,
    ItemType.straw: 0,
    ItemType.wheat: 0
  };

  StreamSubscription? thresherSubscription;
  int howItemsThreshedByOneSecond = 1;
  int _countOfWheatToThreshered = 10;

  Future thresheringWheat(
      {required BehaviorSubject<UpdatingType?> updatingSubject,
      required BehaviorSubject<int> tickSubject}) async {
    if (thresherState == ThresherState.threshing) return;
    int waitingWheat = thresherWarehouse[ItemType.wheat]!;
    if (waitingWheat < 10) {
      thresherState = ThresherState.shortage;
      updatingSubject.add(UpdatingType.threshing);
      updatingStatus(updatingSubject);
    } else {
      thresherState = ThresherState.threshing;
      timer = _countOfWheatToThreshered;
      thresherWarehouse[ItemType.wheat] =
          waitingWheat - _countOfWheatToThreshered;
      updatingSubject.add(UpdatingType.threshing);
      thresherSubscription =
          tickSubject.bufferCount(howItemsThreshedByOneSecond).listen((tick) {
        timer = timer! - 5;
        updatingSubject.add(UpdatingType.threshing);
        if (timer! <= 0) {
          _updateWarehouseAfterThresher();
          updatingStatus(updatingSubject);
          stopSubscription();
        }
      });
    }
  }

  void _updateWarehouseAfterThresher(){
    int _countPlusWheatGrain = 3;
    int _countPlusStraw = 3;

    thresherWarehouse[ItemType.wheatGrain] =
        thresherWarehouse[ItemType.wheatGrain]! + _countPlusWheatGrain;
    thresherWarehouse[ItemType.straw] =
        thresherWarehouse[ItemType.straw]! + _countPlusStraw;
  }

  Map<Seasons, Map<ItemType, Map<Buildings, int>>> resourceDistribution = {
    Seasons.spring: {
      ItemType.wheatGrain: {
        Buildings.mill: 50,
        Buildings.warehouse: 50,
      },
      ItemType.straw: {
        Buildings.warehouse: 100,
      },
    },
    Seasons.summer: {
      ItemType.wheatGrain: {
        Buildings.mill: 50,
        Buildings.warehouse: 50,
      },
      ItemType.straw: {
        Buildings.warehouse: 100,
      },
    },
    Seasons.autumn: {
      ItemType.wheatGrain: {
        Buildings.mill: 50,
        Buildings.warehouse: 50,
      },
      ItemType.straw: {
        Buildings.warehouse: 100,
      },
    },
    Seasons.winter: {
      ItemType.wheatGrain: {
        Buildings.mill: 50,
        Buildings.warehouse: 50,
      },
      ItemType.straw: {
        Buildings.warehouse: 100,
      },
    },
  };

  void stopSubscription() {
    thresherSubscription?.cancel();
  }

  Future updatingStatus(BehaviorSubject updatingSubject) async {
    if (thresherState == ThresherState.threshing) {
      thresherState = ThresherState.done;
      updatingSubject.add(UpdatingType.threshing);
    }
    await Future.delayed(const Duration(seconds: 1));

    if (thresherState != ThresherState.threshing) {
      thresherState = ThresherState.none;
    }
    updatingSubject.add(UpdatingType.threshing);
  }

  void loadWheat({required int count}) {
    int currentCount = thresherWarehouse[ItemType.wheat]!;
    thresherWarehouse[ItemType.wheat] = currentCount + count;
  }


  Map<ItemType, int> ship() {
    int wheatGrainCount = thresherWarehouse[ItemType.wheatGrain]!;
    thresherWarehouse[ItemType.wheatGrain] = 0;
    int strawCount = thresherWarehouse[ItemType.straw]!;
    thresherWarehouse[ItemType.straw] = 0;
    return {ItemType.wheatGrain: wheatGrainCount, ItemType.straw: strawCount};
  }

  void setNewPercent(
      {required final Map<ItemType, Map<Buildings, int>> newMap, required final Seasons season}) {
    newMap.forEach((ItemType item, value) {
      resourceDistribution[season]![item] = value;
    });
  }

  // void addSortingModule(){
  //   sortingModule = MillSortingModule();
  // }

  dispose() {
    thresherSubscription?.cancel();
  }
}
