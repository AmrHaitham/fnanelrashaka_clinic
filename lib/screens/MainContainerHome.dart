import 'dart:async';

import 'package:fanan_elrashaka_clinic/helper/dialogs.dart';
import 'package:fanan_elrashaka_clinic/screens/MainScreen.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../Constants.dart';
class MainContainerHome extends StatefulWidget {
  final String title;
  final Widget child;
  final bool backIcon;
  final Color patternColor;
  final smallTitle;
   MainContainerHome({Key? key,required this.title,required this.child,required this.backIcon,required this.patternColor, this.smallTitle}) : super(key: key);

  @override
  State<MainContainerHome> createState() => _MainContainerHomeState();
}

class _MainContainerHomeState extends State<MainContainerHome> {
  Dialogs _dialogs = Dialogs();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(minutes: 5), () {
      _dialogs.alterToHomeDialogBuilder(context, LocaleKeys.session_ended.tr());
    });
  }
  @override
  Widget build(BuildContext context) {
    bool _smallTitle = widget.smallTitle?? false;
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image:const AssetImage("assets/pattern.png"),
                colorFilter: ColorFilter.mode(Constants.secondColor.withOpacity(0.97), BlendMode.exclusion),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height*0.17,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: widget.backIcon,
                            child: InkWell(
                              onTap: ()
                              {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) =>
                                      MainScreen())
                              );
                                // _dialogs.okDialogBuilder(context, LocaleKeys.Done_booking.tr());
                              },
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
                              height:35,
                              child: Text("${widget.title}",style:(_smallTitle)? Constants.smallTitleText:Constants.titleText,)
                          )
                        ],
                      ),
                      Container(
                          margin:(context.locale.toString()=="en")?const EdgeInsets.only(right: 8,top: 5):const EdgeInsets.only(left: 8,top: 5),
                          width:80,
                          height:80,
                          child: Image.asset("assets/logo.png")
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:const BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
                      image: DecorationImage(
                        image:const AssetImage("assets/pattern.png"),
                        colorFilter: ColorFilter.mode(widget.patternColor.withOpacity(0.025), BlendMode.dstATop),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
