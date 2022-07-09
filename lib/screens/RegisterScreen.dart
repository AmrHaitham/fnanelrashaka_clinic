import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_clinic/widgets/MainContainer.dart';
import 'package:fanan_elrashaka_clinic/widgets/forms/SignUpForm.dart';
import 'package:flutter/material.dart';
class RegisterScreen extends StatefulWidget {
  final String title =LocaleKeys.sign_up.tr();
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return MainContainer(
        patternColor: Constants.mainColor,
        backIcon: true,
        title: widget.title,
        child: Padding(
          padding: const EdgeInsets.only(left: 25,right: 25),
          child: SignUpForm(),
        )
    );
  }
}
