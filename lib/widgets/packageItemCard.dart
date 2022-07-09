import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import '../Constants.dart';

class PackageItemCard extends StatelessWidget {
  final String heding;
  final String image ;
  final  open;
  final isBig;
  final price;
  final oldPrice;
  final bool isCustom;

  const PackageItemCard({Key? key,required this.heding,required this.image,required this.open, this.isBig, this.price, this.oldPrice,required this.isCustom,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool _isBig = isBig?? false;
    return InkWell(
      onTap: open,
      child: Container(
        // height: 320,
        padding:const EdgeInsets.only(left:15,right:15,top: 5,bottom: 10),
        margin: const EdgeInsets.only(left:10,right:10),
        decoration: BoxDecoration(
          color: Constants.mainColor,
          borderRadius:const BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0,
              blurRadius: 10,
              offset: Offset(0, 4), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: (_isBig)?220:130,
              height: (_isBig)?160:100,
              padding:const EdgeInsets.all(3),
              child: Image.network("https://site.fananelrashaka.net${image}",),
            ),
            FittedBox(child: Text("${heding}",style: Constants.regularText,)),
            if(isCustom == false)
            Visibility(
                visible:(price==null)? false:true,
                child: Text("${price}",style: Constants.PriceSmallText,)
            ),
            if(isCustom == false)
            Visibility(
                visible:(oldPrice==null)? false:true,
                child: Text("${oldPrice}",style: Constants.PriceLineSmallText,)
            ),
            if(isCustom == true)
              FittedBox(
                  child: Text(LocaleKeys.Enter_Your_Price.tr(),style: Constants.PriceSmallText,)
              )
          ],
        ),
      ),
    );
  }
}
