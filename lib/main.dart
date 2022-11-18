import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/controller/barcodeController.dart';
import 'package:vstock/controller/registrationController.dart';
import 'package:vstock/screen/1_splashscreen.dart';
import 'package:vstock/screen/2_registration.dart';
import 'package:vstock/screen/3_scan_type.dart';
import 'package:vstock/screen/4_barcodeScan_list.dart';
import 'package:vstock/screen/5_scanScreen.dart';
import 'package:vstock/screen/companyRegistration.dart';
import 'package:vstock/screen/csvImport.dart';


void requestPermission() async {
  var status = await Permission.storage.status;
  // var statusbl= await Permission.bluetooth.status;

  var status1 = await Permission.manageExternalStorage.status;

  if (!status1.isGranted) {
    await Permission.storage.request();
  }
  if (!status1.isGranted) {
    var status = await Permission.manageExternalStorage.request();
    if (status.isGranted) {
      await Permission.bluetooth.request();
    } else {
      openAppSettings();
    }
    // await Permission.app
  }
  if (!status1.isRestricted) {
    await Permission.manageExternalStorage.request();
  }
  if (!status1.isPermanentlyDenied) {
    await Permission.manageExternalStorage.request();
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  requestPermission();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => BarcodeController()),
      ChangeNotifierProvider(create: (_) => RegistrationController()),
    ],
    child: MyApp(),
  ));

}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'Roboto Mono sample',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          // fontFamily: 'OpenSans',
          primaryColor: ColorThemeComponent.appbar,
          // colorScheme: ColorScheme.fromSwatch(
          //   primarySwatch: Colors.indigo,
          // ),
          textTheme: GoogleFonts.latoTextTheme(
            Theme.of(context).textTheme,
          ),
          // scaffoldBackgroundColor: P_Settings.bodycolor,
          // textTheme: const TextTheme(
          //   headline1: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          //   headline6: TextStyle(
          //     fontSize: 25.0,
          //   ),
          //   bodyText2: TextStyle(
          //     fontSize: 14.0,
          //   ),
          // ),
        ),
        home: SplashScreen()

        //  AnimatedSplashScreen(
        //   backgroundColor: Colors.black,
        //   splash: Image.asset("asset/logo_black_bg.png"),
        //   nextScreen: SplashScreen(),
        //   splashTransition: SplashTransition.fadeTransition,
        //   duration: 1000,
        // ),
        );
  }
}
