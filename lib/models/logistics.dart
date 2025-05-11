import 'package:flutter/material.dart';

import '../bakery/models/bakery_class.dart';
import '../enums/all_enums.dart';
import '../mill/models/mill_class.dart';
import '../thresher/models/threasher_class.dart';
import '../warehouse/warehouse_class.dart';

class Logistics {
  Logistics();

  void deliverToThresher({
    required Map<ItemType, int> items,
    required Thresher? thresher,
  }) {
    if (thresher == null) return;
    Map<ItemType, int> warehouse = thresher.thresherWarehouse;
    items.forEach((key, value) {
      if (warehouse.containsKey(key)) {
        warehouse[key] = warehouse[key]! + value;
      } else {
        debugPrint('Передаем непонятные вещи в thresher');
      }
    });
  }

  void deliverFromMill({
    required Mill mill,
    required Warehouse warehouse,
    required Bakery? bakery,
    required Seasons currentSeason,
  }) {
    Map<ItemType, int> shippedItem = mill.ship();

    Map<Buildings, int> percentFlourMap = mill.resourceDistribution[currentSeason]![ItemType.flour]!;
    Map<Buildings, int> percentWheatBranMap = mill.resourceDistribution[currentSeason]![ItemType.wheatBran]!;

    int countOfFlourToWarehouse = ((percentFlourMap[Buildings.warehouse]!.toDouble() / 100) * shippedItem[ItemType.flour]!.toDouble()).toInt();
    int countOfFlourToBakery = shippedItem[ItemType.flour]! - countOfFlourToWarehouse;
    int countOfWheatBranToWarehouse= mill.millWarehouse[ItemType.wheatBran]! * percentWheatBranMap[Buildings.warehouse]!;

    bakery?.loadFlour(newFlour: countOfFlourToBakery);
    warehouse.loadItems(data: {ItemType.flour: countOfFlourToWarehouse, ItemType.wheatBran: countOfWheatBranToWarehouse});

  }
  void deliverFromThresher({
    required Thresher thresher,
    required Warehouse warehouse,
    required Mill mill,
    required Seasons currentSeason,
  }) {
    Map<ItemType, int> shippedItem = thresher.ship();

    Map<Buildings, int> percentWheatGridMap = thresher.resourceDistribution[currentSeason]![ItemType.wheatGrain]!;
    Map<Buildings, int> percentStrawMap = thresher.resourceDistribution[currentSeason]![ItemType.straw]!;

    int countOfWheatGrainToWarehouse = ((percentWheatGridMap[Buildings.warehouse]!.toDouble() / 100) * shippedItem[ItemType.wheatGrain]!.toDouble()).toInt();
    int countOfWheatGrainToMill = shippedItem[ItemType.wheatGrain]! - countOfWheatGrainToWarehouse;
    int countOfStraw = (shippedItem[ItemType.straw]! * percentStrawMap[Buildings.warehouse]!.toDouble() /100).toInt();

    mill.loadWheatGrain(newWheatGrain: countOfWheatGrainToMill);
    warehouse.loadItems(data: {ItemType.wheatGrain: countOfWheatGrainToWarehouse, ItemType.straw: countOfStraw});

  }
}
