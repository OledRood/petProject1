import 'package:flutter/material.dart';
import 'package:pet_project1/widgets/app_bar_widget.dart';
import 'package:provider/provider.dart';

import '../../blocs/main_bloc.dart';
import '../../enums/all_enums.dart';
import '../../models/seasons_class.dart';
import '../../sources/app_colors.dart';
import '../models/threasher_class.dart';

class ThresherSettingsPage extends StatelessWidget {
  const ThresherSettingsPage({super.key});

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
        _StrawSettingWidget(),
        SizedBox(height: 10),
        _WheatSliderWidget(),
      ],
    );
  }
}

Seasons currentSeason = Seasons.spring;
class _WheatSliderWidget extends StatefulWidget {
  const _WheatSliderWidget({super.key});

  @override
  State<_WheatSliderWidget> createState() => _WheatSliderWidgetState();
}

class _WheatSliderWidgetState extends State<_WheatSliderWidget> {
  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return StreamBuilder<Thresher>(
        stream: bloc.thresherDataSubject,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot == null) {
            return SizedBox.shrink();
          }
          Thresher thresher = snapshot.data!;
          double percentToWarehouse = thresher
              .resourceDistribution[currentSeason]![ItemType.wheatGrain]![Buildings.warehouse]!
              .toDouble();
          double percentToMill = (100 -
                  thresher.resourceDistribution[currentSeason]![ItemType.wheatGrain]![
                      Buildings.warehouse]!)
              .toDouble();
          double sliderValue = percentToMill;
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
                              'На мельницу',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              '${percentToMill.toInt()} %',
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
                          bloc.setNewPercentToThresher(newValue, currentSeason);
                        })
                  ],
                ),
              ],
            ),
          );
        });
  }
}

class _StrawSettingWidget extends StatelessWidget {
  const _StrawSettingWidget({super.key});

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
              'Солома',
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
