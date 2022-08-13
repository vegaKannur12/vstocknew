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
  Future<RegistrationModel?> postRegistration(
      String fingerprints,
      String company_code,
      String device_id,
      String app_id,
      BuildContext context) async {
    try {
      print("divuxe-----$device_id");
      isLoading = true;
      notifyListeners();
      Uri url = Uri.parse("http://trafiqerp.in/ydx/send_regkey");
      Map<String, dynamic> body = {
        'company_code': company_code,
        // 'fcode': fingerprints,
        // 'deviceinfo': device_id,
        'device_id': device_id,
        'app_id': app_id,
      };
      http.Response response = await http.post(
        url,
        body: body,
      );
      isLoading = false;
      notifyListeners();
      var map = jsonDecode(response.body);
      print("from post data ${map}");
      print('user id------------${map["UserId"]}');
      RegistrationModel regModel = RegistrationModel.fromJson(map);
      comName = regModel.companyName;
      print("com---$comName");
      notifyListeners();

      // int uid = int.parse(map["UserId"].toString());
      // String fp=regModel.fp;
      //       await externalDir.fileWrite(fp!);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString('companyId', company_code);
      var result = await VstockDB.instance.insertRegistrationDetails(
          company_code, device_id, "free to scan", regModel);
      print("result-----$result");
      if (result > 0) {
        print("hekoooooo");
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ScanType(
                  // companyName: result!.companyName.toString(),
                  )),
        );
      }

      notifyListeners();
    } catch (e) {
      print(e);
      return null;
    }
  }

  ////////////////////////////
  insertintoTableScanlog(String? _barcodeScanned, String? formattedDate,
      int count, int page_id, String type) async {
    print("enterd insertion section-----");
    // var res = await VstockDB.instance.compareScannedbarcode(formattedDate!,1,page_id,type,,"");
    // print("res----${res}");
    notifyListeners();
  }
}
