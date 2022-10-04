import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/components/waveclipper.dart';
import 'package:vstock/screen/2_registration.dart';
import 'package:vstock/screen/3_scan_type.dart';
import 'package:vstock/services/dbHelper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? companyId;
  late DateTime tempDate;
  DateTime now = DateTime.now();

  String? expiry;
  bool isExpired = false;

  navigate() async {
    await Future.delayed(Duration(seconds: 1), () async {
      print("splash................");
      var companyDetails = await VstockDB.instance
          .selectCommonQuery('companyRegistrationTable', '*', '');
      print("osdodjsodks------${companyDetails}");

      if (companyDetails != null && companyDetails.isNotEmpty) {
        // for (var item in companyDetails) {
        //   expiry = item["expiry_date"];
        // }
        expiry = companyDetails[0]["expiry_date"];
        tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(expiry!);
        isExpired = tempDate.isBefore(now);
        print("expired---------${isExpired}");
      }

      // DateTime dayDate = DateTime.parse(expiry!.split('-').reversed.join());
      print("jfkdjfid${isExpired}");
      if (isExpired == true) {
        print("jhdjdjdsj");
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.remove('companyId');
      }

      SharedPreferences pref = await SharedPreferences.getInstance();
      companyId = pref.getString('companyId');

      print("companyId==$companyId");
      //  await  VstockDB.instance
      //                           .deleteFromTableCommonQuery("barcode", "");
      await VstockDB.instance.barcodeinsertion("", "ABC-abc-1234", "abc", 100);
      // Navigator.push(context,
      //     MaterialPageRoute(builder: (context) => RegistrationScreen()));
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                companyId == null ? RegistrationScreen(isExpired: isExpired,) : ScanType()),
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("splash.navigate...............");
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.blue],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
            child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.35,
                ),
                Container(
                  child: Image.asset(
                    "asset/Vega_logo.png",
                    color: ColorThemeComponent.color3,
                  ),
                ),
                Text(
                  "Barcode Scanner",
                  style: TextStyle(
                    fontFamily: "Roboto",
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.3,
                ),
                //  Text(
                //           'Version: ${snapshot.data!.version}',
                //         );
              ],
            ),
          ), 
          ),
         
        ],
      ),
    );
  }
}
