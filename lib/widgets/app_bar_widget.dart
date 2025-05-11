import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../blocs/main_bloc.dart';
import '../enums/all_enums.dart';
import '../models/seasons_class.dart';
import '../sources/app_colors.dart';

PreferredSizeWidget appBarWidget(
    {required BuildContext context,
    required final String name,
    required final bool isPause}) {
  final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);

  return AppBar(
    centerTitle: true,
    backgroundColor: AppColors.textButton,
    iconTheme: IconThemeData(color: AppColors.background),
    title: Text(
      name,
      style: TextStyle(fontSize: 24, color: AppColors.background),
    ),
    leading: IconButton(
      icon: Icon(isPause ? Icons.pause : Icons.arrow_back_ios_new), // Ваша иконка
      onPressed: () {
        if (isPause) {

          bloc.stopTime();
        }
        Navigator.pop(context);
      },
    ),
    actions: [
      StreamBuilder(
          stream: bloc.seasonSubject,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              return SizedBox();
            }
            Seasons season = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(SeasonsClass.getIconBySeason(season)),
            );
            // return Text(
            //   _getStringBySeason(season),
            //   style: TextStyle(
            //     color: AppColors.background,
            //   ),
            // );
          }),
    ],
  );
}




