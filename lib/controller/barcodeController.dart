import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstock/components/externalDir.dart';
import 'package:vstock/components/snackbar.dart';
import 'package:vstock/model/barcodeScannerModel.dart';
import 'package:vstock/model/registrationModel.dart';
import 'package:vstock/services/dbHelper.dart';

import '../screen/3_scan_type.dart';

class BarcodeController extends ChangeNotifier {
  List<TextEditingController> qty = [];
  bool buttonEnable = false;
  int count1 = 0;
  String barcodeScanned = "";
  var response;
  bool selectedList = false;
  ExternalDir externalDir = ExternalDir();
  String? comName;
  bool isLoading = false;
  bool loadFile = false;
  String count = "0";
  SnackbarCommon snackbarCommon = SnackbarCommon();
  List<Map<String, dynamic>> scanList = [];
  Map<String, dynamic> listSelected = {};
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
    String time,bool buttonPressd,QRViewController controller
  ) async {
    var res;
    print(
        "enterd insertion section---$count---$_barcodeScanned---$qty---$type----$validation");
    int max =
        await VstockDB.instance.getMaxCommonQuery('tableScanLog', 'rowId', " ");

    res = await VstockDB.instance.compareScannedbarcode(date, time, qty,
        page_id, type, _barcodeScanned!, validation, context, max,buttonPressd,controller);
    print("responsexxx----$response--");
    // if (type == "1") {
    //   if (response != null) {
    //     count1 = count;
    //     print("fjdxfn-----$count1");
    //     notifyListeners();
    //   }
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
    print("resfsfdfdf............$res");

    scanList.clear();
    for (var item in res) {
      scanList.add(item);
    }
    notifyListeners();
    print("result from scanlog.............$scanList");

    // qty = List.generate(
    //   scanList.length,
    //   (index) => TextEditingController(),
    // );
    // for (var i = 0; i < scanList.length; i++) {
    //   qty[i].text = scanList[i]["qty"].toString();
    // }
    isLoading = false;
    notifyListeners();
    return scanList;
  }

  setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  setCount(int c) {
    count1 = c;
    notifyListeners();
  }

  setbuttonEnable(bool enabled) {
    buttonEnable = enabled;
    notifyListeners();
  }

  setBarcode() {
    barcodeScanned = "";
    notifyListeners();
  }

  setListselected(Map<String, dynamic> list) {
    selectedList=true;
    listSelected = list;
    print("fkhzfihzd-----$listSelected");
    notifyListeners();
  }
  setSelectedList(bool sel){
    selectedList=sel;
    notifyListeners();
  }
}
