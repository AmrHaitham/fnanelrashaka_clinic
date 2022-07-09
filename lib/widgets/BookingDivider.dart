import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
class BookingDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20,bottom: 20),
      child: Row(
        children:  [
          const Expanded(child: Divider(height: 5,color: Colors.black,thickness: 0.8,)),
          Padding(
            padding: const EdgeInsets.only(left: 5,right: 5),
            child: Text(LocaleKeys.Old_Bookings.tr(),style:Constants.theardSmallText,),
          ),
          const Expanded(child: Divider(height: 5,color: Colors.black,thickness: 0.8,))
        ],
      ),
    );
  }
}
