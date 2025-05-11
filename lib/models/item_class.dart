import '../enums/all_enums.dart';

class Item {
  final ItemType itemType;
  int count;
  int countForSell;
  int price;
  bool isSale;

  Item({
    required this.itemType,
    required this.count,
    required this.price,
    required this.isSale,
  }) : countForSell = count;

  Map<ItemType, String> _names = {
    ItemType.flour: 'Мука',
    ItemType.wheat: 'Пшеница',
    ItemType.wheatGrain: 'Зерно',
    ItemType.wheatBran: 'Отруби',
    ItemType.straw: 'Солома',
    ItemType.bread: 'Хлеб',
  };

  void removeCount(int minusCount){
    count -= minusCount;
  }

  void addCount(int plusCount) {
    count += plusCount;
  }

  String getName() {
    return _names[itemType] ?? 'Не опред';
  }

  @override
  String toString() {
    return 'Item{goodsType: $itemType, count: $count, price: $price, isSale: $isSale}';
  }
}
