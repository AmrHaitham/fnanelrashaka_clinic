import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:fanan_elrashaka_clinic/Network/Bookings.dart';
import 'package:fanan_elrashaka_clinic/helper/dialogs.dart';
import 'package:fanan_elrashaka_clinic/modules/payment/cubit/Paymob.dart';
import 'package:fanan_elrashaka_clinic/modules/payment/cubit/PaymobMobile.dart';
import 'package:fanan_elrashaka_clinic/modules/payment/cubit/cubit.dart';
import 'package:fanan_elrashaka_clinic/modules/payment/cubit/states.dart';
import 'package:fanan_elrashaka_clinic/screens/MainScreen.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_clinic/widgets/DefaultButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../PaymentConstants.dart';
import '../providers/UserData.dart';
class ChosePayment extends StatefulWidget {
  final String title ;
  final double fee;
  final int id;
  final bool cashPay;
  final int clinic_time_id;
  final bool isPackage;
  final String description;
  final String time_slot_id;
   ChosePayment({Key? key,required this.title,required this.fee,required this.id,required this.cashPay,required this.clinic_time_id,required this.isPackage,required this.description,required this.time_slot_id}) : super(key: key);

  @override
  State<ChosePayment> createState() => _ChosePaymentState();
}

class _ChosePaymentState extends State<ChosePayment> {
  bool _isloading=false;

  Dialogs _dialogs = Dialogs();

  final _formKey = GlobalKey<FormState>();

  final _walletFormKey = GlobalKey<FormState>();

  String? promo;

  double? promoValue;

  int _selectedIndex = 0;

  Bookings _bookings = Bookings();

