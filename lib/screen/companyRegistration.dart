import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/components/externalDir.dart';
import 'package:vstock/controller/registrationController.dart';

class CompanyRegistration extends StatefulWidget {
  @override
  State<CompanyRegistration> createState() => _CompanyRegistrationState();
}

class _CompanyRegistrationState extends State<CompanyRegistration> {
  ValueNotifier<bool> visible = ValueNotifier(false);
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  final _formKey = GlobalKey<FormState>();
  FocusNode? fieldFocusNode;
  TextEditingController codeController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? manufacturer;
  String? model;
  String? fp;
  String? textFile;
  ExternalDir externalDir = ExternalDir();
  late String uniqId;
  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (Platform.isAndroid) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
        manufacturer = deviceData["manufacturer"];
        model = deviceData["model"];
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'manufacturer': build.manufacturer,
      'model': build.model,
    };
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deletemenu();
    initPlatformState();
  }

  deletemenu() async {
    print("delete");
    // await OrderAppDB.instance.deleteFromTableCommonQuery('menuTable', "");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        // backgroundColor: ColorThemeComponent.appbar,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorThemeComponent.appbar,
          elevation: 0,
        ),
        body: InkWell(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Consumer<RegistrationController>(
              builder: (context, value, child) {
                return Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          // color: ColorThemeComponent.appbar,
                          // borderRadius: BorderRadius.only(
                          //     //Edit the shape here
                          //     bottomLeft: Radius.circular(30),
                          //     bottomRight: Radius.circular(30)),
                          boxShadow: [
                            BoxShadow(
                              color: ColorThemeComponent.appbar,
                              spreadRadius: 40,
                              blurRadius: 0,
                              // offset: Offset(0, 3), //Offset of the shadow
                            ),
                          ],
                        ),
                        height: size.height * 0.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding: const EdgeInsets.only(left:18.0),
                            //   child: Text("Registration", style: GoogleFonts.acme(
                            //                 // textStyle:
                            //                 //     Theme.of(context).textTheme.bodyText2,
                            //                 fontSize: 24,
                            //                 // fontWeight: FontWeight.bold,
                            //                 color: ColorThemeComponent.loginReg),),
                            // ),
                          ],
                        ),
                      ),
                      Container(
                        height: size.height,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          color: ColorThemeComponent.loginReg,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.15,
                            ),
                            customTextField("Company key", codeController,
                                "company key", context),
                            customTextField("Phone number", phoneController,
                                "phone", context),
                            ValueListenableBuilder(
                                valueListenable: visible,
                                builder: (BuildContext context, bool v,
                                    Widget? child) {
                                  print("value===${visible.value}");
                                  return Visibility(
                                    visible: v,
                                    child: Text(
                                      "Please Enter Valid Phone No",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  );
                                }),
                            SizedBox(
                              height: size.height * 0.07,
                            ),
                            Container(
                              width: size.width * 0.45,
                              height: size.height * 0.06,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    String deviceInfo =
                                        "$manufacturer" + '' + "$model";
                                    print("device info-----$deviceInfo");
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => LoginPage()),
                                    // );

                                    // await OrderAppDB.instance
                                    //     .deleteFromTableCommonQuery('menuTable', "");
                                    // if (codeController.text == null ||
                                    //     codeController.text.isEmpty) {
                                    //   visible.value = true;
                                    // } else {
                                    //   visible.value = false;
                                    // FocusScope.of(context)
                                    //     .requestFocus(FocusNode());
                                    if (_formKey.currentState!.validate()) {
                                      String tempFp1 =
                                          await externalDir.fileRead();
                                      // String? tempFp1=externalDir.tempFp;

                                      // if(externalDir.tempFp==null){
                                      //    tempFp="";
                                      // }
                                      print("tempFp---${tempFp1}");
                                      // textFile = await externalDir
                                      //     .getPublicDirectoryPath();
                                      // print("textfile........$textFile");

                                      Provider.of<RegistrationController>(
                                              context,
                                              listen: false)
                                          .postRegistration(
                                              codeController.text,
                                              tempFp1,
                                              phoneController.text,
                                              deviceInfo,
                                              context);
                                    }
                                    // }
                                  },
                                  label: Text(
                                    "Register",
                                    style: GoogleFonts.aBeeZee(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: ColorThemeComponent.loginReg),
                                  ),
                                  icon: value.isLoading
                                      ? Container(
                                          width: 24,
                                          height: 24,
                                          padding: const EdgeInsets.all(2.0),
                                          child: CircularProgressIndicator(
                                            color: ColorThemeComponent.loginReg,
                                            strokeWidth: 3,
                                          ),
                                        )
                                      : Icon(
                                          Icons.arrow_back,
                                          color: ColorThemeComponent.loginReg,
                                        ),
                                  style: ElevatedButton.styleFrom(
                                    primary: ColorThemeComponent.appbar,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          15), // <-- Radius
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget customTextField(String hinttext, TextEditingController controllerValue,
      String type, BuildContext context) {
    double topInsets = MediaQuery.of(context).viewInsets.top;
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.1,
      child: Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 16, right: 16),
          child: TextFormField(
            scrollPadding:
                EdgeInsets.only(bottom: topInsets + size.height * 0.3),
            keyboardType: type == "phone" ? TextInputType.number : null,
            style: TextStyle(
              color: Colors.black,
            ),
            // scrollPadding:
            //     EdgeInsets.only(bottom: topInsets + size.height * 0.34),
            controller: controllerValue,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.zero,
              prefixIcon: type == "company key"
                  ? Icon(
                      Icons.business,
                      color: ColorThemeComponent.appbar,
                    )
                  : Icon(
                      Icons.phone,
                      color: ColorThemeComponent.appbar,
                    ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: ColorThemeComponent.appbar,
                  width: 1.0,
                ),
                borderRadius: BorderRadius.circular(20.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(
                  color: ColorThemeComponent.appbar,
                  width: 1.0,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.red,
                ),
              ),
              errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  borderSide: BorderSide(
                    width: 1,
                    color: Colors.red,
                  )),
              labelText: hinttext.toString(),
              labelStyle: TextStyle(
                fontSize: 15,
                color: ColorThemeComponent.appbar,
                // color: Colors.grey[700],
              ),
            ),

            // hintStyle: TextStyle(
            //   fontSize: 15,
            //   color: ColorThemeComponent.appbar,
            // ),
            // hintText: hinttext.toString()),
            validator: (text) {
              if (text == null || text.isEmpty) {
                return 'Please Enter ${hinttext}';
              } else if (type == "phone" && text.length != 10) {
                return 'Please Enter Valid Phone No ';
              }
              return null;
            },
          )),
    );
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Do you want to exit from this app'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      );
    },
  );
}
