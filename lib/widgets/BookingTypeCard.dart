import 'package:flutter/material.dart';
import '../Constants.dart';

class BookingTypeCard extends StatelessWidget {
  final String heding;
  final String image ;
  final  open;
  final isBig;

  const BookingTypeCard({Key? key,required this.heding,required this.image,required this.open, this.isBig,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool _isBig = isBig?? false;
    return InkWell(
      onTap: open,
      child: Container(
        height: 220,
        padding:const EdgeInsets.only(top: 5,bottom: 10),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: (_isBig)?220:130,
              height: (_isBig)?160:100,
              padding:const EdgeInsets.all(3),
              child: (image=="null")?Image.asset("assets/follow_up2.png",):Image.network("https://site.fananelrashaka.net${image}"),
            ),
            Text("${heding}",style: Constants.regularText,),
          ],
        ),
      ),
    );
  }
}
