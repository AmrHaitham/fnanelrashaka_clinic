import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Constants.dart';
import 'package:fanan_elrashaka_clinic/Network/UserProfile.dart';
import 'package:fanan_elrashaka_clinic/helper/dialogs.dart';
import 'package:fanan_elrashaka_clinic/providers/UserData.dart';
import 'package:fanan_elrashaka_clinic/screens/BookingsScreen.dart';
import 'package:fanan_elrashaka_clinic/screens/HomeScreen.dart';
import 'package:fanan_elrashaka_clinic/screens/ProfileScreen.dart';
import 'package:fanan_elrashaka_clinic/screens/WelcomeScreen.dart';
import 'package:fanan_elrashaka_clinic/translations/locale_keys.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedScreenIndex = 0;

  UserProfile _userProfile = UserProfile();
  Dialogs _dialog = Dialogs();
  saveUserInfo()async{
    try{
      var response =await _userProfile.getUserProfileData(
          context.read<UserData>().email,
          context.read<UserData>().token);
      if(response!=null){
        if(response["detail"]=="Invalid token."||response["detail"]=="Not found."){
          _dialog.logoutDialogBuilder(context, LocaleKeys.Pleace_login_again.tr());
        }else{
          print(response);
          context.read<UserData>().setUserPhone(response['phone']);
          context.read<UserData>().setUserName(response['first_name']);
          context.read<UserData>().setUserLastName(response['last_name']);
          print("name is :- ${context.read<UserData>().name}");
          print("phone is :- ${context.read<UserData>().phone}");
          print("last name is :- ${context.read<UserData>().lastname}");
        }
      }else{
        _dialog.internetDialogBuilder(context, LocaleKeys.check_our_internet_connection.tr());
      }
    }catch(error){
      _dialog.internetDialogBuilder(context, LocaleKeys.check_our_internet_connection.tr());
    }


  }

  final List _screens = [
    HomeScreen(),
    BookingsScreen(),
    ProfileScreen()
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        body: _screens[_selectedScreenIndex],
        bottomNavigationBar: BottomNavigationBar(
        enableFeedback: true,
        showUnselectedLabels: false,
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        selectedItemColor: Constants.secondColor,
        items: [
          BottomNavigationBarItem(icon: SizedBox(width:25,height:35,child: Image.asset("assets/home.png",color:(_selectedScreenIndex==0)?Constants.secondColor:Colors.black,)), label: LocaleKeys.Home.tr()),
          BottomNavigationBarItem(icon: SizedBox(width:25,height:35,child: Image.asset("assets/bookings.png",color:(_selectedScreenIndex==1)?Constants.secondColor:Colors.black,)), label: LocaleKeys.Bookings.tr()),
          BottomNavigationBarItem(icon: SizedBox(width:25,height:35,child: Image.asset("assets/profile.png",color:(_selectedScreenIndex==2)?Constants.secondColor:Colors.black,)), label: LocaleKeys.Profile.tr())
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   child:const Icon(Icons.exit_to_app),
        //   onPressed: ()async{
        //     SharedPreferences prefs = await SharedPreferences.getInstance();
        //     prefs.clear();
        //     Navigator.of(context).pushReplacement(
        //         MaterialPageRoute(builder: (context) => WelcomeScreen())
        //     );
        //   },
        // ),
      ),
    );
  }
}
