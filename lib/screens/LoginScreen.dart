import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:fanan_elrashaka_clinic/widgets/MainContainer.dart';
import 'package:fanan_elrashaka_clinic/widgets/forms/SignInForm.dart';
import 'package:flutter/material.dart';

import '../translations/locale_keys.g.dart';
class LoginScreen extends StatefulWidget {
  final String title =LocaleKeys.sign_in.tr();
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
        patternColor: Constants.mainColor,
        backIcon: true,
        title: widget.title,
        child: Padding(
          padding: const EdgeInsets.only(left: 25,right: 25),
          child: SignForm(),
        )
    );
  }
}