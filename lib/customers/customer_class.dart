import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../enums/all_enums.dart';
import '../enums/items_type.dart';
import '../warehouse/warehouse_class.dart';

abstract class Customer {
  final String name;
  final BehaviorSubject<int> tickerSubject;
  final BehaviorSubject<Warehouse> playerWarehouseSubject;
  final String description;
  int money;
  int visitCooldown;
  List<ItemType> listItemsForPurchase;
  int salaryDay;
  int buyDay;
  int salary;
  bool readyToBuy;

  Customer({
    required this.name,
    required this.tickerSubject,
    required this.playerWarehouseSubject,
    required this.description,
    required this.money,
    required this.visitCooldown,
    required this.listItemsForPurchase,
    required this.salaryDay,
    required this.buyDay,
    required this.salary,
    required this.readyToBuy,
  });


  Future logicByTick() async {}

  List<dynamic> tryToBuy({required final Seasons? season, required final Warehouse playersWarehouse});

  void updateReadyToBuy(){
    readyToBuy = false;
  }

  void getSalary() {}



  void consumption() {}
// StreamSubscription? tickSubscription;
// Future startCustomerLogic() async {
//   tickSubscription = tickerSubject.listen((tick){
//
//   });
// }

// dispose(){
//   tickSubscription?.cancel();
// }
}
