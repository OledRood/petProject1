import 'dart:async';

import 'package:pet_project1/enums/all_enums.dart';
import 'package:rxdart/rxdart.dart';

import '../enums/items_type.dart';
import '../models/item_class.dart';
import '../warehouse/warehouse_class.dart';
import 'customer_class.dart';

class Jack extends Customer {
  Jack({
    required BehaviorSubject<int> tickerSubject,
    required BehaviorSubject<Warehouse> playerWarehouseSubject,
  }) : super(
          name: 'Джек',
          tickerSubject: tickerSubject,
          playerWarehouseSubject: playerWarehouseSubject,
          description: "Не требовательный покупатель",
          money: 10000,
          visitCooldown: 0,
          listItemsForPurchase: [
            ItemType.flour,
            ItemType.bread,
            ItemType.straw,
            ItemType.wheatGrain,
            ItemType.wheatBran,
            ItemType.wheat,
          ],
          salaryDay: 101,
          buyDay: 20,
          salary: 10,
    readyToBuy: false,
        ) {
    logicByTick();
  }

  bool isFirstHello = true;

  StreamSubscription? tickerSubscription;

  @override
  Future logicByTick() async {
    tickerSubscription = tickerSubject.listen((tick) {
      final Warehouse playerWarehouse = playerWarehouseSubject.value;

      if (tick % buyDay == 0) {
        readyToBuy = true;
        // tryToBuy(season: null, playersWarehouse: playerWarehouse);
      }
      if (tick % salaryDay == 0) {
        getSalary();
      }
    });
  }


  //[Что делает, какой item, количество, цена штуки]
  @override
  List<dynamic> tryToBuy(
      {required final Seasons? season,
      required final Warehouse playersWarehouse}) {
    print('Попытка произвести покупку');

    final Item? itemPlayerStraw =
        playersWarehouse.getItemByTypeOrNull(ItemType.straw);
    if (itemPlayerStraw != null && itemPlayerStraw.count > 0) {
      if (itemPlayerStraw.count >= 10) {
        return ['buy', itemPlayerStraw, 10, 5];
        playersWarehouse.buyItem(item: itemPlayerStraw, count: 10);
        // return;
      }
    } else {
      return ['not buy', itemPlayerStraw, 0, 0];
      print("Покупка не была произведена");

    }
    return ['No item', itemPlayerStraw, 0, 0];
  }

  // void updateReadyToBuy(){
  //   readyToBuy = false;
  // }

  dispose() {
    tickerSubscription?.cancel();
  }
}
