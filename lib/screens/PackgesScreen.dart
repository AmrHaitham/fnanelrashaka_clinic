import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:fanan_elrashaka_clinic/Network/Bookings.dart';
import 'package:fanan_elrashaka_clinic/Network/Clinics.dart';
import 'package:fanan_elrashaka_clinic/providers/UserData.dart';
import 'package:fanan_elrashaka_clinic/screens/ChosePayment.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_clinic/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_clinic/widgets/MainContainer.dart';
import 'package:fanan_elrashaka_clinic/widgets/packageItemCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/dialogs.dart';

class PackgesScreen extends StatelessWidget {
  Clinics _clinics = Clinics();
  Bookings _bookings = Bookings();
  String? _description;
  String? _price;
  int customID = 13;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return MainContainer(
        title: LocaleKeys.Packges.tr(),
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: FutureBuilder(
              future: _clinics.getAllPackges(context.read<UserData>().token),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    // error in data
                    print(snapshot.error.toString());
                    return Container();
                  } else if (snapshot.hasData) {
                    print(snapshot.data);
                    return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 190,
                          mainAxisSpacing: 30,
                          crossAxisSpacing: 20,
                        ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext ctx, index) {
                          double per =0;
                          if(snapshot.data[index]['old_fee']!=null){
                            per = snapshot.data[index]['fee'] / snapshot.data[index]['old_fee'] * 100 - 100;
                          }
                          return Stack(
                            children: [
                              PackageItemCard(
                                isCustom: (snapshot.data[index]['id'] == customID)?true:false,
                                open: () {
                                  if (snapshot.data[index]['id'] == customID) {
                                    showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        backgroundColor: Colors.transparent,
                                        builder: (BuildContext context) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: SingleChildScrollView(
                                              child: Form(
                                                key: _formKey,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(20),
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.6,
                                                  decoration: const BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(15),
                                                              topRight: Radius
                                                                  .circular(
                                                                      15))),
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: Column(
                                                          children: [
                                                            buildPriceFormField(),
                                                            const SizedBox(
                                                                height: 20),
                                                            buildDescriptionFormField()
                                                          ],
                                                        ),
                                                      ),
                                                      DefaultButton(
                                                        text: LocaleKeys.Pay.tr(),
                                                        press: () async {
                                                          if (_formKey.currentState!.validate()) {
                                                            _formKey.currentState!.save();

                                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                                ChosePayment(
                                                                  isPackage: true,
                                                                  title: "Packages",
                                                                  fee: double.parse(_price!),
                                                                  id: snapshot.data[index]['id'],
                                                                  cashPay: false,
                                                                  clinic_time_id: 1,
                                                                  description: _description!,
                                                                  time_slot_id: "",
                                                                )
                                                            )
                                                            );
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
                                  } else {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                        ChosePayment(
                                                  isPackage: true,
                                                  title: "Packages",
                                                  fee: snapshot.data[index]['fee'],
                                                  id: snapshot.data[index]['id'],
                                                  cashPay: false,
                                                  clinic_time_id: 1,
                                                  description: "",
                                                  time_slot_id: "",
                                                )
                                        )
                                    );
                                  }
                                },
                                image: snapshot.data[index]['image'],
                                heding: (context.locale.toString() == "en")
                                    ? snapshot.data[index]["name_en"]
                                    : snapshot.data[index]["name_ar"],
                                price: (snapshot.data[index]['fee'] == 0 ||snapshot.data[index]['fee'] == null)
                                    ? ""
                                    : "EGP ${snapshot.data[index]['fee']}",
                                oldPrice: (snapshot.data[index]['old_fee'] == null)
                                    ? ""
                                    : "EGP ${snapshot.data[index]['old_fee']}",
                                isBig: false,
                              ),
                              if (snapshot.data[index]['old_fee'] != null)
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Container(
                                      width: 35,
                                      height: 24,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Constants.theardColor),
                                      child: Center(
                                        child: Text(
                                          (context.locale.toString()!="ar")?"${per.toInt()}%":"%${per.toInt()}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        });
                  } else {
                    //no data
                    return Container();
                  }
                } else {
                  //error in connection
                  return Container();
                }
              }),
        ),
        backIcon: true,
        patternColor: Colors.grey);
  }

  TextFormField buildPriceFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => _price = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _price = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kAPriceNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.Price.tr(),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      minLines: 6,
      maxLines: 6,
      onSaved: (newValue) => _description = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          _description = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kADescriptionNullError;
        }
        return null;
      },
      maxLength: 120,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.Description.tr(),
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
