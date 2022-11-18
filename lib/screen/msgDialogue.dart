import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/screen/csvImport.dart';
import 'package:vstock/services/dbHelper.dart';

class MsgAlert {
  DateTime now = DateTime.now();
  TextEditingController controller = TextEditingController();

  Future buildPopupDialog(BuildContext context, Size size, String content) {
    controller.clear();
    String formattedDate = DateFormat('yyyyMMdd').format(now);
    return showDialog(
        context: context,
        builder: (ct) {
          Size size = MediaQuery.of(ct).size;
          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(ct).pop(true);
            Navigator.of(context).pop(true);

            // if (map["err_status"] == 0) {
            //   Navigator.push(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => MainDashboard(
            //           // formType: form_type,
            //           // type: "",
            //           ),
            //     ),
            //   );
            // }

            // Navigator.pop(context);
          });
          return AlertDialog(
              content: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  '$content ',
                  // style: TextStyle(color: P_Settings.loginPagetheme
                  // ),
                ),
              ),
              Icon(
                Icons.done,
                color: Colors.green,
              )
            ],
          ));
        });
  }
}
