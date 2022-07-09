import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Network/Clinics.dart';
import 'package:fanan_elrashaka_clinic/providers/UserData.dart';
import 'package:fanan_elrashaka_clinic/screens/CalenderBookScreen.dart';
import 'package:fanan_elrashaka_clinic/widgets/BookingTypeCard.dart';
import 'package:fanan_elrashaka_clinic/widgets/ItemCard.dart';
import 'package:fanan_elrashaka_clinic/widgets/MainContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class BookingTypeScreen extends StatelessWidget {
  final String title;
  final int id;
  BookingTypeScreen({Key? key,required this.title,required this.id}) : super(key: key);
  Clinics _clinics = Clinics();
  @override
  Widget build(BuildContext context) {
    return MainContainer(
        smallTitle: true,
        title: "${title}",
        child:FutureBuilder(
            future: _clinics.getClinicsServices(context.read<UserData>().token, id),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  // error in data
                  print(snapshot.error.toString());
                  return  Container();
                } else if (snapshot.hasData) {
                  print(snapshot.data);
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context,int index){
                        return Padding(
                          padding: const EdgeInsets.only(top:40,left: 10,right: 10),
                          child: Column(
                            children: [
                              BookingTypeCard(
                                  isBig: true,
                                  heding: (context.locale.toString()=="en")?snapshot.data[index]["name_en"]:snapshot.data[index]["name_ar"],
                                  image: "${snapshot.data[index]["image"]}",
                                  open: (){
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) =>CalenderBookScreen(
                                          book_by_time_slots:snapshot.data[index]["book_by_time_slots"],
                                            id :snapshot.data[index]["id"],
                                            title: title,
                                            isNewBook: (snapshot.data[index]["name_en"]=="New Patient")?true:false,
                                            fee:snapshot.data[index]["fee"],
                                          ),
                                        )
                                    );
                                  }
                              ),
                            ],
                          ),
                        );
                      }
                  );
                }else{
                  //no data
                  return Container();
                }
              }else{
                //error in connection
                return Container();
              }
            }
        ),
        backIcon: true,
        patternColor: Colors.grey
    );
  }
}
