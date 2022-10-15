import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/screen/csvImport.dart';

class AlertCommon {
  Future buildPopupDialog(
    BuildContext context,
    Size size,
  ) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: Container(
              height: size.height * 0.18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Download options"),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  SizedBox(
                    width: size.width * 0.5,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 28, 13, 31),
                          Color.fromARGB(255, 68, 164, 241)
                        ]),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.transparent),
                        onPressed: () async {
                          Navigator.pop(context);
                        },
                        child: Text("API"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.015,
                  ),
                  SizedBox(
                    width: size.width * 0.5,
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [
                          Color.fromARGB(255, 28, 13, 31),
                          Color.fromARGB(255, 68, 164, 241)
                        ]),
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.transparent),
                        onPressed: () {
                          print("csvvvvv");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImportCsvtodb()),
                          );
                          // Navigator.of(context).pop();
                        },
                        child: Text("CSV"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ],
          );
        });
  }
}
