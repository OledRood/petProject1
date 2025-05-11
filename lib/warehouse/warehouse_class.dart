import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../enums/all_enums.dart';
import '../models/item_class.dart';

class Warehouse {
  final BehaviorSubject<Map<Item, int>> updatingCostTextSubject;
  BehaviorSubject<UpdatingType?> updatingSubject;
  List<Item> itemsList = [];

  Warehouse({
    required this.updatingCostTextSubject,
    required this.updatingSubject,
  }) {
    updatingCostTextSubscription = updatingCostTextSubject
        .debounceTime(Duration(milliseconds: 300))
        .listen((map) {
      print(map);
    });
  }

  StreamSubscription? updatingCostTextSubscription;

  void loadItems({required Map<ItemType, int> data}) {
    data.forEach((itemType, count) {
      Item? itemInListOrNull = getItemByTypeOrNull(itemType);
      if (itemInListOrNull == null) {
        Item item =
            Item(itemType: itemType, count: count, price: 1, isSale: false);
        itemsList.add(item);
      } else {
        itemInListOrNull.addCount(count);
      }
    });
  }

  void buyItem({required Item item, required int count}) {
    print('Произведена покупка ${item.getName()} в количестве $count');
    item.removeCount(count);
    updatingSubject?.add(UpdatingType.warehouse);
  }

  Item? getItemByTypeOrNull(ItemType type) {
    try {
      return itemsList.firstWhere((item) => item.itemType == type);
    } catch (e) {
      return null;
    }
  }

  List<Item> getListWithItemsData() {
    return itemsList;
  }

  void invertItemsSale(Item item) {
    item.isSale = !item.isSale;
  }
}
