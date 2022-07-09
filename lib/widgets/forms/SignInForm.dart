import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Network/ApisEndPoint.dart';
import 'package:fanan_elrashaka_clinic/helper/dialogs.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:fanan_elrashaka_clinic/Network/UserAuth.dart';
import 'package:fanan_elrashaka_clinic/helper/keyboard.dart';
import 'package:fanan_elrashaka_clinic/providers/UserData.dart';
import 'package:fanan_elrashaka_clinic/screens/MainScreen.dart';
import 'package:fanan_elrashaka_clinic/screens/RegisterScreen.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_clinic/widgets/DefaultButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FormError.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final Dialogs _dialogs = Dialogs();
  Auth auth = Auth();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  final List<String?> errors = [];
  bool _isLoading = false;

  void addError({String? error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(LocaleKeys.welcomeBack.tr(),style: TextStyle(
                    fontSize: 25.0,
                    color: Constants.theardColor,
                    fontWeight: FontWeight.bold
                ),),
                Text(
                  LocaleKeys.hello_there_sign_in_to_continue.tr(),
                  style: Constants.smallText,
                ),
                const SizedBox(height: 30),
                buildEmailFormField(),
                const SizedBox(height: 20),
                buildPasswordFormField(),
                const SizedBox(height: 10),
                FormError(errors: errors),
                const SizedBox(height: 10),
                DefaultButton(
                  text: LocaleKeys.sign_in.tr(),
                  loading: _isLoading,
                  press: () async{
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      KeyboardUtil.hideKeyboard(context);
                      setState(() {
                        _isLoading = true;
                      });
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      var response = await auth.login(email, password);
                      String data= await response.body;
                      print(data);
                      if (response.statusCode == 200) {
                        await prefs.setBool('logedIn', true);
                        await prefs.setString('email', email!);
                        await prefs.setString('token', jsonDecode(data)['token']);
                        setState(() {
                          _isLoading = false;
                        });
                        context.read<UserData>().setUserEmail(email!);
                        context.read<UserData>().setUserToken(jsonDecode(data)['token']);
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => MainScreen())
                        );
                      }else {
                        print(jsonDecode(data)['error']);
                        if(jsonDecode(data)['error']=="701"){
                          _dialogs.alterDialogBuilder(context, LocaleKeys.Wrong_email_or_password.tr());
                        }else if(response.statusCode >= 500 && response.statusCode <600){
                          _dialogs.alterDialogBuilder(context, LocaleKeys.We_are_in_maintenance_now_please_try_again_later.tr());
                        }else{
                          _dialogs.alterDialogBuilder(context, LocaleKeys.Error_while_sign_up.tr());
                        }
                      }
                      setState(() {
                        _isLoading = false;
                        errors.clear();
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(LocaleKeys.Dont_Have_an_Account.tr(),style: Constants.smallText,),
                GestureDetector(
                  child: Text(LocaleKeys.sign_up.tr(),style: Constants.secondSmallText,),
                  onTap: (){
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => RegisterScreen())
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: Constants.kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: Constants.kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: Constants.kPassNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: Constants.kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
          labelText: LocaleKeys.Password.tr(),
          hintText: LocaleKeys.Enter_your_password.tr(),
          // If  you are using latest version of flutter then lable text and hint text shown like this
          // if you r using flutter less then 1.20.* then maybe this is not working properly
          floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: Constants.kEmailNullError);
        } else if (Constants.emailValidatorRegExp.hasMatch(value)) {
          removeError(error: Constants.kInvalidEmailError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: Constants.kEmailNullError);
          return "";
        } else if (!Constants.emailValidatorRegExp.hasMatch(value)) {
          addError(error: Constants.kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: LocaleKeys.Email.tr(),
        hintText: LocaleKeys.Enter_your_email.tr(),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
