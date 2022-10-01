import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstock/components/externalDir.dart';
import 'package:vstock/model/registrationModel.dart';
import 'package:vstock/services/dbHelper.dart';

import '../screen/3_scan_type.dart';

class RegistrationController extends ChangeNotifier {
  ExternalDir externalDir = ExternalDir();
  String? comName;
  bool isLoading = false;
  /////////////////////////////////////////////////////////////////////
  postRegistration(String company_code, String? fingerprints, String phoneno,
      String deviceinfo, BuildContext context) async {
    try {
      print("divuxe-----$deviceinfo");
      isLoading = true;
      notifyListeners();
      Uri url = Uri.parse("http://trafiqerp.in/ydx/send_regkey");
      Map<String, dynamic> body = {
        'company_code': company_code,
        'fcode': fingerprints,
        'deviceinfo': deviceinfo,
        'phoneno': phoneno
      };
      http.Response response = await http.post(
        url,
        body: body,
      );

      var map = jsonDecode(response.body);
      print("from post data ${map}");
      print('user id------------${map["UserId"]}');
      RegistrationModel regModel = RegistrationModel.fromJson(map);
      comName = regModel.companyName;
      print("com---$comName");
      // notifyListeners();

      // int uid = int.parse(map["UserId"].toString());
      // String fp=regModel.fp;
      //       await externalDir.fileWrite(fp!);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('companyId', regModel.companyId!);
      pref.setString('companyName', regModel.companyName!);

      var result = await VstockDB.instance.insertRegistrationDetails(
          company_code, deviceinfo, "free to scan", regModel);
      isLoading = false;
      notifyListeners();

      if (result > 0) {
        print("result-----$result");

        Navigator.push(
          context,
          PageRouteBuilder(pageBuilder: (_, __, ___) => ScanType()),
        );
      }

      notifyListeners();
      // return result;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ////////////////////////////

}
