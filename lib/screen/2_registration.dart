import 'package:flutter/material.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/components/externalDir.dart';
import 'package:vstock/screen/scan_type.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isExpired = false;
  final _formKey = new GlobalKey<FormState>();
  TextEditingController controller1=TextEditingController();
  TextEditingController controller2=TextEditingController();

  ExternalDir externalDir = ExternalDir();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String uniqId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Color.fromARGB(255, 255, 255, 255),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/wave2.png"),
            fit: BoxFit.cover,
          ),
        ),
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 5, left: 20, right: 20),
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
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ColorThemeComponent.regButtonColor,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScanType(
                                  // companyName: result!.companyName.toString(),
                                  )),
                        );
                      },
                      child: Text(
                        "Register",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    // child: ElevatedButton(
                    //   onPressed: () async {
                    //     // Navigator.of(context).pop();
                    //     if (_formKey.currentState!.validate()) {
                    //       print(uniqId);
                    //       String tempFp1 = await externalDir.fileRead();
                    //       RegistrationModel? result =
                    //           await registrationController.postRegistration(
                    //               tempFp1, codeController.text, uniqId, "1");
                    //       if (result != null) {
                    //         SharedPreferences pref =
                    //             await SharedPreferences.getInstance();
                    //         pref.setString('companyId', result.companyId!);
                    //       }
                    //       // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    //       ScaffoldMessenger.of(context).removeCurrentSnackBar();
                    //       Navigator.of(context).pop();

                    //       Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => BarcodeType(
                    //                 // companyName: result!.companyName.toString(),
                    //                 )),
                    //       );
                    //     }
                    //   },
                    //   child: Text(widget.isExpired ? "Re-Register" : "Register"),
                    // ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget textForm(String type) {
    return TextFormField(
      controller:type=="Company code"? controller1:controller2,
      style: TextStyle(color: ColorThemeComponent.textFrmtext),
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
          borderSide: BorderSide(color: ColorThemeComponent.regButtonColor),
          //  when the TextFormField in focused
        ),
        icon: Icon(
          Icons.phone,
          color: ColorThemeComponent.regButtonColor,
        ),
        // hintText: 'What do people call you?',
        labelText: type,
        labelStyle: TextStyle(
          color: ColorThemeComponent.regButtonColor,
        ),
      ),
      validator: (text) {
        if (text == null || text.isEmpty) {
          return 'Please Enter Phone number';
        }
        return null;
      },
    );
  }
}
