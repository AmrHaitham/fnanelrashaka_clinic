import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Network/Bookings.dart';
import 'package:fanan_elrashaka_clinic/providers/UserData.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_clinic/widgets/BookingDivider.dart';
import 'package:fanan_elrashaka_clinic/widgets/BooksCard.dart';
import 'package:fanan_elrashaka_clinic/widgets/MainContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class BookingsScreen extends StatefulWidget {
  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  Bookings _bookings = Bookings();
  String today ="";
  DateTime date = DateTime.now();
  int? dIndex;
  setIndex()async{
   var response = await _bookings.getBookings(context.read<UserData>().token,context.read<UserData>().email);
   for(int i = 0;i<response.length;i++){
     if(DateTime.parse(response[i]["date"]).compareTo(date)<0){
       setState(() {
         dIndex = i;
       });
       break;
     }
   }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
    DateTime now = new DateTime.now();
    date = new DateTime(now.year, now.month, now.day);
    today =date.toString().replaceAll("00:00:00.000", "");
    setIndex();
  }
  @override
  Widget build(BuildContext context) {
    return MainContainer(
        patternColor: Colors.grey,
        backIcon: false,
        title: LocaleKeys.My_Bookings.tr(),
        child: Container(
          padding: const EdgeInsets.only(left: 10.0,right: 10,top: 20),
          child: FutureBuilder(
            future: _bookings.getBookings(context.read<UserData>().token,context.read<UserData>().email),
            builder: (BuildContext context,AsyncSnapshot<dynamic> snapshot){
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return const Text('');
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context,int index){
                        return Column(
                          children: [
                            if(dIndex == index)
                            BookingDivider(),
                            BooksCard(
                                    day: DateFormat.EEEE(context.locale.toString()).format(DateTime.parse(snapshot.data[index]["date"])),
                                    time:DateFormat.jm(context.locale.toString()).format(DateFormat("hh:mm:ss").parse(snapshot.data[index]["time"])),
                                    date:DateFormat.yMd(context.locale.toString()).format(DateTime.parse(snapshot.data[index]["date"])),
                                    type: (context.locale.toString()=="en")?snapshot.data[index]["clinic_service_en"]:snapshot.data[index]["clinic_service_ar"]??" ",
                                    doctor: LocaleKeys.dr.tr(),
                                    location: snapshot.data[index]["location"]??" "
                            ),
                          ],
                        );
                    },
                  );
                } else {
                  print("Empty data");
                  return const Text('');
                }
              }else {
                print('State: ${snapshot.connectionState}');
                return const Text('');
              }
            },
          ),
        )
    );
  }
}
