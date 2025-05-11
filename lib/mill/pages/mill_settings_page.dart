import 'package:flutter/material.dart';
import 'package:pet_project1/widgets/app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../blocs/main_bloc.dart';
import '../../enums/all_enums.dart';
import '../../models/seasons_class.dart';
import '../../sources/app_colors.dart';
import '../models/mill_class.dart';

class MillSettingsPage extends StatelessWidget {
  const MillSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context: context, name: 'Молотилка', isPause: false),
      backgroundColor: AppColors.background,
      body: SafeArea(child: _ThresherSettingsContent()),
    );
  }
}

class _ThresherSettingsContent extends StatelessWidget {
  const _ThresherSettingsContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 350, minWidth: 300),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              ColumnSeasonsWidgets(),
              SizedBox(height: 50),
              _BackButton(),
            ],
          ),
        ),
      ],
    );
  }
}

class ColumnSeasonsWidgets extends StatefulWidget {
  const ColumnSeasonsWidgets({super.key});

  @override
  State<ColumnSeasonsWidgets> createState() => _ColumnSeasonsWidgetsState();
}

class _ColumnSeasonsWidgetsState extends State<ColumnSeasonsWidgets> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _StaticSettingsWidget(name: "Солома"),
        SizedBox(height: 10),
        _WheatGrainSettingWidget(),
      ],
    );
  }
}


class _WheatGrainSettingWidget extends StatelessWidget {
  const _WheatGrainSettingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder(stream: bloc.bakeryDataSubject, builder: (context, snapshot){
      if(snapshot.data != null){
        return _WheatGrainSliderWidget();
      } else {
        return _StaticSettingsWidget(name: "Зерно");
      }
    });
  }
}

Seasons currentSeason = Seasons.spring;
class _WheatGrainSliderWidget extends StatefulWidget {
  const _WheatGrainSliderWidget({super.key});

  @override
  State<_WheatGrainSliderWidget> createState() => _WheatGrainSliderWidgetState();
}

class _WheatGrainSliderWidgetState extends State<_WheatGrainSliderWidget> {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<Mill>(
        stream: bloc.millDataSubject,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot == null) {
            return SizedBox.shrink();
          }
          Mill mill = snapshot.data!;
          double percentToWarehouse = mill
              .resourceDistribution[currentSeason]![ItemType.flour]![Buildings.warehouse]!
              .toDouble();
          double percentToBakery = (100 -
              mill.resourceDistribution[currentSeason]![ItemType.flour]![
              Buildings.warehouse]!)
              .toDouble();
          double sliderValue = percentToBakery;
          return Container(
            padding: EdgeInsets.all(10),
            // width: 350,
            decoration: BoxDecoration(
                color: AppColors.transparentBlack,
                borderRadius: BorderRadius.circular(10)),
            child: Stack(
              children: [
                GestureDetector(
                  onTap: (){
                    setState(() {
                      currentSeason = SeasonsClass.change(currentSeason);
                    });},
                  child: Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Icon(SeasonsClass.getIconBySeason(currentSeason)),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    'Зерно',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 35),
                    Row(
                      children: [
                        Column(
                          children: [
                            Text(
                              'На склад',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text('${percentToWarehouse.toInt()} %',
                                style: TextStyle(fontSize: 18))
                          ],
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              'В пекарню',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${percentToBakery.toInt()} %',
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        )
                      ],
                    ),
                    Slider(
                        value: sliderValue,
                        min: 0,
                        max: 100,
                        activeColor: AppColors.textButton,
                        inactiveColor: AppColors.background,
                        onChanged: (newValue) {
                          setState(() {
                            sliderValue = newValue;
                          });

                          bloc.setNewPercentToMil(newValue, currentSeason);
                        })
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class _StaticSettingsWidget extends StatelessWidget {
  final String name;
  const _StaticSettingsWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.transparentBlack,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(
              '$name',
              style: TextStyle(fontSize: 24),
            ),
            Row(
              children: [
                Text(
                  'На склад',
                  style: TextStyle(fontSize: 18),
                ),
                Spacer(),
                Text('100 %', style: TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ));
  }
}


class _BackButton extends StatelessWidget {
  const _BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        bloc.startTime();
      },
      child: Container(
        alignment: Alignment.center,
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.textButton,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          'Вернуться',
          style: TextStyle(fontSize: 20, color: AppColors.background),
        ),
      ),
    );
  }
}
