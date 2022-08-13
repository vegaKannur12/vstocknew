import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstock/components/externalDir.dart';
import 'package:vstock/model/barcodeScannerModel.dart';
import 'package:vstock/model/registrationModel.dart';
import 'package:vstock/services/dbHelper.dart';

import '../screen/3_scan_type.dart';

class BarcodeController extends ChangeNotifier {
  ExternalDir externalDir = ExternalDir();
  String? comName;
  bool isLoading = false;

  ////////////////////////////
  insertintoTableScanlog(String? _barcodeScanned, String? formattedDate,
      int count, int page_id, String type) async {
    print("enterd insertion section-----");
    BarcodeScannerModel barcodeModel = BarcodeScannerModel();
    for (var item in barcodeModel.data!) {
      // var res = await VstockDB.instance.compareScannedbarcode(formattedDate!,1,page_id,type,"");

    }
    // print("res----${res}");
    notifyListeners();
  }
}
