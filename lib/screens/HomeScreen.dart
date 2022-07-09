import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/helper/lunch.dart';
import 'package:fanan_elrashaka_clinic/screens/AboutUsScreen.dart';
import 'package:fanan_elrashaka_clinic/screens/BookingTypeScreen.dart';
import 'package:fanan_elrashaka_clinic/screens/CalenderBookScreen.dart';
import 'package:fanan_elrashaka_clinic/screens/ClinicBookingScreen.dart';
import 'package:fanan_elrashaka_clinic/screens/PackgesScreen.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_clinic/widgets/ItemCard.dart';
import 'package:flutter/material.dart';

import '../PaymentConstants.dart';


class HomeScreen extends StatelessWidget {
  Launch _launch = new Launch();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image:const AssetImage("assets/pattern.png"),
            colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.03), BlendMode.dstATop),
            fit: BoxFit.cover,
          ),
        ),
        child:Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      margin:const EdgeInsets.only(top: 10),
                      width:100,
                      height:100,
                      child: Image.asset("assets/logo.png")
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      margin:const EdgeInsets.only(top: 10),
                      width:MediaQuery.of(context).size.width*0.9,
                      height:MediaQuery.of(context).size.height*0.2,
                      child: InkWell(
                        child: ClipRRect(child: Image.asset((context.locale.toString()=="en")?"assets/dr_mohamed_app_board.png":"assets/dr_mohamed_app_board_ar.png",fit: BoxFit.fill),),
                        onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) =>AboutUs())
                          );
                        },
                      )
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: GridView(
                            padding: const EdgeInsets.only(left: 18,right: 18,top: 12,bottom: 10),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisExtent: 150,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 15,
                            ),
                            children: [
                              ItemCard(
                                heding: LocaleKeys.Clinic_Booking.tr(),
                                image: "assets/clinic_booking.png",
                                open: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>ClinicBookingScreen())
                                  );
                                },
                              ),
                              ItemCard(
                                heding: LocaleKeys.Online_Booking.tr(),
                                image: "assets/online_booking.png",
                                open: (){
                                  // Navigator.of(context).push(
                                  //     MaterialPageRoute(builder: (context) =>CalenderBookScreen(title: LocaleKeys.Online_Booking.tr(), isNewBook: true,fee: 500,id:1))
                                  // );
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>BookingTypeScreen(title: LocaleKeys.Online_Booking.tr(),id :onlineBookingID))
                                  );
                                },
                              ),
                              ItemCard(
                                heding: LocaleKeys.About_Us.tr(),
                                image: "assets/about.png",
                                open: (){
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>AboutUs())
                                  );
                                },
                              ),
                              ItemCard(
                                heding: LocaleKeys.Packges.tr(),
                                image: "assets/clinic_booking.png",
                                open: ()async{
                                  //+20 120 001 0344
                                  // _launch.launchLink(context, "http://wa.me/+20 120 001 0344");
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) =>PackgesScreen())
                                  );
                                },
                              ),ItemCard(
                                heding: LocaleKeys.Chatting_soon.tr(),
                                image: "assets/chat.png",
                                open: (){},
                              ),
                              ItemCard(
                                heding: LocaleKeys.Articles_soon.tr(),
                                image: "assets/artical2.png",
                                open: (){},
                              ),
                            ],
                          ),
                      ),
                    ),
              ],
        ),
      ),
    );
  }
}
