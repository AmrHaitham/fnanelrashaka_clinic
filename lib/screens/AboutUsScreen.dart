import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:fanan_elrashaka_clinic/Network/Clinics.dart';
import 'package:fanan_elrashaka_clinic/providers/UserData.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_clinic/widgets/ClinicCard.dart';
import 'package:fanan_elrashaka_clinic/widgets/MainContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../helper/lunch.dart';
class AboutUs extends StatelessWidget {
  Clinics _clinics = Clinics();
  Launch _launch = new Launch();
  @override
  Widget build(BuildContext context) {
    return MainContainer(
        title: LocaleKeys.About_Us.tr(),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0,right: 15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                    margin:const EdgeInsets.only(right: 8,top: 30,bottom: 10),
                    width:200,
                    height:200,
                    child: Image.asset("assets/dr_mohamed.png")
                ),
                Text(LocaleKeys.who.tr(),style:TextStyle(color: Constants.theardColor,fontSize:(context.locale.toString()=="en")? 21:25,fontWeight: FontWeight.bold),),
                const SizedBox(height: 10,),
                Text(LocaleKeys.p1.tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Constants.smallTextColor),maxLines: 10,),
                const SizedBox(height: 10,),
                Text( LocaleKeys.p2.tr(),style: Constants.aboutSmallText,textAlign: TextAlign.justify,maxLines: 10,),
                const SizedBox(height: 10,),
                if (context.locale.toString()=="en")
                Column(
                  children: [
                    Text("Dietitian -Cairo university",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    Text("DPT cairo university",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    Text("master of clinical nutrition cairo university master",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    Text("Clinical nutrition diploma Cairo university",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    Text("Obesity management-physiotherapy-Mesotherapy",maxLines: 1,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    Text("-Mesotherapy",maxLines: 1,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    Text("Member of EMASO",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    Text("Member of ESPEN-EASO",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    Text("Member of ASPEN",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    Text("Member of EASHTN",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    Text("member of Arab Society of Therapeutic Nutrition",maxLines: 1,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    Text("and Complementary Medicine- ASTNCM",maxLines: 1,style: Constants.aboutSmallText),
                    Text("Member of OMTA",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                  ],
                ),
                if (context.locale.toString()=="ar")
                  Column(
                    children: [
                      Text("ماجستير التغذية العلاجيه جامعة القاهرة",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                      Text("دبلومة التغذيه العلاجيه جامعه القاهره",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                      Text("دبلومة التغذيه العلاجيه جامعه عؤن شمس",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                      Text("ماجستير الاداره جامعه كامبريدج – بريطانيا",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                      Text("دبلوم الاداره الجامعه الامريكيه بالقاهره",maxLines: 1,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                      Text("استشاري العلاج طبيعي وعلاج السمنه والنحافه",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                      Text("عضو الرابطة الأوروبية لدراسة السمنة (EASO)",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                      Text("عضو الجمعية الطبية المصرية لدراسة السمنة (EMASO)",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                      Text("ضو جمعية أمريكا الشمالية لدراسة السمنة (NAASO)",maxLines: 10,style: Constants.aboutSmallText,textAlign: TextAlign.center,),
                    ],
                  ),
                Container(
                    margin:const EdgeInsets.only(right: 8,bottom: 10),
                    width:200,
                    height:200,
                    child: Image.asset("assets/clinic_locations.png")
                ),
                Text(LocaleKeys.Clinics_location.tr(),style: TextStyle(color: Constants.theardColor,fontSize: 20,fontWeight: FontWeight.bold),),
                Text(LocaleKeys.Click_on_clinic_to_view_the_address_on_map.tr(),maxLines: 2,style: Constants.aboutSmallText),
                const SizedBox(height: 20,),
                FutureBuilder(
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
                          print(snapshot.data);
                         return SizedBox(
                           width:double.infinity,
                           height: MediaQuery.of(context).size.height*0.35,
                           child: GridView.count(
                             crossAxisCount: 3,
                             children: [
                               for(int i = 0 ; i<snapshot.data.length;i++)
                                 Column(
                                   children: [
                                     GestureDetector(
                                       onTap: (){
                                         _launch.launchLink(context, snapshot.data[i]["location"]);
                                       },
                                       child: Container(
                                         margin: EdgeInsets.all(10),
                                         width: 70,
                                         height: 50,
                                         child: Image.asset("assets/clinic.png"),
                                       ),
                                     ),
                                     Text((context.locale.toString()=="en")? snapshot.data[i]["name_en"]:snapshot.data[i]["name_ar"],style: Constants.aboutSmallText,),
                                   ],
                                 ),
                             ],
                           )
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
                // Column(
                //   children: [
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //       children: [
                //         Column(
                //           children: [
                //             GestureDetector(
                //               onTap: (){
                //                 _launch.launchLink(context, "https://maps.app.goo.gl/GM9GQBj6ug5v6TSS8");
                //               },
                //               child: Container(
                //                 margin: EdgeInsets.all(10),
                //                 width: 70,
                //                 height: 50,
                //                 child: Image.asset("assets/clinic.png"),
                //               ),
                //             ),
                //             Text(LocaleKeys.October.tr(),style: Constants.aboutSmallText,),
                //           ],
                //         ),
                //         GestureDetector(
                //           onTap: (){
                //             _launch.launchLink(context, "https://maps.app.goo.gl/gfBA6pM7HU8MkPVr7");
                //           },
                //           child: Column(
                //             children: [
                //               Container(
                //                 margin: EdgeInsets.all(10),
                //                 width: 70,
                //                 height: 50,
                //                 child: Image.asset("assets/clinic.png"),
                //               ),
                //               Text(LocaleKeys.F5thsettlement.tr(),style: Constants.aboutSmallText,),
                //             ],
                //           ),
                //         ),
                //         GestureDetector(
                //           onTap: (){
                //             _launch.launchLink(context, "https://maps.app.goo.gl/GPCAWMHhyFMZNeMf7");
                //           },
                //           child: Column(
                //             children: [
                //               Container(
                //                 margin: EdgeInsets.all(10),
                //                 width: 70,
                //                 height: 50,
                //                 child: Image.asset("assets/clinic.png"),
                //               ),
                //               Text(LocaleKeys.Maadi.tr(),style: Constants.aboutSmallText,),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //     SizedBox(height: 10,),
                //     Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         GestureDetector(
                //           onTap: (){
                //             _launch.launchLink(context, "https://maps.app.goo.gl/BQDyjRsETo6C6TCu6");
                //           },
                //           child: Column(
                //             children: [
                //               Container(
                //                 margin: EdgeInsets.all(10),
                //                 width: 70,
                //                 height: 50,
                //                 child: Image.asset("assets/clinic.png"),
                //               ),
                //               Text(LocaleKeys.Heliopolis.tr(),style: Constants.aboutSmallText,),
                //             ],
                //           ),
                //         ),
                //         GestureDetector(
                //           onTap: (){
                //             _launch.launchLink(context, "");
                //           },
                //           child: Column(
                //             children: [
                //               Container(
                //                 margin: EdgeInsets.only(left: 22,right: 10,top: 10,bottom: 10),
                //                 width: 50,
                //                 height: 50,
                //                 child: Image.asset("assets/clinic.png"),
                //               ),
                //               Container(
                //                   margin: EdgeInsets.only(left: 11),
                //                   child: Text(LocaleKeys.Alexandria.tr(),style: Constants.aboutSmallText,)
                //               ),
                //             ],
                //           ),
                //         ),
                //       ],
                //     ),
                //       ],
                //     ),
                Container(
                    margin:const EdgeInsets.only(right: 8,bottom: 10),
                    width:200,
                    height:200,
                    child: Image.asset("assets/social_media.png")
                ),
                Text(LocaleKeys.Social_Media.tr(),style:TextStyle(color: Constants.theardColor,fontSize: 20,fontWeight: FontWeight.bold),),
                const SizedBox(height: 20,),
                Wrap(
                  children: [
                    GestureDetector(
                      onTap: (){
                        _launch.launchLink(context, "https://www.facebook.com/fananelrashaka/");
                      },
                      child: Container(
                        margin: EdgeInsets.all(1),
                        width: 50,
                        height: 50,
                        child: Image.asset("assets/facebook.png"),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _launch.launchLink(context, "https://www.instagram.com/fananelrashaka/");
                      },
                      child: Container(
                        margin: EdgeInsets.all(1),
                        width: 50,
                        height: 50,
                        child: Image.asset("assets/instgrame.png"),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _launch.launchLink(context, "http://tiktok.com/@fananelrashaka");
                      },
                      child: Container(
                        margin: EdgeInsets.all(1),
                        width: 50,
                        height: 50,
                        child: Image.asset("assets/ticktok.png"),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _launch.launchLink(context, "https://fananelrashaka.net/");
                      },
                      child: Container(
                        margin: EdgeInsets.all(1),
                        width: 50,
                        height: 50,
                        child: Image.asset("assets/website.png"),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _launch.launchLink(context, "http://wa.me/+20 120 001 0344");
                      },
                      child: Container(
                        margin: EdgeInsets.all(1),
                        width: 50,
                        height: 50,
                        child: Image.asset("assets/whatsapp.png"),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        _launch.launchLink(context, "https://youtube.com/channel/UCUQV0neYsj5njo8hpe8xreA");
                      },
                        child: Container(
                        margin: EdgeInsets.all(1),
                        width: 50,
                        height: 50,
                        child: Image.asset("assets/youtube.png"),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50,),
              ],
            ),
          ),
        ),
        backIcon: true,
        patternColor: Colors.grey
    );
  }
}
