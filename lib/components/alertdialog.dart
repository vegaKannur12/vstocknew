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
                    height: size.height * 0.01,
                  ),
                  SizedBox(
                    width: size.width * 0.6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: ColorThemeComponent.tileTextColor),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      child: Text("API"),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  SizedBox(
                    width: size.width * 0.6,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: ColorThemeComponent.tileTextColor2),
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
