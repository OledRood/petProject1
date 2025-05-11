// import 'dart:async';
//
// import 'package:pet_project1/enums/all_enums.dart';
// import 'package:pet_project1/models/seasons_class.dart';
// import 'package:rxdart/rxdart.dart';
//
// import '../models/item_class.dart';
// import '../warehouse/warehouse_class.dart';
// import 'customer_class.dart';
//
// class MisterG extends Customer {
//   MisterG({
//     required BehaviorSubject<int> tickerSubject,
//     required BehaviorSubject<Warehouse> playerWarehouseSubject,
//   }) : super(
//           name: 'Мистер Г.',
//           tickerSubject: tickerSubject,
//           playerWarehouseSubject: playerWarehouseSubject,
//           description: "Бедный многодетный друг семьи",
//           money: 20,
//           visitCooldown: 0,
//           listItemsForPurchase: [
//             ItemType.flour,
//             ItemType.bread,
//             ItemType.straw
//           ],
//           salaryDay: 50,
//           buyDay: 51,
//           salary: 10,
//           readyToBuy: false,
//         ) {
//     logicByTick();
//   }
//
//   StreamSubscription? tickerSubscription;
//
//   @override
//   Future logicByTick() async {
//     tickerSubscription = tickerSubject.listen((tick) {
//       final Seasons season = SeasonsClass().getSeasonByTick(tick);
//       final Warehouse playerWarehouse = playerWarehouseSubject.value;
//
//       if (tick % buyDay == 0) {
//         tryToBuy(season: season, playersWarehouse: playerWarehouse);
//       }
//       if (tick % salaryDay == 0) {
//         getSalary();
//       }
//     });
//   }
//
//   @override
//   List<dynamic> tryToBuy(
//       {required final Seasons? season,
//       required final Warehouse playersWarehouse}) {
//     if (season == Seasons.winter) {
//       final Item? itemPlayerBread =
//           playersWarehouse.getItemByTypeOrNull(ItemType.bread);
//       if (itemPlayerBread != null && itemPlayerBread.count > 0) {
//         //Логика проверки возможности купить хлеб
//       }
//       //Максимально пытается Положить в корзину хлеб
//     }
//     //Проверяет запасы соломы и если денег хватает закупается ими
//
//     //Возможно сделать штуку для скидки
//
//     //Покупает
//   }
//
//   @override
//   void getSalary() {
//     money += salary;
//   }
//
//   @override
//   void consumption() {}
//
//   dispose() {
//     tickerSubscription?.cancel();
//   }
// }
