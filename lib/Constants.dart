import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';

class Constants {

  static Color mainColor = const Color(0xffffffff);
  static Color secondColor = const Color(0xff2daae2);
  static Color theardColor = const Color(0xff002250);

  static Color smallTextColor =const Color(0xff89909f);

  // Form Error
  static final RegExp emailValidatorRegExp =
  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static  String kEmailNullError = LocaleKeys.Please_Enter_your_email.tr();
  static  String kInvalidEmailError = LocaleKeys.PleaseEnterValidEmail.tr();
  static  String kPassNullError = LocaleKeys.Please_Enter_your_password.tr();
  static  String kShortPassError = LocaleKeys.Password_is_too_short.tr();
  static  String kMatchPassError = LocaleKeys.Passwords_dont_match.tr();
  static  String kNamelNullError = LocaleKeys.Please_Enter_your_name.tr();
  static  String kLastNamelNullError = LocaleKeys.Please_Enter_your_lastname.tr();
  static  String kPhoneNumberNullError = LocaleKeys.Please_Enter_your_phone_number.tr();
  static  String kAddressNullError = LocaleKeys.Please_Enter_your_address.tr();
  static  String kAGenderNullError = LocaleKeys.Please_Select_your_Gender.tr();
  static  String kABirthdayNullError = LocaleKeys.Please_Select_your_Birthday.tr();
  static  String kAPromoNullError = LocaleKeys.Please_Input_Promo_code.tr();
  static  String kAPriceNullError = LocaleKeys.Input_your_package_price.tr();
  static  String kADescriptionNullError = LocaleKeys.Input_your_package_description.tr();


  static TextStyle headingText = TextStyle(
      fontSize: 25.0,
      color: mainColor,
      fontWeight: FontWeight.bold,
  );
  static TextStyle aboutSmallText = TextStyle(fontSize: 15,fontWeight: FontWeight.normal,color: Constants.smallTextColor);

  static TextStyle titleText = TextStyle(
      fontSize: 25.0,
      color: mainColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle titleTheardText = TextStyle(
      fontSize: 25.0,
      color: theardColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle smallTitleText = TextStyle(
      fontSize: 17.0,
      color: mainColor,
      fontWeight: FontWeight.bold
  );

  static TextStyle clinicBookingTitleText = TextStyle(
      fontSize: 23.0,
      color: secondColor,
  );
  static TextStyle regularText = TextStyle(
      fontSize: 17.0,
      color: theardColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle theardSmallText = TextStyle(
      fontSize: 16.0,
      color: theardColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle theardMediamText = TextStyle(
      fontSize: 20.0,
      color: theardColor,
      fontWeight: FontWeight.normal
  );
  static TextStyle theardSmallTextPay = TextStyle(
      fontSize: 13.0,
      color: mainColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle secondTheardSmallTextPay = TextStyle(
      fontSize: 13.0,
      color: theardColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle secondSmallText = TextStyle(
      fontSize: 13.0,
      color: secondColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle smallText = TextStyle(
      fontSize: 13.0,
      color: smallTextColor,
      fontWeight: FontWeight.bold
  );

  static TextStyle theardSmallTextBookScreen = TextStyle(
      fontSize: 16.0,
      color: theardColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle smallTextBookScreen = TextStyle(
      fontSize: 12.0,
      color: smallTextColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle secondsmallTextBookScreen = TextStyle(
      fontSize: 14.0,
      color: smallTextColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle smallTextPayScreen = TextStyle(
      fontSize: 12.0,
      color: theardColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle smallTextClinicBookScreen = TextStyle(
      fontSize: 12.0,
      color: smallTextColor,
      fontWeight: FontWeight.normal
  );
  static TextStyle PriceSmallText = TextStyle(
      fontSize: 16.0,
      color: secondColor,
      fontWeight: FontWeight.bold
  );
  static TextStyle PriceLineSmallText = TextStyle(
      fontSize: 15.0,
      color: smallTextColor,
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.lineThrough
  );
}