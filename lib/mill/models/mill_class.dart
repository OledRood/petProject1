import 'dart:async';
import 'dart:ffi';

import 'package:pet_project1/mill/models/mill_sorting_module.dart';
import 'package:rxdart/rxdart.dart';

import '../../enums/all_enums.dart';

class Mill {
  final String name;

  MillSortingModule? sortingModule;

  Mill({
    required this.name,
    this.sortingModule,
  });

  MillState millState = MillState.none;
  int? timer;

  Map<ItemType, int> millWarehouse = {
    ItemType.wheatGrain: 0,
    ItemType.flour: 0,
    ItemType.wheatBran: 0,
  };
  int _countOfWheatGrainToGrind = 10;

  void loadWheatGrain({required int newWheatGrain}) {
    millWarehouse[ItemType.wheatGrain] = millWarehouse[ItemType.wheatGrain]! + newWheatGrain;
  }

  StreamSubscription? gridSubscription;

  // int howItemsGrindByOneSecond = 2;
  int howItemsGrindByOneSecond = 1;



  Map<Seasons, Map<ItemType, Map<Buildings, int>>> resourceDistribution = {
    Seasons.spring: {
      ItemType.flour: {
        Buildings.bakery: 0,
        Buildings.warehouse: 100,
      },
      ItemType.wheatBran: {
        Buildings.warehouse: 100,
      },
    },
    Seasons.summer: {
      ItemType.flour: {
        Buildings.bakery: 0,
        Buildings.warehouse: 100,
      },
      ItemType.wheatBran: {
        Buildings.warehouse: 100,
      },
    },
    Seasons.autumn: {
      ItemType.flour: {
        Buildings.bakery: 0,
        Buildings.warehouse: 100,
      },
      ItemType.wheatBran: {
        Buildings.warehouse: 100,
      },
    },
    Seasons.winter: {
      ItemType.flour: {
        Buildings.bakery: 0,
        Buildings.warehouse: 100,
      },
      ItemType.wheatBran: {
        Buildings.warehouse: 100,
      },
    },
  };

  Future grindWheatGrain(
      {required BehaviorSubject<UpdatingType?> updatingSubject,
      required BehaviorSubject<int> tickSubject}) async {
    if (millState == MillState.milling) return;
    if (millWarehouse[ItemType.wheatGrain]! < 10) {
      millState = MillState.shortage;
      updatingSubject.add(UpdatingType.milling);
      updatingStatus(updatingSubject);
    } else {
      millState = MillState.milling;
      millWarehouse[ItemType.wheatGrain] = millWarehouse[ItemType.wheatGrain]! - _countOfWheatGrainToGrind;
      timer = _countOfWheatGrainToGrind;

      updatingSubject.add(UpdatingType.milling);
      gridSubscription =
          tickSubject.bufferCount(howItemsGrindByOneSecond).listen((tick) {
        timer = timer! - 5;
        updatingSubject.add(UpdatingType.milling);
        if (timer! <= 0) {
          _updateWarehouseAfterThresher();
          updatingStatus(updatingSubject);
          stopSubscription();
        }
      });
    }
  }
  void _updateWarehouseAfterThresher(){
    int _countPlusFlour = 2;
    int _countPlusWheatBran = (sortingModule != null ? sortingModule!.sorting(10) : 0);

    millWarehouse[ItemType.flour] = millWarehouse[ItemType.flour]! + _countPlusFlour;
    millWarehouse[ItemType.wheatBran] = millWarehouse[ItemType.wheatBran]! + _countPlusWheatBran;

  }

  void stopSubscription() {
    gridSubscription?.cancel();
  }

  Future updatingStatus(BehaviorSubject updatingSubject) async {
    if (millState == MillState.milling) {
      millState = MillState.done;
      updatingSubject.add(UpdatingType.milling);
    }
    await Future.delayed(const Duration(seconds: 1));

    if (millState != MillState.milling) {
      millState = MillState.none;
    }
    updatingSubject.add(UpdatingType.milling);
  }


  void setNewPercent(
      {required final Map<ItemType, Map<Buildings, int>> newMap, required final Seasons season}) {
    newMap.forEach((ItemType item, value) {
      resourceDistribution[season]![item] = value;
    });
  }


  Map<ItemType, int> ship() {
    int _countFlour = millWarehouse[ItemType.flour]!;
    int _countWheatBran = millWarehouse[ItemType.flour]!;
    millWarehouse[ItemType.flour] = 0;
    millWarehouse[ItemType.wheatBran] = 0;
    return {ItemType.flour: _countFlour, ItemType.wheatBran: _countWheatBran};
  }

  void addSortingModule() {
    sortingModule = MillSortingModule();
  }

  dispose() {
    gridSubscription?.cancel();
  }
}
