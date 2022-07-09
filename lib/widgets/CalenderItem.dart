import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CalendarItem extends StatelessWidget {
  final void Function()onChange;
  final date;
  final bool isSelected;
  const CalendarItem({Key? key, required this.date,required this.onChange,required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onChange,
      child: Container(
        width: 135,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
            color: isSelected
                ? Constants.theardColor
                : Constants.mainColor,
            borderRadius: BorderRadius.circular(7)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("MMM",context.locale.toString())
                  .format(DateTime.parse(date))
                  .toUpperCase(),
              style: isSelected
                  ? Constants.smallTitleText
                  : Constants.regularText,
            ),
            Text(
              DateFormat.d(context.locale.toString()).format(DateTime.parse(date)),
              style: isSelected
                  ? Constants.smallTitleText
                  : Constants.regularText,
            ),
            Text(
              DateFormat.EEEE(context.locale.toString()).format(DateTime.parse(date)),
              style: isSelected
                  ? Constants.smallTitleText
                  : Constants.regularText,
            ),
          ],
        ),
      ),
    );
  }
}
