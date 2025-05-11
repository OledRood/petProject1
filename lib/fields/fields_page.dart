import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

import '../blocs/main_bloc.dart';
import '../widgets/app_bar_widget.dart';
import 'field_class.dart';
import '../sources/app_colors.dart';
import '../sources/app_images.dart';

class FieldsPage extends StatelessWidget {
  const FieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: appBarWidget( context: context, name: 'Поля', isPause: true),
        body: _FieldsPageContent());
  }
}


class _FieldsPageContent extends StatelessWidget {
  const _FieldsPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: FieldsListView(
            bloc: bloc,
          ),
        ),
      ],
    );
  }
}

class FieldsListView extends StatelessWidget {
  final MainBloc bloc;

  const FieldsListView({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    const double widthFieldWidget = 200;
    return StreamBuilder<List<Field>>(
        stream: bloc.fieldDataListSubject,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox.shrink();
          }
          List<Field> fieldDataList = snapshot.data!;

          return ListView.separated(
            // scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return _FieldWidget(
                width: widthFieldWidget,
                field: fieldDataList[index],
              );
            },
            itemCount: fieldDataList.length,
            separatorBuilder: (contex, index) {
              return SizedBox(
                height: 10,
                width: 10,
              );
            },
          );
        });
  }
}

class _FieldWidget extends StatelessWidget {
  final Field field;
  final double width;

  const _FieldWidget({super.key, required this.width, required this.field});

  @override
  Widget build(BuildContext context) {
    final MainBloc bloc = Provider.of<MainBloc>(context, listen: false);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40, child: Image.asset(AppImages.wheat)),
                    SizedBox(width: 20),
                    Text(
                      field.name,
                      style: TextStyle(fontSize: 24),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Склад",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "${field.filled}/${field.total}",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ],
            ),
            Spacer(),
            SizedBox(
              height: 60,
              width: 150,
              child: TextButton(
                onPressed: () => bloc.shipFromFieldToMill(fieldName: field.name),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(AppColors.textButton)),
                child: Text(
                  "Отгузить",
                  style: TextStyle(
                    color: AppColors.background,
                    fontSize: 20,
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
