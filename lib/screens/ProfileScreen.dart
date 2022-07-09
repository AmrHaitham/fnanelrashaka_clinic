import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Network/UserProfile.dart';
import 'package:fanan_elrashaka_clinic/helper/dialogs.dart';
import 'package:fanan_elrashaka_clinic/providers/UserData.dart';
import 'package:fanan_elrashaka_clinic/screens/WelcomeScreen.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_clinic/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_clinic/widgets/ProfilePIc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constants.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  UserProfile _userProfile = UserProfile();
  String? email;
  String? password;
  String? oldPassword;
  String? conform_password;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? gender;
  String? birthday;
  String? address;
  Dialogs _dialog = Dialogs();
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'M',
      'label': LocaleKeys.Male.tr(),
    },
    {
      'value': 'F',
      'label': LocaleKeys.Female.tr(),
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/pattern.png"),
                colorFilter: ColorFilter.mode(
                    Constants.secondColor.withOpacity(0.97),
                    BlendMode.exclusion),
                fit: BoxFit.cover,
              ),
            ),
            child: FutureBuilder(
                future: _userProfile.getUserProfileData(
                    context.read<UserData>().email,
                    context.read<UserData>().token),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.white,));
                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      print(snapshot.error.toString());
                      return const Text('');
                    } else if (snapshot.hasData) {
                      print(snapshot.data);
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        margin: (context.locale.toString()=="en")?const EdgeInsets.only(left: 25, top: 26):const EdgeInsets.only(right: 25, top: 30),
                                        height: 35,
                                        child: Text(
                                          LocaleKeys.Profile.tr(),
                                          style: Constants.titleText,
                                        )),
                                    Container(
                                      margin:(context.locale.toString()=="en")? EdgeInsets.only(
                                          left: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.39,
                                          top: 10):EdgeInsets.only(
                                        right: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.39,
                                        top: 10),
                                      child: ProfilePic(
                                        profile: snapshot.data["image"],
                                        uploadImage: () async{
                                          var imagePicker;
                                          imagePicker = await _picker.pickImage(source: ImageSource.gallery,imageQuality: 20);
                                          String imageLocation = imagePicker.path.toString();
                                          var picResponse =await _userProfile.updateProfilePic(
                                              context.read<UserData>().email,
                                              context.read<UserData>().token,
                                              imageLocation,
                                              snapshot.data['first_name'],
                                              snapshot.data['phone'],
                                              snapshot.data['gender']
                                          );
                                          print(picResponse);
                                          if (picResponse['error'] != "703") {
                                            _dialog.okDialogBuilder(context,  LocaleKeys.You_are_successfully_change_your_profile_picture.tr());
                                          }else{
                                            print(picResponse);
                                            _dialog.alterDialogBuilder(context, LocaleKeys.Error_while_updating_picture_profile_data_check_your_interne_connection.tr());
                                          }
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  child: InkWell(
                                    onTap: ()async{
                                      if(context.locale.toString()=="en"){
                                        context.setLocale(Locale("ar"));
                                      }else {
                                        context.setLocale(Locale("en"));
                                      }
                                    },
                                    child: Container(
                                        margin:(context.locale.toString()=="en")?const EdgeInsets.only(top: 15,bottom: 15,left: 20):const EdgeInsets.only(top: 15,bottom: 15,right: 20),
                                        width:30,
                                        height:30 ,
                                        child: Image.asset((context.locale.toString()=="en")?"assets/Egypt_flag_300.png":"assets/united-kingdom.png")
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () async{
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      // save data
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      var changeProfileResponse = await _userProfile.updateUserProfile(
                                          context.read<UserData>().email,
                                          context.read<UserData>().token,
                                          firstName,lastName,phoneNumber,birthday,gender,address
                                      );
                                      if (changeProfileResponse['error'] != "703") {
                                        _dialog.okDialogBuilder(context, LocaleKeys.You_are_successfully_change_your_profile_data.tr());
                                      }else{
                                        print(changeProfileResponse);
                                        _dialog.alterDialogBuilder(context, LocaleKeys.Error_while_updating_profile_data_check_your_internet_connection.tr());
                                      }
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }
                                  },
                                  child: Container(
                                      margin: (context.locale.toString()=="en")?const EdgeInsets.only(
                                          right: 25, top: 30):const EdgeInsets.only(
                                          left: 25, top: 30),
                                      width: 20,
                                      height: 20,
                                      child: Image.asset(
                                        "assets/floppy-disk.png",
                                        color: Colors.white,
                                      )),
                                ),

                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12)),
                                image: DecorationImage(
                                  image: const AssetImage("assets/pattern.png"),
                                  colorFilter: ColorFilter.mode(
                                      Colors.grey.withOpacity(0.025),
                                      BlendMode.dstATop),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 8, left: 15, right: 15),
                                child: SingleChildScrollView(
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 20),
                                        buildEmailFormField(context.read<UserData>().email),
                                        const SizedBox(height: 20),
                                        buildFirstNameFormField(snapshot.data['first_name']),
                                        const SizedBox(height: 20),
                                        buildLastNameFormField(snapshot.data['last_name']),
                                        const SizedBox(height: 20),
                                        buildPhoneNumberFormField(snapshot.data['phone']),
                                        const SizedBox(height: 20),
                                        DateTimePicker(
                                          dateMask: 'yyyy-MM-dd',
                                          initialValue: snapshot.data['birthday'],
                                          firstDate: DateTime(1960),
                                          lastDate: DateTime(2100),
                                          dateLabelText: LocaleKeys.Birthday.tr(),
                                          onSaved: (newValue) =>
                                          birthday = newValue,
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              birthday = value;
                                            }
                                            return null;
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return Constants
                                                  .kABirthdayNullError;
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(5.0),
                                            ),
                                            label:Text(LocaleKeys.Birthday.tr()) ,
                                            hintText: LocaleKeys.Birthday.tr(),
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        SelectFormField(
                                          initialValue: snapshot.data['gender'],
                                          type: SelectFormFieldType
                                              .dropdown, // or can be dialog
                                          labelText: LocaleKeys.Gender.tr(),
                                          items: _items,
                                          decoration: InputDecoration(
                                            suffixIcon: Container(
                                                padding: EdgeInsets.all(18),
                                                width: 10,
                                                height: 10,
                                                child: Image.asset(
                                                    "assets/dropdown_arrow.png")),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(5.0),
                                            ),
                                            label:Text(LocaleKeys.Gender.tr()) ,
                                            hintText: LocaleKeys.Gender.tr(),
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                          ),
                                          onSaved: (newValue) =>
                                          gender = newValue,
                                          onChanged: (value) {
                                            if (value.isNotEmpty) {
                                              gender = value;
                                            }
                                            return null;
                                          },
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return Constants
                                                  .kAGenderNullError;
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                        buildAddressFormField(snapshot.data['address']),
                                        const SizedBox(height: 20),
                                        TextField(
                                          decoration: InputDecoration(
                                            suffixIcon: Container(
                                              width: 10,
                                              height: 10,
                                              child:
                                              Icon(Icons.arrow_forward_ios),
                                            ),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(5.0),
                                            ),
                                            hintText: LocaleKeys.Change.tr(),
                                            floatingLabelBehavior:
                                            FloatingLabelBehavior.auto,
                                          ),
                                          readOnly: true,
                                          onTap: () {
                                            showModalBottomSheet(
                                                isScrollControlled: true,
                                                context: context,
                                                backgroundColor:
                                                Colors.transparent,
                                                builder:
                                                    (BuildContext context) {
                                                  return Padding(
                                                    padding: EdgeInsets.only(
                                                        bottom: MediaQuery.of(
                                                            context)
                                                            .viewInsets
                                                            .bottom),
                                                    child:
                                                    SingleChildScrollView(
                                                      child: Form(
                                                        key: _passwordFormKey,
                                                        child: Container(
                                                          padding:
                                                          const EdgeInsets
                                                              .all(20),
                                                          height: MediaQuery.of(
                                                              context)
                                                              .size
                                                              .height *
                                                              0.6,
                                                          decoration: const BoxDecoration(
                                                              color:
                                                              Colors.white,
                                                              borderRadius: BorderRadius.only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                      15),
                                                                  topRight: Radius
                                                                      .circular(
                                                                      15))),
                                                          child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: Column(
                                                                  children: [
                                                                    buildOldPasswordFormField(),
                                                                    const SizedBox(
                                                                        height:
                                                                        20),
                                                                    buildPasswordFormField(),
                                                                    const SizedBox(
                                                                        height:
                                                                        20),
                                                                    buildConformPassFormField(),
                                                                  ],
                                                                ),
                                                              ),
                                                              DefaultButton(
                                                                loading: _isLoading,
                                                                text: LocaleKeys.Change.tr(),
                                                                press: () async{
                                                                  if (_passwordFormKey.currentState!.validate()) {
                                                                    _passwordFormKey.currentState!.save();
                                                                    setState(() {
                                                                      _isLoading = true;
                                                                    });
                                                                    // save new password
                                                                   var changeResponse = await _userProfile.updateUserPassword(
                                                                        context.read<UserData>().email,
                                                                        context.read<UserData>().token,
                                                                        oldPassword,
                                                                        password
                                                                    );
                                                                  if (changeResponse['error'] != "703") {
                                                                    Navigator.pop(context);
                                                                    _dialog.okDialogBuilder(context, LocaleKeys.You_are_successfully_change_your_password.tr());
                                                                  }else{
                                                                    _dialog.alterDialogBuilder(context, LocaleKeys.wrong_old_password.tr());
                                                                  }
                                                                    setState(() {
                                                                      _isLoading = false;
                                                                    });
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
                                        const SizedBox(height: 20),
                                        DefaultButton(
                                          text: LocaleKeys.Log_out.tr(),
                                          press: ()async{
                                            SharedPreferences prefs = await SharedPreferences.getInstance();
                                            prefs.clear();
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(builder: (context) => WelcomeScreen())
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 20),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else{
                      return Container();
                    }
                  }else{
                    return Container();
                  }
                }
                )
        ),
      ),
    );
  }

  TextFormField buildConformPassFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => conform_password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          conform_password = value;
        } else if (value.isNotEmpty && password == conform_password) {
          conform_password = value;
        }
        conform_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kPassNullError;
        } else if ((password != value)) {
          return Constants.kMatchPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: LocaleKeys.Confirm_New_Password.tr(),
        hintText: LocaleKeys.Re_enter_your_password.tr(),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildPhoneNumberFormField(phone) {
    return TextFormField(
      initialValue: phone,
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

  TextFormField buildFirstNameFormField(name) {
    return TextFormField(
      initialValue: name,
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          firstName = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kNamelNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.Name.tr(),
        hintText: LocaleKeys.Enter_your_name.tr(),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
  TextFormField buildLastNameFormField(lastname) {
    return TextFormField(
      initialValue: lastname,
      onSaved: (newValue) => lastName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          lastName = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kLastNamelNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.Last_name.tr(),
        hintText: LocaleKeys.Please_Enter_your_lastname.tr(),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          password = value;
        } else if (value.length >= 8) {
          password = value;
        }
        password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kPassNullError;
        } else if (value.length < 8) {
          return Constants.kShortPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.New_Password.tr(),
        hintText: LocaleKeys.Enter_your_password.tr(),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildOldPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => oldPassword = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          oldPassword = value;
        } else if (value.length >= 8) {
          oldPassword = value;
        }
        oldPassword = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kPassNullError;
        } else if (value.length < 8) {
          return Constants.kShortPassError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.Old_Password.tr(),
        hintText: LocaleKeys.Enter_your_old_password.tr(),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildEmailFormField(initemail) {
    return TextFormField(
      enabled: false,
      initialValue: initemail,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          email = value;
        } else if (Constants.emailValidatorRegExp.hasMatch(value)) {
          email = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kEmailNullError;
        } else if (!Constants.emailValidatorRegExp.hasMatch(value)) {
          return Constants.kInvalidEmailError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.Email.tr(),
        hintText: LocaleKeys.Enter_your_email.tr(),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildAddressFormField(initaddress) {
    return TextFormField(
      initialValue: initaddress,
      minLines: 6,
      maxLines: 6,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          address = value;
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          return Constants.kAddressNullError;
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.Address.tr(),
        alignLabelWithHint: true,
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }
}
