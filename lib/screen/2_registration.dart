import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/components/externalDir.dart';
import 'package:vstock/components/waveclipper.dart';
import 'package:vstock/controller/registrationController.dart';
import 'package:vstock/screen/3_scan_type.dart';
import 'package:lottie/lottie.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isExpired = false;
  final _formKey = new GlobalKey<FormState>();
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  FocusNode? fieldFocusNode;
  ExternalDir externalDir = ExternalDir();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? uniqId;

  getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final map = deviceInfo.toMap();

    //String id = map["androidId"];
    String model = map["model"];
    String id = map["id"];
    String manufacturer = map["manufacturer"];
    uniqId = model + manufacturer;
    //print(uniqId);
  }

  // _showSnackbar(BuildContext context) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       backgroundColor: Color.fromARGB(255, 143, 17, 8),
  //       duration: const Duration(seconds: 1),
  //       content: Text('Expired!!!!'),
  //       action: SnackBarAction(
  //         label: 'Dissmiss',
  //         textColor: Colors.yellow,
  //         onPressed: () {
  //           ScaffoldMessenger.of(context).hideCurrentSnackBar();
  //         },
  //       ),
  //     ),
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeviceInfo();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        // backgroundColor: Color.fromARGB(255, 255, 255, 255),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Consumer<RegistrationController>(
            builder: (context, value, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: Stack(
                      children: <Widget>[
                        ClipPath(
                          clipper: WaveClipper(), //set our custom wave clipper.
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: 50,
                            ),
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.purple, Colors.blue],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                              ),
                            ),
                            height: size.height * 0.25,
                            alignment: Alignment.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 1),
                  //   child: Container(
                  //     height: size.height * 0.20,
                  //     child: Lottie.asset(
                  //       'asset/companylot.json',
                  //       // height: size.height*0.3,
                  //       // width: size.height*0.3,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 100, left: 20, right: 20),
                    child: SingleChildScrollView(
                      reverse: true,
                      child: Form(
                        key: _formKey,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              textForm("Company code"),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              textForm("Phone number"),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Container(
                                height: size.height * 0.05,
                                width: size.width * 0.3,
                                color: Colors.transparent,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.all(0.0),
                                    elevation: 0,
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      print("dsdzk---$uniqId");
                                      String tempFp1 =
                                          await externalDir.fileRead();
                                      Provider.of<RegistrationController>(
                                              context,
                                              listen: false)
                                          .postRegistration(
                                              tempFp1,
                                              controller1.text,
                                              uniqId!,
                                              "1",
                                              context);

                                      print("hdzsdsz");

                                      // print("res-----$res");

                                      FocusScope.of(context)
                                          .requestFocus(FocusNode());
                                      ScaffoldMessenger.of(context)
                                          .removeCurrentSnackBar();
                                      // Navigator.of(context).pop();
                                    }
                                  },
                                  child: Ink(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: [Colors.purple, Colors.blue]),
                                    ),
                                    child: Container(
                                      height: size.height * 0.05,
                                      width: size.width * 0.3,
                                      alignment: Alignment.center,
                                      child: Text(
                                        "Register",
                                        style: GoogleFonts.aBeeZee(
                                            textStyle: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                        // style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              // child: ElevatedButton(
                              //   style: ElevatedButton.styleFrom(
                              //     primary: ColorThemeComponent.mainclr,
                              //   ),
                              //   onPressed: () async {
                              //     if (_formKey.currentState!
                              //         .validate()) {
                              //       print("dsdzk---$uniqId");
                              //       String tempFp1 =
                              //           await externalDir.fileRead();
                              //       Provider.of<RegistrationController>(
                              //               context,
                              //               listen: false)
                              //           .postRegistration(
                              //               tempFp1,
                              //               controller1.text,
                              //               uniqId!,
                              //               "1",
                              //               context);

                              //       print("hdzsdsz");

                              //       // print("res-----$res");

                              //       FocusScope.of(context)
                              //           .requestFocus(FocusNode());
                              //       ScaffoldMessenger.of(context)
                              //           .removeCurrentSnackBar();
                              //       // Navigator.of(context).pop();
                              //     }
                              //   },
                              //   child: Text(
                              //     "Register",
                              //     style: GoogleFonts.aBeeZee(
                              //         textStyle: TextStyle(
                              //             fontSize: 16,
                              //             fontWeight: FontWeight.bold)),
                              //     // style: TextStyle(color: Colors.white),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.09,
                  ),
                  value.isLoading
                      ? SpinKitCircle(
                          // backgroundColor:,
                          color: ColorThemeComponent.mainclr,

                          // valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                          // value: 0.25,
                        )
                      : Container()
                  // Consumer<RegistrationController>(
                  //   builder: (context, value, child) {
                  //     if (value.isLoading) {
                  //       return SpinKitCircle(
                  //         // backgroundColor:,
                  //         color: ColorThemeComponent.listclr,

                  //         // valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
                  //         // value: 0.25,
                  //       );
                  //     } else {
                  //       return Container();
                  //     }
                  //   },
                  // ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget textForm(String type) {
    return TextFormField(
      keyboardType: type == "Phone number" ? TextInputType.number : null,
      controller: type == "Company code" ? controller1 : controller2,
      style: GoogleFonts.aBeeZee(
          textStyle: TextStyle(
        fontSize: 16,
      )),
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          //  when the TextFormField in unfocused
        ),
        border: UnderlineInputBorder(
          borderSide:
              BorderSide(color: ColorThemeComponent.textFrmtext, width: 1.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorThemeComponent.newclr),
          //  when the TextFormField in focused
        ),
        icon: Icon(
          type == "Company code" ? Icons.business : Icons.phone,
          color: ColorThemeComponent.mainclr,
        ),
        // hintText: 'What do people call you?',
        labelText: type,
        labelStyle: TextStyle(
          color: ColorThemeComponent.mainclr,
        ),
      ),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Please Enter $type';
        }
        return null;
      },
    );
  }

  ////////////////////////////////////////////////////////
  Future<bool> _onBackPressed(BuildContext context) async {
    return await showDialog(context: context, builder: (context) => exit(0));
  }
}
