class MillSortingModule{
  MillSortingModule();

  int pieceOfSorting = 5;
  int sorting(int countOfWheat){
    return countOfWheat ~/ pieceOfSorting;

  }
}