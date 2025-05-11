import 'dart:async';

import 'package:pet_project1/customers/customer_class.dart';
import 'package:pet_project1/customers/customer_jake.dart';
import 'package:pet_project1/models/logistics.dart';
import 'package:rxdart/rxdart.dart';

import '../bakery/models/bakery_class.dart';
import '../enums/all_enums.dart';
import '../fields/field_class.dart';
import '../models/item_class.dart';
import '../mill/models/mill_class.dart';
import '../thresher/models/threasher_class.dart';
import '../warehouse/warehouse_class.dart';

class MainBloc {
  MainBloc() {
    warehouseDataSubject.add(Warehouse(
        updatingCostTextSubject: updatingCostTextSubject,
        updatingSubject: isUpdateSubjects));
    startTime();
    isUpdateSubjects.listen((UpdatingType? updatingType) {
      switch (updatingType) {
        case null:
          return;
        case UpdatingType.milling:
          millDataSubject.add(millDataSubject.value);
          isUpdateSubjects.add(null);
        case UpdatingType.field:
          fieldDataListSubject.add(fieldDataListSubject.value);
          isUpdateSubjects.add(null);
        case UpdatingType.threshing:
          thresherDataSubject.add(thresherDataSubject.value);
          isUpdateSubjects.add(null);
        case UpdatingType.warehouse:
          warehouseDataSubject.add(warehouseDataSubject.value);
          isUpdateSubjects.add(null);
      }
    });
    startToGrowUpFields();
    welcomeCustomer();


    StreamSubscription<int> timeSubscription = tickerSubject.listen((tick) {
      List<Customer> customers = customersListSubject.value;
      customers.forEach((customer) {
        if (customer.readyToBuy) {
          newWaitingCustomer.add(customer);
          customer.updateReadyToBuy();
        }
      });
    });


    StreamSubscription<Customer> waitingQueueSubscription = newWaitingCustomer
        .listen((customer) {
      List<dynamic> order = customer.tryToBuy(
          season: null, playersWarehouse: warehouseDataSubject.value);
      if(order[0] == 'buy'){
        warehouseDataSubject.value.buyItem(item: order[1], count: order[2]);
      } else if(order[0] == 'not buy'){
        print("Покупка не была произведена(newWaitingCustomer)");
      } else if(order[0] == 'No item'){
        print("Не хватает элемента ${order[1]}");
      }
    });
  }

  StreamSubscription<Customer>? waitingQueueSubscription;

  final BehaviorSubject<UpdatingType?> isUpdateSubjects = BehaviorSubject
      .seeded(null);

  final BehaviorSubject<List<Field>> fieldDataListSubject =
  BehaviorSubject.seeded([
    Field(name: 'Поле 1', total: 20, filled: 0),
    Field(name: 'Поле 2', total: 20, filled: 0),
    Field(name: 'Поле 3', total: 20, filled: 0),
    Field(name: 'Поле 4', total: 20, filled: 0),
  ]);
  final BehaviorSubject<Mill> millDataSubject =
  BehaviorSubject.seeded(Mill(name: 'Мельница'));

// ClockTimer methods
//------------------------------------------------------------

  BehaviorSubject<Seasons> seasonSubject =
  BehaviorSubject.seeded(Seasons.spring);

  final tickerSubject = BehaviorSubject<int>();
  Timer? _timer;
  int _tickCount = -1;
  bool _isRunning = false;

  // int tickTimeSeconds = 1;
  int tickTimeMiliseconds = 1000;

  Stream<int> get tickStream => tickerSubject.stream;

  void startTime() {
    if (_isRunning) return;

    _isRunning = true;
    final duration = Duration(milliseconds: tickTimeMiliseconds);

    _timer = Timer.periodic(duration, (timer) {
      _tickCount++;
      tickerSubject.add(_tickCount);

      if (_tickCount > 999) {
        _tickCount = 0;
      }

      if (_tickCount % 250 == 0) {
        _updateSeason(_tickCount);
      }
    });
  }

  void stopTime() {
    _timer?.cancel();
    _isRunning = false;
  }

  void _updateSeason(int timer) {
    if (timer < 250) {
      seasonSubject.add(Seasons.spring);
    } else if (timer < 500) {
      seasonSubject.add(Seasons.summer);
    } else if (timer < 750) {
      seasonSubject.add(Seasons.autumn);
    } else if (timer < 1000) {
      seasonSubject.add(Seasons.winter);
    }
  }

// Warehouse methods
//------------------------------------------------------------
  BehaviorSubject<Map<Item, int>> updatingCostTextSubject = BehaviorSubject();