  String? phoneNumber;


  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context)=>PaymentCubit(),
      child: BlocConsumer<PaymentCubit,PaymentStates>(
        listener: (context, state) async{
          if(state is PaymentRequestTokenSuccessState){
            print(widget.time_slot_id);
             var _response =await _bookings.holdTillPay(
                  context.read<UserData>().token,
                  PaymobOrderId,
                  context.read<UserData>().email,
                  "1",
                  (promoValue==null)?'':promo,
                  "${widget.clinic_time_id}",
                  "${widget.id}",
                  (widget.isPackage== true)?"1":"0",// 1: for its a package, 0: normal service not a package
                  widget.description,//description
                  widget.time_slot_id//using_time_slot
              );
              if(_response.statusCode == 200){
                print("done holding till Pay");
                setState(() {
                  _isloading = false;
                });
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Paymob())
                );
              }else{
                setState(() {
                  _isloading == false;
                });
                _dialogs.alterToHomeDialogBuilder(context, LocaleKeys.Time_is_already_booked.tr());
                print(jsonDecode(await _response.stream.bytesToString()));
                print("error in holding book");
              }

          }else if(state is PaymentRequestWalletTokenSuccessState){
            var _response =await _bookings.holdTillPay(
                context.read<UserData>().token,
                PaymobOrderId,
                context.read<UserData>().email,
                "4",
                (promoValue==null)?'':promo,
                "${widget.clinic_time_id}",
                "${widget.id}",
                (widget.isPackage== true)?"1":"0",// 1: for its a package, 0: normal service not a package
                widget.description,//description
                widget.time_slot_id//using_time_slot
            );
            if(_response.statusCode == 200){
              print("done holding till Pay");
              setState(() {
                _isloading = false;
              });
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PaymobMobile())
              );
            }else{
              setState(() {
                _isloading == false;
              });
              _dialogs.alterToHomeDialogBuilder(context, LocaleKeys.Time_is_already_booked.tr());
              print(jsonDecode(await _response.stream.bytesToString()));
              print("error in holding book");
            }
          }
        },
        builder: (context, state) {
         return Scaffold(
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
                child: Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height*0.54,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Visibility(
                                        visible: true,
                                        child: InkWell(
                                          onTap: ()=>Navigator.pop(context),
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
                                          height:29,
                                          child: Text("${widget.title}",style:Constants.smallTitleText)
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                  margin:(context.locale.toString()=="en")?const EdgeInsets.only(right: 8,top: 5):const EdgeInsets.only(left: 8,top: 5),
                                  width:100,
                                  height:100,
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
                                colorFilter: ColorFilter.mode(Colors.grey.withOpacity(0.08), BlendMode.dstATop),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Padding(
                              padding:const EdgeInsets.only(left: 15,right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            _selectedIndex = 0;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          width: 100,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: (_selectedIndex==0) ?Constants.theardColor:Constants.mainColor,
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
                                            children: [
                                              SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset("assets/credit_card.png",color:(_selectedIndex==0) ?Constants.mainColor:Constants.theardColor,)
                                              ),
                                              Text(LocaleKeys.Creadit_Card.tr(),style:(_selectedIndex==0) ? Constants.theardSmallTextPay:Constants.secondTheardSmallTextPay,)
                                            ],
                                          ),
                                        ),
                                      ),
                                      Visibility(
                                        visible: widget.cashPay,
                                        child: InkWell(
                                          onTap: (){
                                            setState(() {
                                              _selectedIndex = 1;
                                            });
                                          },
                                          child: Container(
                                            margin: EdgeInsets.all(5),
                                            width: 100,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: (_selectedIndex==1) ?Constants.theardColor:Constants.mainColor,
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
                                              children: [
                                                SizedBox(
                                                    width: 50,
                                                    height: 50,
                                                    child: Image.asset("assets/cash.png",color:(_selectedIndex==1) ?Constants.mainColor:Constants.theardColor ,)
                                                ),
                                                Text((widget.title=="Online Booking")?LocaleKeys.Already_payed.tr():LocaleKeys.Cash_in_Clinic.tr(),style:(_selectedIndex==1) ? Constants.theardSmallTextPay:Constants.secondTheardSmallTextPay,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: (){
                                          setState(() {
                                            _selectedIndex = 2;
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(5),
                                          width: 100,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            color: (_selectedIndex==2) ?Constants.theardColor:Constants.mainColor,
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
                                            children: [
                                              Container(
                                                  width: 50,
                                                  height: 50,
                                                  child: Image.asset("assets/mobile_wallet.png",color:(_selectedIndex==2) ?Constants.mainColor:Constants.theardColor,)
                                              ),
                                              Text(LocaleKeys.MobileWallet.tr(),style:(_selectedIndex==2) ? Constants.theardSmallTextPay:Constants.secondTheardSmallTextPay,)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(LocaleKeys.After_Payment.tr(),style: Constants.smallTextPayScreen,maxLines: 4,),
                                  Padding(
                                    padding: const EdgeInsets.only(top:15.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${LocaleKeys.Total.tr()}:",style:Constants.titleTheardText,),
                                        Column(
                                          children: [
                                            InkWell(
                                              child:Container(
                                                margin: (context.locale.toString()=="en")? const EdgeInsets.all(1):const EdgeInsets.only(right: 10),
                                                child: Text(LocaleKeys.Do_you_have_a_promo_code.tr(),style:TextStyle(fontSize: 9),),
                                              ),
                                              onTap: (){
                                                showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    context: context,
                                                    backgroundColor: Colors.transparent,
                                                    builder: (BuildContext context) {
                                                      return Padding(
                                                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                        child: SingleChildScrollView(
                                                          child: Form(
                                                            key: _formKey,
                                                            child: Container(
                                                              padding: const EdgeInsets.all(20),
                                                              height: MediaQuery.of(context).size.height*0.25,
                                                              decoration: const BoxDecoration(
                                                                  color: Colors.white,
                                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                                                              ),
                                                              child: Column(
                                                                children: [
                                                                  Expanded(child: buildPromoFormField()),
                                                                  const SizedBox(height: 20),
                                                                  DefaultButton(
                                                                    text: LocaleKeys.Apply.tr(),
                                                                    press: ()async{
                                                                      if (_formKey.currentState!.validate()) {
                                                                        alterDialogBuilder(context);
                                                                        _formKey.currentState!.save();
                                                                        // apply promo code
                                                                        var response = await _bookings.applyPromo(widget.id, promo, context.read<UserData>().token);
                                                                        var body = await jsonDecode(response.body);
                                                                        if (response.statusCode == 200) {
                                                                          print(await response.body);
                                                                          Navigator.pop(context);
                                                                          _dialogs.okSDialogBuilder(context, LocaleKeys.promocode_applied.tr());

                                                                          setState(() {
                                                                            promoValue = body["fee_after_code"];
                                                                          });
                                                                        }
                                                                        else {
                                                                          if(body["error"]=="704"){
                                                                            print("invalid promocode");
                                                                            _dialogs.alterSDialogBuilder(context, LocaleKeys.invalid_promocode.tr());
                                                                          }else if (body["error"]=="705"){
                                                                            print("promocode expired");
                                                                            _dialogs.alterSDialogBuilder(context, LocaleKeys.promocode_expired.tr());
                                                                          }else if (body["error"]=="706"){
                                                                            print("promocode maxed out");
                                                                            _dialogs.alterSDialogBuilder(context, LocaleKeys.promocode_maxed_out.tr());
                                                                          }
                                                                          print(response.statusCode);
                                                                        }

                                                                      }
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                            ),
                                            Text("${LocaleKeys.EGP.tr()}${(promoValue==null)?widget.fee:promoValue}",style:Constants.titleTheardText,),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top:5.0),
                                    child: DefaultButton(
                                      loading: _isloading,
                                      text: (_selectedIndex==1)?LocaleKeys.Booking.tr():(_selectedIndex==0)?LocaleKeys.Pay.tr():LocaleKeys.Add_Phone_number.tr(),
                                      press: ()async{
                                        if((_selectedIndex==1)){
                                          //book
                                          print("book");
                                          var response =await _bookings.newBooking(
                                              context.read<UserData>().token,
                                              '',
                                              context.read<UserData>().email,
                                              (widget.cashPay==false)?"1":"2",
                                              (promoValue==null)?'':promo,
                                              "${widget.clinic_time_id}",
                                              "${widget.id}",
                                              widget.time_slot_id
                                          );
                                          String data= await response.stream.bytesToString();
                                          print(jsonDecode(data));
                                          if(response.statusCode == 200){

                                              Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(builder: (context) => MainScreen())
                                              );
                                              _dialogs.okDialogBuilder(context, LocaleKeys.Done_booking.tr());

                                          }
                                          else{
                                            _dialogs.alterDialogBuilder(context, LocaleKeys.Time_is_already_booked.tr());
                                            print(jsonDecode(data));
                                            print(response.reasonPhrase);
                                          }
                                        }else if(_selectedIndex==0){
                                          //online payment
                                          setState(() {
                                            _isloading = true;
                                          });
                                          print("online payment");
                                          PaymentCubit.get(context).getFirstToken(
                                              (promoValue==null)?(widget.fee*100).toString():(promoValue!*100).toString(),
                                              context.read<UserData>().email,
                                            context.read<UserData>().phone,
                                            context.read<UserData>().name,
                                            context.read<UserData>().lastname,
                                          );
                                        }else if(_selectedIndex==2){
                                          //mobile wallet
                                          showModalBottomSheet(
                                              isDismissible: false,
                                              isScrollControlled: true,
                                              context: context,
                                              backgroundColor: Colors.transparent,
                                              builder: (BuildContext context) {
                                                return Padding(
                                                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                    child: SingleChildScrollView(
                                                      child: Form(
                                                        key: _walletFormKey,
                                                        child: Container(
                                                          padding: const EdgeInsets.all(20),
                                                          height: MediaQuery.of(context).size.height*0.25,
                                                          decoration: const BoxDecoration(
                                                              color: Colors.white,
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))
                                                          ),
                                                          child: Column(
                                                            children: [
                                                              Expanded(child: buildPhoneNumberFormField()),
                                                              const SizedBox(height: 20),
                                                              DefaultButton(
                                                                text: LocaleKeys.Pay.tr(),
                                                                press: (){
                                                                  if (_walletFormKey.currentState!.validate()) {
                                                                    _walletFormKey.currentState!.save();
                                                                    Navigator.pop(context);
                                                                  }
                                                                },
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                );
                                              }).then((value){
                                                if(phoneNumber != null){
                                                  setState(() {
                                                    _isloading = true;
                                                  });
                                                  print("phone number is :- ${phoneNumber}");
                                                  PaymentCubit.get(context).getWallet(
                                                    (promoValue==null)?(widget.fee*100).toString():(promoValue!*100).toString(),
                                                    context.read<UserData>().email,
                                                    phoneNumber.toString(),
                                                    context.read<UserData>().name,
                                                    context.read<UserData>().lastname,
                                                  );
                                                }
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                          margin:const EdgeInsets.only(right: 8,top: 5,bottom: 185),
                          width: 320,
                          height: 250,
                          child: Image.asset("assets/payment.png")
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }));
  }

  TextFormField buildPromoFormField() {
    return TextFormField(
      onSaved: (newValue) => promo = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          promo = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kAPromoNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.Promo_code.tr(),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          phoneNumber = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kPhoneNumberNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.Phone_Number.tr(),
        hintText: LocaleKeys.Enter_your_phone_number.tr(),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  void alterDialogBuilder(var context) async{
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return AlertDialog(
            content: SizedBox(
                width: 30,
                height: 40,
                child: Center(child: CircularProgressIndicator()))
          );
        }
    );
  }
}

