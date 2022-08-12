import 'package:flutter/material.dart';
import 'package:vstock/components/externalDir.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool isExpired = false;
  final _formKey = new GlobalKey<FormState>();
  ExternalDir externalDir = ExternalDir();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late String uniqId;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 12, 12, 12),
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
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      fillColor: Color.fromARGB(255, 219, 134, 163),
                      focusColor: Colors.green,
                      icon: Icon(
                        Icons.business,
                        color: Colors.pink,
                      ),
                      // hintText: 'What do people call you?',
                      labelText: 'Company Code',
                      labelStyle: TextStyle(
                          color: Colors.pink, fontSize: 18 //<-- SEE HERE
                          ),
                    ),
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please Enter Company code';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Container(
                    height: size.height * 0.05,
                    width: size.width * 0.3,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.pink,
                      ),
                      onPressed: () {},
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
}
