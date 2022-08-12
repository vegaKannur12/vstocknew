import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
