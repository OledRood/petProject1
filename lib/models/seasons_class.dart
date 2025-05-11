import 'package:flutter/material.dart';

import '../enums/all_enums.dart';

class SeasonsClass {
  SeasonsClass();

  Seasons getSeasonByTick(int tick) {
    if (tick < 250) {
      return Seasons.spring;
    } else if (tick < 500) {
      return Seasons.summer;
    } else if (tick < 750) {
      return Seasons.autumn;
    } else {
      return Seasons.winter;
    }
  }

  static IconData getIconBySeason(Seasons season) {
    switch (season) {
      case Seasons.summer:
        return Icons.sunny;
      case Seasons.spring:
        return Icons.eco;
      case Seasons.winter:
        return Icons.ac_unit;
      case Seasons.autumn:
        return Icons.umbrella;
    }
  }

  static Seasons change(Seasons currentSeason) {
    List<Seasons> seasonsList = [
      Seasons.spring,
      Seasons.summer,
      Seasons.autumn,
      Seasons.winter
    ];
    int currentIndex = seasonsList.indexOf(currentSeason);
    currentIndex += 1;
    return (currentIndex == seasonsList.length)
        ? seasonsList[0]
        : seasonsList[currentIndex];
  }
}
