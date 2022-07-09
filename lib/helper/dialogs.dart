import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/screens/LandingPage.dart';
import 'package:fanan_elrashaka_clinic/screens/MainScreen.dart';
import 'package:fanan_elrashaka_clinic/screens/WelcomeScreen.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dialogs{

  void internetDialogBuilder(var context,String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title:  Text(LocaleKeys.Error.tr()),
            content: Text(error),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LandingPage())
                    );
                  }
                  , child: Text(LocaleKeys.retry.tr())
              )
            ],
          );
        }
    );
  }
  void logoutDialogBuilder(var context,String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title:  Text(LocaleKeys.Error.tr()),
            content: Text(error),
            actions: [
              TextButton(
                  onPressed: ()async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => WelcomeScreen())
                    );
                  }
                  , child: Text(LocaleKeys.Log_out.tr())
              )
            ],
          );
        }
    );
  }
   void alterDialogBuilder(var context,String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text(LocaleKeys.Error.tr()),
            content: Text(error),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    }
                  , child:  Text(LocaleKeys.Exit.tr())
              )
            ],
          );
        }
    );
  }
   void okDialogBuilder(var context,String ok) async{
     return showDialog(
         context: context,
         barrierDismissible: false,
         builder: (context){
           return AlertDialog(
             title:  Text(LocaleKeys.Success.tr()),
             content: Text(ok),
             actions: [
               TextButton(
                   onPressed: (){Navigator.pop(context);}
                   , child: Text(LocaleKeys.Exit.tr())
               )
             ],
           );
         }
     );
   }
  void alterSDialogBuilder(var context,String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text(LocaleKeys.Error.tr()),
            content: Text(error),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  }
                  , child:  Text(LocaleKeys.Exit.tr())
              )
            ],
          );
        }
    );
  }
  void alterToHomeDialogBuilder(var context,String error) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title: Text(LocaleKeys.Error.tr()),
            content: Text(error),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) =>MainScreen()));
                  }
                  , child:  Text(LocaleKeys.Exit.tr())
              )
            ],
          );
        }
    );
  }
  void okSDialogBuilder(var context,String ok) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            title:  Text(LocaleKeys.Success.tr()),
            content: Text(ok),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                    }
                  , child: Text(LocaleKeys.Exit.tr())
              )
            ],
          );
        }
    );
  }
}