import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:fanan_elrashaka_clinic/Network/Bookings.dart';
import 'package:fanan_elrashaka_clinic/helper/lunch.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BooksCard extends StatelessWidget {
  final String day, time, date, type, doctor, location;

   BooksCard(
      {Key? key,
      required this.day,
      required this.time,
      required this.date,
      required this.type,
      required this.doctor,
      required this.location})
      : super(key: key);

  Launch _launch = new Launch();
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 10,top: 10),
        decoration: BoxDecoration(
          color: Constants.mainColor,
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(1, 4), // changes position of shadow
            ),
          ],
        ),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.Day.tr(),
                      style: Constants.theardSmallTextBookScreen,
                    ),
                    SizedBox(height: 5,),
                    Text(
                      "${day}",
                      style: (context.locale.toString()=="en")?Constants.smallTextBookScreen:Constants.secondsmallTextBookScreen,
                    ),
                  ],
                ),
                Padding(
                  padding: (context.locale.toString()=="en")? const EdgeInsets.only(right: 8.0):const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.Date.tr(),
                        style: Constants.theardSmallTextBookScreen,
                      ),
                      SizedBox(height: 5,),
                      Text(
                        "${date}",
                        style: (context.locale.toString()=="en")?Constants.smallTextBookScreen:Constants.secondsmallTextBookScreen,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: (context.locale.toString()=="en")?const EdgeInsets.only(right: 10):const EdgeInsets.only(left: 5),
                        child: Text(
                          LocaleKeys.Time.tr(),
                          style: Constants.theardSmallTextBookScreen,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Text(
                        "${time}",
                        style: (context.locale.toString()=="en")?Constants.smallTextBookScreen:Constants.secondsmallTextBookScreen,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.Type.tr(),
                      style: Constants.theardSmallTextBookScreen,
                    ),
                    SizedBox(height: 5,),
                    SizedBox(
                      width: 70,
                      child: Text(
                        "${type}",
                        style: (context.locale.toString()=="en")?Constants.smallTextBookScreen:Constants.secondsmallTextBookScreen,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:(context.locale.toString()=="en")? const EdgeInsets.only(left: 41.0):const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.Doctor.tr(),
                        style: Constants.theardSmallTextBookScreen,
                      ),
                      SizedBox(height: 5,),
                      Text(
                        "${doctor}",
                        style: (context.locale.toString()=="en")?Constants.smallTextBookScreen:Constants.secondsmallTextBookScreen,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: (){
                    if(location!=" ")
                    _launch.launchLink(context, location);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (location!=" ")?Constants.secondColor:Colors.grey,
                      borderRadius: BorderRadius.circular(5)
                    ),
                    child: Text(LocaleKeys.Location.tr(),style: TextStyle(fontSize:(context.locale.toString()=="en")? 13:16,color: Colors.white,fontWeight: FontWeight.bold),),
                  ),
                )
              ],
            ),
          )
        ]));
  }
}
