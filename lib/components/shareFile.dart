import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:async';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:vstock/services/dbHelper.dart';

class ShareFilePgm {
  List<String> filepaths = [];
  String text = '';
  File? csvReslt;

  // late String attachment;
  late String appDocumentsPath;
  List<Map<String, dynamic>> data = [];
  // late List<List<dynamic>> scan1;
  late List<List<dynamic>> scanResult;
  File? file;

  ////////////////////////////////////////////////////
  Future<List<List>> getData(List<List<dynamic>> scan1, String type) async {
    // scan1.clear();
    print("after clear ----${scan1}");
    List<String> columnNames;
    data = await VstockDB.instance.selectCommonQuery("tableScanLog", "*", " ");
    print("data----$data");
    // columnNames = await BarcodeScanlogDB.instance.getColumnnames();
    if (type == "Free Scan" || type == "API Scan") {
      columnNames = ["Barcode", "Date", "Time", "Qty"];
    } else {
      columnNames = ["Barcode", "Date", "Time", "Qty"];
    }
    scan1.add(columnNames);
    for (var i = 0; i < data.length; i++) {
      List<dynamic> row = List.empty(growable: true);
  
      row.add('${data[i]["barcode"]}');
      row.add('${data[i]["date"]}');
      row.add('${data[i]["time"]}');
      row.add('${data[i]["qty"]}');
      // type == "Free Scan" || type == "API Scan"
      //     ? null
      //     : row.add('${data[i]["qty"]}');

      scan1.add(row);
    }
    print("scan1 length--${scan1}");
    return scan1;
  }

  ////////////////////////////////////////////////////
  Future createFolderInAppDocDir(
      String folderName, List<List<dynamic>> scan1, String type) async {
    String filePath;
    //Get this App Document Directory
    print("scan1folder----${scan1}");
    scan1.clear();
    scanResult = await getData(scan1, type);
    final directory = await getExternalStorageDirectory();

    final Directory _appDocDir = await getApplicationDocumentsDirectory();
    if (await directory!.exists()) {
      appDocumentsPath = directory.path;
    } else {
      final Directory _appDocDirNewFolder =
          await directory.create(recursive: true);
      appDocumentsPath = _appDocDirNewFolder.path;
    }
    String csv =
        ListToCsvConverter(fieldDelimiter: ",", eol: "\n").convert(scanResult);
    File file =
        await File('${appDocumentsPath}/democopy.csv').create(recursive: true);
    // buffer.write(csv);
    // file.writeAsString(buffer.toString());
    file.writeAsString(csv);
    final contents = await file.readAsString();
    print("file content----${contents}");
    csvReslt = File('${directory.path}/democopy.csv');
  }

  ///////////////////////////////////////////////////

  void onShareCsv(BuildContext context, List<List> scan1, String type) async {
    print("scan1-xcx---${scan1}");
    filepaths.clear();
    print("after clear filepath length---${filepaths.length}");
    final box = context.findRenderObject() as RenderBox?;
    await createFolderInAppDocDir("csv", scan1, type);
    Directory? directory = await getExternalStorageDirectory();

    filepaths.add(csvReslt!.path);

    print("filepaths  length---${filepaths.length}");

    if (filepaths.isNotEmpty) {
      await Share.shareFiles(filepaths,
          text: null,
          subject: null,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: null,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }
}
