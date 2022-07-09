import 'package:easy_localization/easy_localization.dart';
import 'package:fanan_elrashaka_clinic/Network/dio.dart';
import 'package:fanan_elrashaka_clinic/providers/SelectedIndex.dart';
import 'package:fanan_elrashaka_clinic/providers/UserData.dart';
import 'package:fanan_elrashaka_clinic/screens/LandingPage.dart';
import 'package:fanan_elrashaka_clinic/translations/codegen_loader.g.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  await DioHelperPayment.init();
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => UserData()),
      ChangeNotifierProvider(create: (_) => SelectedIndex()),
    ],
    child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en'),
        assetLoader: CodegenLoader(),
        child: const MyApp()),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    if (context.locale.toString() == "en") {
      return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Segoe',
          ),
          home: LandingPage());
    } else {
      return MaterialApp(
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: LandingPage());
    }
  }
}
