import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstock/components/externalDir.dart';
import 'package:vstock/components/snackbar.dart';
import 'package:vstock/model/barcodeScannerModel.dart';
import 'package:vstock/model/registrationModel.dart';
import 'package:vstock/services/dbHelper.dart';

import '../screen/3_scan_type.dart';

class BarcodeController extends ChangeNotifier {
  ExternalDir externalDir = ExternalDir();
  String? comName;
  bool isLoading = false;
  String count = "0";
  SnackbarCommon snackbarCommon = SnackbarCommon();
  List<Map<String, dynamic>> scanList = [];
  ////////////////////////////

  insertintoTableScanlog(
      String? _barcodeScanned,
      String? formattedDate,
      int qty,
      int count,
      int page_id,
      String type,
      BuildContext context) async {
    print("enterd insertion section---$_barcodeScanned--$formattedDate--$qty");
    var res = await VstockDB.instance.compareScannedbarcode(
        formattedDate!, qty, page_id, type, _barcodeScanned!);
    print("response----$res --${res.runtimeType}");

    if (res == 0) {
      snackbarCommon.showSnackbar(context, "Invalid Barcode!!!");
    } else {
      print("fjdxfn-----");
      // count = await VstockDB.instance.countCommonQuery("tableScanLog", "");
    }

    // BarcodeScannerModel barcodeModel=BarcodeScannerModel();

    // for(var item in barcodeModel.data!){

    // var res = await VstockDB.instance.compareScannedbarcode(formattedDate!,1,page_id,type,"");

    // }
    print("res----${res}");

    notifyListeners();
  }

  ////////////////////////////////////////////
  countFrombarcode() async {
    count = await VstockDB.instance.countCommonQuery("tableScanLog", "");
    notifyListeners();
  }

  /////////////////////////////////////////////////
  getDataFromScanLog() async {
    print("entered fetching section---");
    scanList = await VstockDB.instance.selectCommonQuery("tableScanlog","barcode,time"," ");
    print("result from scanlog.............$scanList");
    notifyListeners();
  }
}
