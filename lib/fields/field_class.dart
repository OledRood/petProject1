import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../enums/all_enums.dart';

class Field {
  final String name;
  int filled;
  final int total;

  Field({required this.name, required this.filled, required this.total});

  StreamSubscription? growingSubscription;
  int _timeToGrowUp = 1;

  void updating(
      {required BehaviorSubject tickerSubject,
      required BehaviorSubject<UpdatingType?> updatingSubject}) {
    growingSubscription =
        tickerSubject.bufferCount(_timeToGrowUp).listen((tick) {
      if (filled < total) {
        filled += 1;
        updatingSubject.add(UpdatingType.field);
      }
    });
  }

  int ship() {
    int count = filled;
    filled = 0;
    return count;
  }

  dispose() {
    growingSubscription?.cancel();
  }
}
