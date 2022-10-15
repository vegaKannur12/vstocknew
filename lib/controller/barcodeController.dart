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
  List<TextEditingController> qty = [];
  
  ExternalDir externalDir = ExternalDir();
  String? comName;
  bool isLoading = false;
  bool loadFile = false;
  String count = "0";
  SnackbarCommon snackbarCommon = SnackbarCommon();
  List<Map<String, dynamic>> scanList = [];
  ////////////////////////////////////////////////

  insertintoTableScanlog(
      String? _barcodeScanned,
      int qty,
      int count,
      int page_id,
      String type,
      BuildContext context,
      bool validation,
      String date,
      String time) async {
    var res;
    print(
        "enterd insertion section---$_barcodeScanned--$time--$qty---$type----$validation");

    res = await VstockDB.instance.compareScannedbarcode(
      date,  time, qty, page_id, type, _barcodeScanned!, validation);
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
    print("count----$count");
    notifyListeners();
  }

  /////////////////////////////////////////////////
  getDataFromScanLog() async {
    print("entered fetching section---");
    isLoading = true;
    var res =
        await VstockDB.instance.selectCommonQuery("tableScanlog", "*", " ");
    scanList.clear();
    for (var item in res) {
      scanList.add(item);
    }
    print("result from scanlog.............$scanList");

    qty = List.generate(
      scanList.length,
      (index) => TextEditingController(),
    );
    for (var i = 0; i < scanList.length; i++) {
      qty[i].text = scanList[i]["qty"].toString();
    }
    isLoading = false;
    notifyListeners();
    return scanList;
  }
}
