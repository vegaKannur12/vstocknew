import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vstock/controller/registrationController.dart';
import 'package:vstock/screen/1_splashscreen.dart';
import 'package:vstock/screen/2_registration.dart';
import 'package:vstock/screen/3_scan_type.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      MultiProvider(
        providers: [
          // ChangeNotifierProvider(create: (_) => ProviderController()),
          ChangeNotifierProvider(
            create: (_) => RegistrationController(),
          ),
        ],
        child: MyApp(),
      ),
    );
  });
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
      // home: SplashScreen(),

      // theme: ThemeData(
      //   scaffoldBackgroundColor: Colors.grey[200],
      //   colorScheme: ColorScheme.fromSwatch().copyWith(
      //     primary: Color(0xFF424242),
      //     secondary: Color(0xFF424242),
      //   ),
      // ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
