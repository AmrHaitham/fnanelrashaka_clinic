import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Network/Clinics.dart';
import 'package:fanan_elrashaka_clinic/providers/UserData.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_clinic/widgets/ClinicCard.dart';
import 'package:fanan_elrashaka_clinic/widgets/MainContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClinicBookingScreen extends StatelessWidget {
  Clinics _clinics = Clinics();
  @override
  Widget build(BuildContext context) {
    return MainContainer(
      title: LocaleKeys.Clinic_Booking.tr(),
      backIcon: true,
      patternColor: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: FutureBuilder(
            future: _clinics.getClinics(context.read<UserData>().token),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // error in data
                  print(snapshot.error.toString());
                  return Container();
                } else if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context,int index){
                        return ClinicCard(
                          id: snapshot.data[index]["id"],
                          clinicName:(context.locale.toString()=="en")? snapshot.data[index]["name_en"]:snapshot.data[index]["name_ar"],
                          subTitle:(context.locale.toString()=="en")? snapshot.data[index]["address_en"]:snapshot.data[index]["address_ar"],
                          location:snapshot.data[index]["location"],
                        );
                      }
                  );
                } else {
                  //no data
                  return Container();
                }
              } else {
                //error in connection
                return Container();
              }
            }),
      ),
    );
  }
}
