import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:fanan_elrashaka_clinic/Network/Clinics.dart';
import 'package:fanan_elrashaka_clinic/helper/dialogs.dart';
import 'package:fanan_elrashaka_clinic/providers/SelectedIndex.dart';
import 'package:fanan_elrashaka_clinic/screens/ChosePayment.dart';
import 'package:fanan_elrashaka_clinic/screens/TimeSlotsScreen.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_clinic/widgets/CalenderItem.dart';
import 'package:fanan_elrashaka_clinic/widgets/DefaultButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/UserData.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalenderBookScreen extends StatefulWidget {
  final String title;
  final bool isNewBook;
  final double fee;
  final int id;
  final bool book_by_time_slots;
  CalenderBookScreen(
      {Key? key,
      required this.title,
      required this.isNewBook,
      required this.fee,
      required this.id,required this.book_by_time_slots})
      : super(key: key);

  @override
  State<CalenderBookScreen> createState() => _CalenderBookScreenState();
}

class _CalenderBookScreenState extends State<CalenderBookScreen> {
  Clinics _clinics = Clinics();
  int? selctedIndex;
  Dialogs _dialogs = Dialogs();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/pattern.png"),
              colorFilter: ColorFilter.mode(
                  Constants.secondColor.withOpacity(0.97), BlendMode.exclusion),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: true,
                                  child: InkWell(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                        margin:(context.locale.toString()=="en")?const EdgeInsets.only(left: 30,top: 20):const EdgeInsets.only(right: 30,top: 20),
                                        width:29,
                                        height:29,
                                        child: Transform.scale(
                                            scaleX: (context.locale.toString()=="en")?1:-1,
                                            child: Image.asset("assets/back_arrow.png")
                                        )
                                    ),
                                  ),
                                ),
                                Container(
                                    margin:(context.locale.toString()=="en")?const EdgeInsets.only(left: 30,top: 20):const EdgeInsets.only(right: 30,top: 20),
                                    height: 29,
                                    child: Text("${widget.title}",
                                        style: Constants.smallTitleText)),
                              ],
                            ),
                          ],
                        ),
                        Container(
                            margin:(context.locale.toString()=="en")?const EdgeInsets.only(right: 8,top: 5):const EdgeInsets.only(left: 8,top: 5),
                            width: 100,
                            height: 100,
                            child: Image.asset("assets/logo.png")),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12)),
                        image: DecorationImage(
                          image: const AssetImage("assets/pattern.png"),
                          colorFilter: ColorFilter.mode(
                              Colors.grey.withOpacity(0.08), BlendMode.dstATop),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, top: 20, right: 15),
                        child: FutureBuilder(
                                  future: _clinics.getClinicsCalendar(context.read<UserData>().token, widget.id, context.read<UserData>().email),
                                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.connectionState == ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        // error in data
                                        // print(snapshot.error.toString());
                                        return  Container();
                                      } else if (snapshot.hasData) {
                                        print(snapshot.data);
                                        if(snapshot.data.toString()!="{error: 708}")
                                        return CalendarRow(snapshot.data, title: widget.title, fee: widget.fee, id: widget.id,isNewBooking: widget.isNewBook,book_by_time_slots:widget.book_by_time_slots);
                                        else return Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 80,
                                              height: 80,
                                              child: Image.asset("assets/fully_booked.png"),
                                            ),
                                            Text(LocaleKeys.Clinic_fully_booked.tr(),style: Constants.clinicBookingTitleText,),
                                          ],
                                        );
                                      }else{
                                        //no data
                                        return Center(child:Text("No data"));
                                      }
                                    }else{
                                      //error in connection
                                      return Container();
                                    }
                                  }
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                    margin:
                        const EdgeInsets.only(right: 8, top: 5, bottom: 150),
                    width: 320,
                    height: 300,
                    child: Image.asset("assets/dr_mohamed.png")),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CalendarRow extends StatefulWidget {
  final bool book_by_time_slots;
  final  appointments;
  final title, fee,id,isNewBooking;
  const CalendarRow(this.appointments, {Key? key,required this.title,required this.fee,required this.id,required this.isNewBooking,required this.book_by_time_slots }) : super(key: key);

  @override
  _CalendarRowState createState() => _CalendarRowState();
}
class _CalendarRowState extends State<CalendarRow> {
  Dialogs _dialogs = Dialogs();
  int? selectedIndex;

  void onChange(int index){
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(LocaleKeys.Book_Appoiment.tr(),style: Constants.theardMediamText,),
        SizedBox(height: 10,),
        SizedBox(
          width: double.infinity,
          height: 110,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.appointments.length-1,
              itemBuilder: (BuildContext context,int index){
                return CalendarItem(date: widget.appointments[index]['date'], onChange: ()=> onChange(index), isSelected: selectedIndex == index,);
              }
          ),
        ),
        Visibility(
          visible: (widget.appointments.length>=1),
          child: Padding(
            padding: const EdgeInsets.only(top:15.0),
            child: DefaultButton(
              text: (widget.book_by_time_slots==true)?LocaleKeys.Select_time_of_appoiment.tr():LocaleKeys.Book_Appoiment.tr(),
              press: (){
                if(selectedIndex==null){
                  _dialogs.alterDialogBuilder(context, LocaleKeys.Choose_day_of_book.tr());
                }else{
                  print(widget.book_by_time_slots);
                  if(widget.book_by_time_slots==true){
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>TimeSlotsScreen(
                          title: widget.title,fee:widget.fee,
                          id:widget.id,
                          cashPay:widget.appointments[widget.appointments.length-1]["cash_pay"],
                          clinic_time_id:widget.appointments[selectedIndex!]["id"], isNewBook: widget.isNewBooking,
                        )
                        )
                    );
                  }else{
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) =>ChosePayment(
                          isPackage: false,
                          title: widget.title,fee:widget.fee,
                          id:widget.id,
                          cashPay:widget.appointments[widget.appointments.length-1]["cash_pay"],
                          clinic_time_id:widget.appointments[selectedIndex!]["id"],
                          description: "",
                          time_slot_id: "",
                        )
                        )
                    );
                  }
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
