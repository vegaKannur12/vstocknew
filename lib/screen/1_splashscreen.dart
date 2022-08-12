import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstock/screen/2_registration.dart';
import 'package:vstock/screen/scan_type.dart';
import 'package:vstock/services/dbHelper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 String? companyId;
 String? expiry;

  navigate() async {
    await Future.delayed(Duration(milliseconds: 3000), () async {
      // var companyDetails = await VstockDB.instance.getCompanyDetails();
      // print("osdodjsodks------${companyDetails}");

      // if (companyDetails != null && companyDetails.isNotEmpty) {
      //   for (var item in companyDetails) {
      //     expiry = item["expiry_date"];
      //   }
      //   //expiry = companyDetails[0]["expiry_date"];
      //   // tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(expiry);
      //   // isExpired = tempDate.isBefore(now);

      //   print("expired---------${isExpired}");
      // }

      // DateTime dayDate = DateTime.parse(expiry.split('-').reversed.join());
      //print("jfkdjfid${isExpired}");
      // if (isExpired == true) {
      //   print("jhdjdjdsj");
      //   SharedPreferences pref = await SharedPreferences.getInstance();
      //   companyId = pref.remove('companyId');
      // }

      SharedPreferences pref = await SharedPreferences.getInstance();
      companyId = pref.getString('companyId');

      print(companyId);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => companyId == null
                  ? RegistrationScreen()
                  : ScanType()));
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    navigate();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Center(
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
                color: Colors.pink,
              ),
            ),
            Text(
              "Barcode Scanner",
              style: TextStyle(
                fontFamily: "Roboto",
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
    );
  }
}
