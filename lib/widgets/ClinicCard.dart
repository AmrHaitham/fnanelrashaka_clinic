import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:fanan_elrashaka_clinic/screens/BookingTypeScreen.dart';
import 'package:flutter/material.dart';
import 'package:fanan_elrashaka_clinic/helper/lunch.dart';
class ClinicCard extends StatelessWidget {
  final String clinicName;
  final String subTitle ;
  final String location;
  final int id;
   ClinicCard({Key? key,required this.clinicName,required this.subTitle,required this.location,required this.id,}) : super(key: key);
  Launch _launch = new Launch();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) =>BookingTypeScreen(title: clinicName,id :id))
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0,right: 15,top: 8,bottom: 8),
        child: SizedBox(
          height: MediaQuery.of(context).size.height*0.14,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Constants.mainColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      margin:const EdgeInsets.only(left:5,right: 10,bottom: 20),
                      width: 80,
                      height: 80,
                      child: ClipOval(child: Image.asset("assets/clinic_icon.png")),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${clinicName}",style: Constants.clinicBookingTitleText,),
                          SizedBox(
                              width: MediaQuery.of(context).size.width*0.65,
                              child: Text("${subTitle}",style: Constants.smallTextClinicBookScreen,maxLines: 3,))
                        ],
                      ),
                    ),

                  ],
                ),
              ),
              Align(
                alignment: (context.locale.toString()=="en")?Alignment.bottomRight:Alignment.bottomLeft,
                child: InkWell(
                  onTap: (){
                    _launch.launchLink(context, location);
                  },
                  child: Container(
                    width: 43,
                    height: 35,
                    decoration: BoxDecoration(
                        borderRadius:(context.locale.toString()=="en")? const BorderRadius.only(topLeft: Radius.circular(15),bottomRight: Radius.circular(15)):const BorderRadius.only(bottomLeft: Radius.circular(15),topRight: Radius.circular(15)),
                        color: Constants.secondColor
                    ),
                    child: Image.asset("assets/location.png",color: Constants.mainColor,scale: 11,),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
