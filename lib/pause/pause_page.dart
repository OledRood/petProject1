import 'package:flutter/material.dart';
import 'package:pet_project1/fields/fields_page.dart';
import 'package:pet_project1/mill/pages/mill_page.dart';
import 'package:pet_project1/warehouse/warehouse_page.dart';
import 'package:pet_project1/sources/app_colors.dart';
import 'package:provider/provider.dart';

import '../blocs/main_bloc.dart';
import '../thresher/pages/thresher_page.dart';
import '../widgets/app_bar_widget.dart';

bool isMenuOpen = true;

class PausePage extends StatelessWidget {
  const PausePage({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    bloc.stopTime();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: PausePageContent()),
    );
  }
}

class PausePageContent extends StatefulWidget {
  const PausePageContent({super.key});

  @override
  State<PausePageContent> createState() => _PausePageContentState();
}

class _PausePageContentState extends State<PausePageContent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CountTimerWidget(),
            Spacer(),
            _ButtonWidget(
              text: 'Поля',
              navigatePage: FieldsPage(),
            ),
            SizedBox(height: 20),
            _ButtonWidget(
              text: 'Молотилка',
              navigatePage: ThresherPage(),
            ),
            SizedBox(height: 20),
            _ButtonWidget(
              text: 'Мельница',
              navigatePage: MillPage(),
            ),
            SizedBox(height: 20),
            _ButtonWidget(
              text: 'Склад',
              navigatePage: WarehousePage(),
            ),

            Spacer(),
            Text('Игра на паузе')
          ],
        ),
      ],
    );
  }
}

class CountTimerWidget extends StatelessWidget {
  const CountTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return StreamBuilder(
        stream: bloc.tickerSubject,
        builder: (context, snapshot) {
          return Text(
            "${snapshot.data ?? 'Пока счетчик не найден'}",
            style: TextStyle(
              fontSize: 32,
            ),
          );
        });
  }
}

class _ButtonWidget extends StatelessWidget {
  final String text;
  final Widget navigatePage;

  const _ButtonWidget(
      {super.key, required this.text, required this.navigatePage});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

    return SizedBox(
      width: 300,
      child: TextButton(
        onPressed: () {
          bloc.startTime();
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => navigatePage));
        },
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(AppColors.textButton)),
        child: Text(
          text,
          style: TextStyle(
            color: AppColors.background,
            fontSize: 34,
          ),
        ),
      ),
    );
  }
}