  final BehaviorSubject<Warehouse> warehouseDataSubject =
  BehaviorSubject<Warehouse>();

// Fields methods
//------------------------------------------------------------

  Future startToGrowUpFields() async {
    List<Field> fields = fieldDataListSubject.value;
    for (Field field in fields) {
      field.updating(
          updatingSubject: isUpdateSubjects, tickerSubject: tickerSubject);
    }
  }

  Future shipFromFieldToMill({required String fieldName}) async {
    final fieldsList = fieldDataListSubject.valueOrNull ?? [];

    int indexCurrentField =
    fieldsList.indexWhere((field) => field.name == fieldName);
    if (indexCurrentField == -1) return;
    int countOfWheat = fieldsList[indexCurrentField].ship();
    logistics.deliverToThresher(
        items: {ItemType.wheat: countOfWheat},
        thresher: thresherDataSubject.valueOrNull);
    fieldDataListSubject.add(fieldDataListSubject.value);
    thresherDataSubject.add(thresherDataSubject.value);
  }

// Mill methods
//------------------------------------------------------------

  Future gridWheat() async {
    Mill mill = millDataSubject.value;
    mill.grindWheatGrain(
        updatingSubject: isUpdateSubjects, tickSubject: tickerSubject);
  }

  void setNewPercentToMil(double flourToBakeryPercent, Seasons season) {
    Mill mill = millDataSubject.value;
    mill.setNewPercent(newMap: {
      ItemType.flour: {
        Buildings.bakery: flourToBakeryPercent.toInt(),
        Buildings.warehouse: (100 - flourToBakeryPercent.toInt()),
      }
    }, season: season);
  }

  void deliverFromMill() {
    logistics.deliverFromMill(
        mill: millDataSubject.value,
        warehouse: warehouseDataSubject.value,
        bakery: bakeryDataSubject.value,
        currentSeason: seasonSubject.value);
    millDataSubject.add(millDataSubject.value);
    warehouseDataSubject.add(warehouseDataSubject.value);
    bakeryDataSubject.add(bakeryDataSubject.value);
  }

  //TODO сделать параметры настройки

  void shipByParameters() {
    print('Пока не работает');
  }

// Logistics methods
//------------------------------------------------------------
  Logistics logistics = Logistics();

// Thresher methods
//------------------------------------------------------------
  final BehaviorSubject<Thresher> thresherDataSubject =
  BehaviorSubject.seeded(Thresher(name: 'Молотилка'));

  void setNewPercentToThresher(double wheatGridToMillPercent, Seasons season) {
    Thresher thresher = thresherDataSubject.value;
    thresher.setNewPercent(newMap: {
      ItemType.wheatGrain: {
        Buildings.mill: wheatGridToMillPercent.toInt(),
        Buildings.warehouse: (100 - wheatGridToMillPercent.toInt()),
      }
    }, season: season);
  }

  void deliverFromThresher() {
    logistics.deliverFromThresher(
        thresher: thresherDataSubject.value,
        warehouse: warehouseDataSubject.value,
        mill: millDataSubject.value,
        currentSeason: seasonSubject.value);
    thresherDataSubject.add(thresherDataSubject.value);
    warehouseDataSubject.add(warehouseDataSubject.value);
  }

  void threshering() {
    Thresher thresher = thresherDataSubject.value;
    thresher.thresheringWheat(
        updatingSubject: isUpdateSubjects, tickSubject: tickerSubject);
  }

// Bakery methods
//------------------------------------------------------------
  final BehaviorSubject<Bakery?> bakeryDataSubject =
  BehaviorSubject.seeded(null);

// Sale methods
//------------------------------------------------------------

  void changeItemsSale(Item item) {
    Warehouse warehouse = warehouseDataSubject.value;
    warehouse.invertItemsSale(item);
    warehouseDataSubject.add(warehouse);
  }

  //Customer
  //------------------------------------------------------------

  BehaviorSubject<List<Customer>> customersListSubject = BehaviorSubject();

  BehaviorSubject<Customer> newWaitingCustomer = BehaviorSubject();


  void welcomeCustomer() {
    customersListSubject.add([
      Jack(
          tickerSubject: tickerSubject,
          playerWarehouseSubject: warehouseDataSubject)
    ]);
    // customerSubject.add([Customer(name: 'Евгений', tickerSubject: tickerSubject, money: null, salary: null, countOfItems: null, countOfItems: null, consumption: null, consumption: null, playerWarehouseSubject: null)]);
  }

  dispose() {
    fieldDataListSubject.close();
    millDataSubject.close();
    stopTime();
    tickerSubject.close();
    waitingQueueSubscription?.cancel();
    newWaitingCustomer.close();
  }
}
