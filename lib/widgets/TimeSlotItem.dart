import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeSlotItem extends StatelessWidget {
  final void Function()onChange;
  final date;
  final bool isSelected;
  const TimeSlotItem({Key? key, required this.date,required this.onChange,required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List data = DateFormat.jm(context.locale.toString()).format(DateFormat("hh:mm:ss").parse(date)).split(" ");
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
                //DateFormat.jm(context.locale.toString()).format(DateFormat("hh:mm:ss").parse(date)),
                data[0],
                style: isSelected
                    ? Constants.smallTitleText
                    : Constants.regularText,
              ),Text(
                data[1].replaceAll("م", "مساء").replaceAll("ص", "صباحا"),
                // date.toString().replaceAll(" ", ''),
                style: isSelected
                    ? Constants.smallTitleText
                    : Constants.regularText,
              ),
            ],
          ),
        )
    );
  }
}
