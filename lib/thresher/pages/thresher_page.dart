import 'package:flutter/material.dart';
import 'package:pet_project1/thresher/pages/thresher_settings_page.dart';
import 'package:provider/provider.dart';

import '../../blocs/main_bloc.dart';
import '../../enums/all_enums.dart';
import '../../sources/app_colors.dart';
import '../../widgets/app_bar_widget.dart';
import '../models/threasher_class.dart';

class ThresherPage extends StatelessWidget {
  const ThresherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar:
            appBarWidget(context: context, name: 'Молотилка', isPause: true),
        body: SafeArea(child: _ThresherPageContent()));
  }
}

class _ThresherPageContent extends StatelessWidget {
  const _ThresherPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return Column(
      children: [
        SizedBox(height: 10),
        _ThresherInfoWidget(),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _GoToSettingsButton(),
            SizedBox(width: 10),
            GestureDetector(
              onTap: bloc.deliverFromThresher,
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
          onTap: () => bloc.threshering(),
          child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 50,
              width: 350,
              decoration: BoxDecoration(
                color: AppColors.textButton,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text('Обмолотить',
                  style: TextStyle(
                      color: AppColors.background,
                      fontSize: 20,
                      fontWeight: FontWeight.w700))),
        ),
      ],
    );
  }
}

class _ThresherInfoWidget extends StatelessWidget {
  const _ThresherInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<Thresher>(
        stream: bloc.thresherDataSubject,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          Thresher thresherData = snapshot.data!;
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
                      'Пшеница',
                      style: TextStyle(fontSize: 24),
                    ),
                    Spacer(),
                    Text(
                      '${thresherData.thresherWarehouse[ItemType.wheat]!} ед.',
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
                      name: 'Зерна',
                      count:
                          thresherData.thresherWarehouse[ItemType.wheatGrain]!,
                      onTapToWarehouse: () {
                        bloc.deliverFromThresher();
                      }),
                  SizedBox(width: 20),
                  VerticalContainerItem(
                    name: 'Cолома',
                    count: thresherData.thresherWarehouse[ItemType.straw]!,
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

  // Или тут просто добавлять item и разбираться по месту
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
            context, MaterialPageRoute(builder: (_) => ThresherSettingsPage()));
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

class TextStateWidget extends StatelessWidget {
  const TextStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<Thresher>(
        stream: bloc.thresherDataSubject,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          Thresher thresherData = snapshot.data!;
          switch (thresherData.thresherState) {
            case ThresherState.none:
              return Text(
                "Простаивает...",
                style: TextStyle(
                  // color: AppColors.background,
                  fontSize: 22,
                ),
              );
            case ThresherState.threshing:
              return Text("Осталось: ${thresherData.timer} ед.",
                  style: TextStyle(
                    // color: AppColors.background,
                    fontSize: 22,
                  ));

            case ThresherState.done:
              return Text(
                "Готово",
                style: TextStyle(
                  // color: AppColors.background,
                  fontSize: 22,
                ),
              );
            case ThresherState.shortage:
              return Text(
                "Недостаток",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                ),
              );
            case ThresherState.upgrading:
              return Text(
                "Реконструкция",
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 22,
                ),
              );
          }
        });
  }
}
