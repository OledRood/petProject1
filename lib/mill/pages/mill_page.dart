import 'package:flutter/material.dart';
import 'package:pet_project1/mill/pages/mill_settings_page.dart';
import 'package:provider/provider.dart';

import '../../blocs/main_bloc.dart';
import '../../enums/all_enums.dart';
import '../../sources/app_colors.dart';
import '../../widgets/app_bar_widget.dart';
import '../models/mill_class.dart';

class MillPage extends StatelessWidget {
  const MillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: appBarWidget(context: context, name: 'Мельница', isPause: true),
        body: SafeArea(child: _MillPageContent()));
  }
}

class _MillPageContent extends StatelessWidget {
  const _MillPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return Column(
      children: [
        SizedBox(height: 10),
        MillWarehouseWidgets(),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _GoToSettingsButton(),
            SizedBox(width: 10),
            GestureDetector(
              onTap: bloc.deliverFromMill,
              child: Container(
                alignment: Alignment.center,
                height: 50,
                width: 290,
                decoration: BoxDecoration(
                  color: AppColors.textButton,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Отгрузить",
                    style:
                    TextStyle(color: AppColors.background, fontSize: 18)),
              ),
            )
          ],
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: () => bloc.gridWheat(),
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                color: AppColors.textButton,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Запуситить',
                  style: TextStyle(
                      color: AppColors.background,
                      fontSize: 20,
                      fontWeight: FontWeight.w700))),
        ),
      ],
    );
  }
}

class TextStateWidget extends StatelessWidget {
  const TextStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<Mill>(
        stream: bloc.millDataSubject,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          Mill millData = snapshot.data!;
          switch (millData.millState) {
            case MillState.none:
              return Text(
                "Простаивает...",
                style: TextStyle(
                  // color: AppColors.background,
                  fontSize: 22,
                ),
              );
            case MillState.milling:
              return Text("Осталось: ${millData.timer} ед.",
                  style: TextStyle(
                    // color: AppColors.background,
                    fontSize: 22,
                  ));

            case MillState.done:
              return Text(
                "Готово",
                style: TextStyle(
                  // color: AppColors.background,
                  fontSize: 22,
                ),
              );
            case MillState.shortage:
              return Text(
                "Недостаток",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                ),
              );
          }
        });
  }
}

class MillWarehouseWidgets extends StatelessWidget {
  const MillWarehouseWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<Mill>(
        stream: bloc.millDataSubject,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          Mill millData = snapshot.data!;
          return Column(
            children: [
              Text('Состояние',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
              Container(
                width: 350,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.transparentBlack,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Текущее:',
                      style: TextStyle(fontSize: 24),
                    ),
                    Spacer(),
                    TextStateWidget(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('Сырье',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
              Container(
                width: 350,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 10),
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.transparentBlack,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      'Зерно',
                      style: TextStyle(fontSize: 24),
                    ),
                    Spacer(),
                    Text(
                      '${millData.millWarehouse[ItemType.wheatGrain]} ед.',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  VerticalContainerItem(
                      name: 'Мука',
                      count: millData.millWarehouse[ItemType.flour]!,
                      onTapToWarehouse: () {
                        bloc.deliverFromMill();
                      }),
                  SizedBox(width: 20),
                  VerticalContainerItem(
                    name: 'Отруби',
                    count: millData.millWarehouse[ItemType.wheatBran]!,
                    onTapToWarehouse: () {},
                  ),
                ],
              ),
            ],
          );
        });
  }
}

class VerticalContainerItem extends StatelessWidget {
  final String name;
  final int count;
  final VoidCallback onTapToWarehouse;

  const VerticalContainerItem(
      {super.key,
      required this.name,
      required this.count,
      required this.onTapToWarehouse});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return Container(
      // height: 100,
      width: 165,
      padding: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.transparentBlack,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            name,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          Text(
            "$count ед.",
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}


class _GoToSettingsButton extends StatelessWidget {
  const _GoToSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => MillSettingsPage()));
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: AppColors.textButton,
          borderRadius: BorderRadius.circular(10),
        ),

        child: Icon(
          Icons.settings,
          color: AppColors.background,
          size: 18,
        ),
        // child: Text("Настроить",
        //     style: TextStyle(color: AppColors.background, fontSize: 18)),
      ),
    );
  }
}