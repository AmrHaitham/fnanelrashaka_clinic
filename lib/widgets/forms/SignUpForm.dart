import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Network/UserAuth.dart';
import 'package:fanan_elrashaka_clinic/helper/dialogs.dart';
import 'package:fanan_elrashaka_clinic/screens/LandingPage.dart';
import 'package:fanan_elrashaka_clinic/screens/LoginScreen.dart';
import 'package:fanan_elrashaka_clinic/screens/MainScreen.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:fanan_elrashaka_clinic/widgets/DefaultButton.dart';
import 'package:fanan_elrashaka_clinic/widgets/forms/FormError.dart';
import 'package:flutter/material.dart';
import 'package:select_form_field/select_form_field.dart';
import '/Constants.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final Dialogs _dialogs = Dialogs();
  bool _isLoding = false;
  Auth auth = Auth();
  final _formKey = GlobalKey<FormState>();
  String? email;
  String? password;
  String? conform_password;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? gender;
  String? birthday;
  final List<String?> errors = [];

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
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              LocaleKeys.CreateAccount.tr(),
              style: TextStyle(
                  fontSize: 25.0,
                  color: Constants.theardColor,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              LocaleKeys.You_will_fit_with_us.tr(),
              style: Constants.smallText,
            ),
            const SizedBox(height: 20),
            buildFirstNameFormField(),
            const SizedBox(height: 20),
            buildLastNameFormField(),
            const SizedBox(height: 20),
            buildEmailFormField(),
            const SizedBox(height: 20),
            buildPhoneNumberFormField(),
            const SizedBox(height: 20),
            buildPasswordFormField(),
            const SizedBox(height: 20),
            buildConformPassFormField(),
            const SizedBox(height: 20),
            DateTimePicker(
              dateMask: 'yyyy-MM-dd',
              initialValue: '',
              firstDate: DateTime(1960),
              lastDate: DateTime(2100),
              dateLabelText: LocaleKeys.Birthday.tr(),
              onSaved: (newValue) => birthday = newValue,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: Constants.kABirthdayNullError);
                }
                return null;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  addError(error: Constants.kABirthdayNullError);
                  return "";
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: LocaleKeys.Birthday.tr(),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),
            const SizedBox(height: 20),
            SelectFormField(
              type: SelectFormFieldType.dropdown,
              // or can be dialog
              labelText: LocaleKeys.Gender.tr(),
              items: _items,
              decoration: InputDecoration(
                suffixIcon: Container(
                    padding: EdgeInsets.all(18),
                    width: 10,
                    height: 10,
                    child: Image.asset("assets/dropdown_arrow.png")),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                hintText: LocaleKeys.Gender.tr(),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              onSaved: (newValue) => gender = newValue,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  removeError(error: Constants.kAGenderNullError);
                }
                return null;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  addError(error: Constants.kAGenderNullError);
                  return "";
                }
                return null;
              },
            ),
            FormError(errors: errors),
            const SizedBox(height: 20),
            DefaultButton(
              loading: _isLoding,
              text: LocaleKeys.sign_up.tr(),
              press: () async {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  setState(() {
                    _isLoding = true;
                  });
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.clear();
                  var response = await auth.register(email, firstName,lastName, password, phoneNumber, birthday, gender);
                  String data= await response.stream.bytesToString();
                  if (response.statusCode == 200) {
                    await prefs.setBool('logedIn', true);
                    await prefs.setString('email', email!);
                    await prefs.setString('token', jsonDecode(data)['token']);
                    setState(() {
                      _isLoding = false;
                      errors.clear();
                    });
                    print(data);
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => LandingPage())
                    );
                  } else if(response.statusCode == 401){
                    if(jsonDecode(data)['error']=="702"){
                      print(response.reasonPhrase);
                      _dialogs.alterDialogBuilder(context, LocaleKeys.User_already_exists.tr());
                    }else{
                      _dialogs.alterDialogBuilder(context, LocaleKeys.You_are_not_authorized_to_do_this_action.tr());
                    }
                  } else if(response.statusCode == 400){
                    _dialogs.alterDialogBuilder(context, LocaleKeys.Input_a_valid_data.tr());
                  } else if(response.statusCode >= 500 && response.statusCode <600){
                    _dialogs.alterDialogBuilder(context, LocaleKeys.We_are_in_maintenance_now_please_try_again_later.tr());
                  }else{
                    _dialogs.alterDialogBuilder(context, LocaleKeys.Error_while_sign_up.tr());
                  }
                  setState(() {
                    errors.clear();
                    _isLoding = false;
                  });
                }
              },
            ),
            const SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.03),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocaleKeys.alreadyHaveAnAccount.tr(),
                    style: Constants.smallText,
                  ),
                  GestureDetector(
                    child: Text(
                      LocaleKeys.login.tr(),
                      style: Constants.secondSmallText,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                  ),
                ],
              ),
            )
          ],
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
          removeError(error: Constants.kPassNullError);
        } else if (value.isNotEmpty && password == conform_password) {
          removeError(error: Constants.kMatchPassError);
        }
        conform_password = value;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: Constants.kPassNullError);
          return "";
        } else if ((password != value)) {
          addError(error: Constants.kMatchPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        labelText: LocaleKeys.Confirm_Password.tr(),
        hintText: LocaleKeys.Re_enter_your_password.tr(),
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
          removeError(error: Constants.kPhoneNumberNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: Constants.kPhoneNumberNullError);
          return "";
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

  TextFormField buildFirstNameFormField() {
    return TextFormField(
      onSaved: (newValue) => firstName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: Constants.kNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: Constants.kNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.Name.tr(),
        hintText:  LocaleKeys.Enter_your_name.tr(),
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  TextFormField buildLastNameFormField() {
    return TextFormField(
      onSaved: (newValue) => lastName = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: Constants.kLastNamelNullError);
        }
        return null;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: Constants.kLastNamelNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        labelText: LocaleKeys.Last_name.tr(),
        hintText:  LocaleKeys.Please_Enter_your_lastname.tr(),
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
          removeError(error: Constants.kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: Constants.kShortPassError);
        }
        password = value;
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
          borderRadius: BorderRadius.circular(5),
        ),
        labelText:  LocaleKeys.Password.tr(),
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
}
