import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pet_project1/warehouse/warehouse_class.dart';
import 'package:pet_project1/sources/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../blocs/main_bloc.dart';
import '../models/item_class.dart';
import '../sources/app_images.dart';
import '../widgets/app_bar_widget.dart';

class WarehousePage extends StatelessWidget {
  const WarehousePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: appBarWidget(context: context, name: 'Склад', isPause: true),
        body: _WarehousePageContent());
  }
}

class _WarehousePageContent extends StatelessWidget {
  const _WarehousePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return Column(
      children: [
        SizedBox(height: 20),
        StreamBuilder(
            stream: bloc.warehouseDataSubject,
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return SizedBox.shrink();
              }
              Warehouse warehouseData = snapshot.data!;
              return _ItemsListView(
                  itemList: warehouseData.getListWithItemsData());
            }),
      ],
    );
  }
}

class _ItemsListView extends StatelessWidget {
  final List<Item> itemList;

  const _ItemsListView({super.key, required this.itemList});

  @override
  Widget build(BuildContext context) {
    if (itemList.isEmpty)
      return Center(
        child: Text(
          'Пока ничего нет',
          style: TextStyle(fontSize: 30),
        ),
      );
    return Expanded(
        child: ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            itemBuilder: (context, index) {
              return _ItemDataContainer(item: itemList[index]);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 10);
            },
            itemCount: itemList.length));
  }
}

class _ItemDataContainer extends StatelessWidget {
  final Item item;

  const _ItemDataContainer({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        padding: EdgeInsets.all(15),
        // height: 200,
        // width: width,
        decoration: BoxDecoration(
          color: AppColors.transparentBlack,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 25, child: Image.asset(AppImages.box)),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${item.getName()}",
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Количество: ${item.count}",
                    style: TextStyle(fontSize: 20)),
                _CostItemWidget(item: item),
              ],
            ),
            Spacer(),
            Column(
              children: [
                SizedBox(
                  height: 40,
                  width: 150,
                  child: TextButton(
                    // onPressed: ()=> bloc.changeItemsSale(item),
                    onPressed: () {
                      print('Еще не обработано');
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.textButton.withOpacity(0.3))),
                    child: Text(
                      "Переработка",
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  width: 150,
                  child: TextButton(
                    onPressed: () => bloc.changeItemsSale(item),
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.textButton)),
                    child: Text(
                      item.isSale ? "Продается" : "Не продается",
                      style: TextStyle(
                        color: AppColors.background,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }
}

class _CostItemWidget extends StatefulWidget {
  final Item item;

  const _CostItemWidget({super.key, required this.item});

  @override
  State<_CostItemWidget> createState() => _CostItemWidgetState();
}

class _CostItemWidgetState extends State<_CostItemWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.item.price.toString());
  }

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Цена:',
            style: TextStyle(fontSize: 20)),
        SizedBox(width: 10),
        TextField(
          controller: _controller,
          onChanged: (newValue) {
            final cursorPosition = _controller.selection.base.offset;

            if (newValue == "") {
              newValue = "0";
            }

            if (newValue.length > 1 && newValue[0] == "0") {
              newValue = int.parse(newValue).toString();
            }
            if (_controller.text != newValue) {
              _controller.value = TextEditingValue(
                text: newValue,
                selection: TextSelection.collapsed(
                    offset: min(cursorPosition, newValue.length)
                ),
              );
            }

            bloc.updatingCostTextSubject.add({widget.item: int.parse(newValue)});

          },
          decoration: const InputDecoration(

            constraints: BoxConstraints(
                maxWidth: 120, maxHeight: 55, minWidth: 50, minHeight: 55),
            hintText: "Цена продажи",
            border: null,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.only(top: 12),
          ),
          cursorColor: AppColors.cursor,
          style: TextStyle(color: Colors.black, fontSize: 20),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(5),
          ],
          keyboardType: TextInputType.number,
          // textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
