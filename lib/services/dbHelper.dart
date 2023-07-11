import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import "package:flutter/material.dart";
import 'package:vstock/components/commonColor.dart';

import 'package:vstock/controller/barcodeController.dart';
import 'package:vstock/model/barcodeScannerModel.dart';
import 'package:vstock/model/registrationModel.dart';

class VstockDB {
  static final VstockDB instance = VstockDB._init();
  static Database? _database;
  VstockDB._init();
  //////////////////////////////////////

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("Vstock.db");
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, filepath);
    return await openDatabase(
      path,
      version: 1, onCreate: _createDB,
      // onUpgrade: _upgradeDB
    );
  }

  Future _createDB(Database db, int version) async {
    ///////////////barcode store table ////////////////

    await db.execute('''
          CREATE TABLE tableScanLog (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            rowId INTEGER NOT NULL,
            barcode TEXT NOT NULL,
            date TEXT NOT NULL,
            time TEXT NOT NULL,
            qty INTEGER NOT NULL,
            page_id INTEGER NOT NULL,
            model TEXT,
            brand TEXT,
            description TEXT,
            rate REAL,
            size TEXT,
            product TEXT,
            pcode TEXT,
            ean TEXT
          )
          ''');
    //////////////////////////////////////////////////////////
    await db.execute('''
          CREATE TABLE barcode (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            barcode TEXT,
            ean TEXT ,
            product TEXT ,
            rate REAL
          )
          ''');
////////////// registration table ////////////
    await db.execute('''
          CREATE TABLE companyRegistrationTable (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cid TEXT NOT NULL,
            fp TEXT NOT NULL,
            os TEXT NOT NULL,
            type TEXT,
            app_type TEXT,
            cpre TEXT,
            ctype TEXT,
            cnme TEXT,
            ad1 TEXT,
            ad2 TEXT,
            ad3 TEXT,
            pcode TEXT,
            land TEXT,
            mob TEXT,
            em TEXT,
            gst TEXT,
            ccode TEXT,
            scode TEXT,
            msg TEXT
          )
          ''');
  }

//   ///////////////////////////////////////////////
  Future insertRegistrationDetails(RegistrationData data) async {
    final db = await database;
    var query1 =
        'INSERT INTO companyRegistrationTable(cid, fp, os, type, app_type, cpre, ctype, cnme, ad1, ad2, ad3, pcode, land, mob, em, gst, ccode, scode, msg) VALUES("${data.cid}", "${data.fp}", "${data.os}","${data.type}","${data.apptype}","${data.c_d![0].cpre}", "${data.c_d![0].ctype}", "${data.c_d![0].cnme}", "${data.c_d![0].ad1}", "${data.c_d![0].ad2}", "${data.c_d![0].ad3}", "${data.c_d![0].pcode}", "${data.c_d![0].land}", "${data.c_d![0].mob}", "${data.c_d![0].em}", "${data.c_d![0].gst}", "${data.c_d![0].ccode}", "${data.c_d![0].scode}", "${data.msg}" )';
    var res = await db.rawInsert(query1);
    print(query1);
    print("registered ----$res");
    return res;
  }

  ////////////////////////////////////////////////
  Future barcodeTimeStamp(
      String? date,
      String? time,
      int? qty,
      double rate,
      int page_id,
      String type,
      Data? barcodeData,
      String barcode,
      int rowId,
      String ean,
      String product,
      String? pcode,
      String? size,
      String? desc,
      String? brand,
      String? model) async {
    var query;
    print("entered insertion table--$type------$barcode---$ean----$product");
    final db = await database;

    if (type == "1" || type == "2") {
      print("type1 ");
      // if (ean == null || ean.isEmpty) {
      //   query =
      //       'INSERT INTO tableScanLog(rowId, barcode,date , time, qty, page_id, model, brand, description, rate, size, product, pcode, ean) VALUES($rowId, "${barcode}", "${date}", "${time}", ${qty}, ${page_id},"","","",$rate,"",,$product,"$pcode"","")';
      // } else {
      query =
          'INSERT INTO tableScanLog(rowId, barcode,date , time, qty, page_id, model, brand, description, rate, size, product, pcode, ean) VALUES($rowId, "${barcode}", "${date}", "${time}", ${qty}, ${page_id},"$model","$brand","$desc",$rate,"$size","$product","$pcode",$ean)';
      // }
    }
    if (type == "3" || type == "4") {
      query =
          'INSERT INTO tableScanLog(rowId, barcode,date, time, qty, page_id, model, brand, description, rate, size, product, pcode, ean) VALUES($rowId, "${barcodeData!.barcode}","${date}", "${time}", ${qty}, ${page_id},"${barcodeData.model}","${barcodeData.brand}","${barcodeData.description}","${barcodeData.rate}","${barcodeData.size}","${barcodeData.product}","${barcodeData.pcode}","${barcodeData.ean}")';
    }

    var res = await db.rawInsert(query);
    print("insert barcode------$query");
    print(res);
    return res;
  }

///////////////////////////////////////////////////////////////////
  Future barcodeinsertion(
      String ean, String barcode, String product, double rate) async {
    var query;
    print("entered insertion table");
    final db = await database;

    query =
        'INSERT INTO barcode(barcode, ean, product,rate) VALUES("${barcode}", "$ean" ,"$product",$rate)';

    var res = await db.rawInsert(query);
    print(query);
    print(res);
    return res;
  }

////////////////////////////////////////////////////////////////////
  Future close() async {
    final _db = await instance.database;
    _db.close();
  }

//   /////////////////////////get all rows////////////
  selectCommonQuery(String table, String field, String condition) async {
    Database db = await instance.database;
    print("query variables............$table....$field.....$condition");
    var query = "SELECT $field FROM $table $condition";
    print("select query----$query");
    var list = await db.rawQuery(query);
    print("dmks----$list");
    return list;
  }

  ///////////////////////////////////////
  // insertImportedData(List<List<dynamic>> user) async {
  //   final db = await database;
  //   print("user length----${user}");
  //   var buffer = new StringBuffer();
  //   var query;
  //   var res;
  //   // for (var item in user) {
  //   //   print(item);
  //   //   if(buffer.isNotEmpty){
  //   //      buffer.write(",\n");
  //   //   }
  //   //   buffer.write("('");
  //   //   buffer.write(item[0]);
  //   //   buffer.write("', '");
  //   //   buffer.write(item[1]);
  //   //   buffer.write("')");

  //   // }
  //   user.removeAt(0);
  //   print("user-------${user}");
  //   print("length===${user.length}");
  //   for (var item in user) {
  //     print(item);
  //     if (buffer.isNotEmpty) {
  //       buffer.write(",\n");
  //     }
  //     buffer.write("('");
  //     for (var i = 0; i < item.length; i++) {
  //       buffer.write(item[i]);
  //       if (i != item.length - 1) buffer.write("', '");
  //     }
  //     buffer.write("')");
  //   }
  //   print("buffer  ${buffer.toString()}");

  //   query = "INSERT  OR IGNORE INTO barcode ( barcode,ean,product,rate ) "
  //       " VALUES ${buffer.toString()}";
  //   res = await db.rawInsert(query);

  //   print(query);
  //   print("res------$res");
  //   // return res;
  // }
///////////////////////////////////////////////////////////////////////////////////////
  insertImportedData(List<List<dynamic>> user) async {
    final db = await database;

    print("user length----${user}");
    var buffer = new StringBuffer();
    var query;
    var res;
    buffer.clear();
    List<List<dynamic>> newList = [];
    bool flag = false;
    for (var item in user) {
      List<dynamic> tempList = [];

      for (int i = 0; i < item.length; i++) {
        if (item[i].toString() == null ||
            item[i].toString() == "" ||
            item[i].toString().isEmpty) {
          print("item[i]-------${item[i]}");
          flag = true;
        } else {
          flag = false;
          // tempList.add(item[i]);
          break;
        }
      }
      print("flag-----$flag");
      if (flag == false) {
        tempList = item;
        print("itemnjsnj--cz--$tempList");
        newList.add(tempList);
      }
    }

    print("newList------${newList.length}");
    // for (var item in user) {
    //   print(item);
    //   if(buffer.isNotEmpty){
    //      buffer.write(",\n");
    //   }
    //   buffer.write("('");
    //   buffer.write(item[0]);
    //   buffer.write("', '");
    //   buffer.write(item[1]);
    //   buffer.write("')");

    // }
    newList.removeAt(0);

    for (var item in newList) {
      print(item);
      if (buffer.isNotEmpty) {
        buffer.write(",\n");
      }
      buffer.write("('");
      for (var i = 0; i < item.length; i++) {
        buffer.write(item[i]);
        if (i != item.length - 1) buffer.write("', '");
      }
      buffer.write("')");
    }
    print("buffer  ${buffer.toString()}");
    try {
      query = "INSERT  OR IGNORE INTO barcode ( barcode,ean,product,rate ) "
          " VALUES ${buffer.toString()}";
      res = await db.rawInsert(query);
    } catch (e) {
      print("e---$e");
      return 0;
    }

    print(query);
    print("res------$res");

    return res;
  }

//////////////////////compare local db and scanned code/////////////
  compareScannedbarcode(
      String date,
      String time,
      int qty,
      int page_id,
      String type,
      String barcode,
      bool validation,
      BuildContext context,
      int rowId,
      bool buttonPressed,
      QRViewController controller) async {
    Database db = await instance.database;
    var response;
    print(
        "parameters----------------------$date------$time----$qty-----$type-----$barcode----$validation");
    List<Map<String, dynamic>> list = await selectCommonQuery("barcode", "*",
        " where barcode='${barcode.toUpperCase()}' OR ean='${barcode.toUpperCase()}'");
    if (validation) {
      print("list---$list");

      List<Map<String, dynamic>> listtimeStamp = await selectCommonQuery(
          "tableScanLog",
          "*",
          "where barcode='${barcode.toUpperCase()}' OR ean='${barcode.toUpperCase()}'");
      print("barcode----list---$listtimeStamp");

      if (list.length > 0) {
        print(
            "list param-------$barcode.toUpperCase()}----------------${list[0]["ean"]}-");
        if (list[0]["barcode"] == barcode.toUpperCase() ||
            list[0]["ean"] == barcode.toUpperCase()) {
          // controller.pauseCamera();
          if (list.length > 1) {
            // controller.resumeCamera();

            response = buildPopupDialog(context, list, date, time, page_id,
                type, qty, rowId, controller);
            // controller.resumeCamera();
          } else {
            print("yesss");
            // if (listtimeStamp.length > 0) {
            //   print("updation---");
            //   int updatedqty = listtimeStamp[0]["qty"] + qty;
            //   print("hszjj-----${listtimeStamp[0]["qty"].runtimeType}");
            //   response = await updateCommonQuery(
            //       "tableScanLog",
            //       "qty='${updatedqty}'",
            //       "where barcode='$barcode' or ean='$barcode' ");
            // } else {
            //   print("insertion-gggg--${list[0]["rate"].runtimeType}");
            // if (type == "Free Scan") {
            // Provider.of<BarcodeController>(context, listen: false)
            //     .setSelectedList(true);
            // controller.resumeCamera();
            Provider.of<BarcodeController>(context, listen: false)
                .setListselected(list[0]);
            if (buttonPressed) {
              Provider.of<BarcodeController>(context, listen: false)
                  .setSelectedList(false);
            }
            response = await barcodeTimeStamp(
                date,
                time,
                qty,
                list[0]["rate"],
                page_id,
                type,
                null,
                list[0]["barcode"],
                rowId,
                list[0]["ean"],
                list[0]["product"],
                list[0]["pcode"],
                list[0]["size"],
                list[0]["description"],
                list[0]["brand"],
                list[0]["model"]);

            // Provider.of<BarcodeController>(context, listen: false).count1=rowId;

            Provider.of<BarcodeController>(context, listen: false).response =
                response;

            // }
          }

          // }
        } else {
          return 0;
        }
      } else {
        // Provider.of<BarcodeController>(context, listen: false).barcodeScanned="";
        return 0;
      }
    } else {
      response = await barcodeTimeStamp(
          date,
          time,
          qty,
          0.0,
          page_id,
          type,
          null,
          barcode,
          rowId,
          list[0]["ean"],
          list[0]["product"],
          list[0]["pcode"],
          list[0]["size"],
          list[0]["description"],
          list[0]["brand"],
          list[0]["model"]);
    }

    print("response--ccc--$response");
    return response;
  }

/////////////////////////////////////////////////////////
  getListOfTables() async {
    Database db = await instance.database;
    var list = await db.query('sqlite_master', columns: ['type', 'name']);
    print(list);
    list.map((e) => print(e["name"])).toList();
    return list;
    // list.forEach((row) {
    //   print(row.values);
    // });
  }

////////////////////////////////////////////////////////
  countCommonQuery(String table, String? condition) async {
    print("conditions.............$table...$condition");
    String count = "0";
    Database db = await instance.database;
    final result =
        await db.rawQuery("SELECT COUNT(*) c FROM '$table' $condition");
    count = result[0]["c"].toString();
    print("result---count---$result");
    return count;
  }

//////////////////////////////////////////////////////////
  deleteFromTableCommonQuery(String table, String? condition) async {
    print("table--condition -$table---$condition");
    Database db = await instance.database;
    if (condition == null || condition.isEmpty || condition == "") {
      print("no condition");
      await db.delete('$table');
    } else {
      print("condition----$condition");

      await db.rawDelete('DELETE FROM "$table" WHERE $condition');
    }
  }
//////////////////////////////////////////////////////////
  // updateqtyAndRate(
  //   String table,
  //   String barcode,
  // ) async {
  //   Database db = await instance.database;
  //   // List<Map<String, dynamic>> listtimeStamp = await selectCommonQuery(
  //   //     "tableScanLog", "qty", "where barcode='$barcode' OR ean='$barcode'");
  //   print("condition for update...$listtimeStamp");
  //   var query = "UPDATE $table SET qty=";
  //   var res = await db.rawUpdate(query);
  //   print("query---$query");
  //   print("response-------$res");
  //   return res;
  // }

  updateCommonQuery(String table, String fields, String condition) async {
    Database db = await instance.database;
    var query = "UPDATE $table SET $fields $condition";
    print("updated query==$query");
    var res = await db.rawUpdate(query);
    return res;
  }

  // deleteFromTableCommonQuery(String table, String? condition) async {
  //   print("table--condition -$table---$condition");
  //   Database db = await instance.database;
  //   if (condition == null || condition.isEmpty || condition == "") {
  //     print("no condition");
  //     await db.delete('$table');
  //   } else {
  //     print("condition");

  //     await db.rawDelete('DELETE FROM "$table" WHERE $condition');
  //   }
  // }

/////////////////////////////////////////
//   Future<List<Map<String, dynamic>>> queryAllRows() async {
//     var a = "";
//     Database db = await instance.database;

//     List<Map<String, dynamic>> list =
//         await db.rawQuery('SELECT * FROM tableScanLog');
//     print("all data ${list}");
//     return list;
//   }

// //////////////////////////////////////////////
//   // deleteAllRows() async {
//   //   Database db = await instance.database;
//   //   await db.delete('tableScanLog');
//   // }
// ///////////////////////////////////////////
//   Future searchIn(String barcode) async {
//     Database db = await instance.database;

//     List<Map<String, dynamic>> list = await db
//         .rawQuery('SELECT * FROM tableScanLog WHERE barcode="${barcode}"');
//     if (list.isEmpty) {
//       return false;
//     } else {
//       return true;
//     }
//   }

//   //////////////////////////////////////
//   Future delete(int id) async {
//     Database db = await instance.database;
//     // print("id--${id}");
//     return await db.rawDelete("DELETE FROM 'tableScanLog' WHERE $id = id");
//   }

//   ////////////////////////////////////
//   ///
//   Future findCount() async {
//     Database db = await instance.database;
//     print(await db.rawQuery('SELECT count(*) FROM tableScanLog'));
//   }

//   /////////////////select company nme////////////////
//   Future<List<Map<String, dynamic>>> getCompanyDetails() async {
//     Database db = await instance.database;
//     List<Map<String, dynamic>> list =
//         await db.rawQuery('SELECT * FROM tableRegistration');
//     print("company details-- ${list}");
//     return list;
//   }

//   ////////////////////////////////////////////////////////
//   deleteAllRowsTableScanLog() async {
//     Database db = await instance.database;
//     await db.delete('tableScanLog');
//   }

//   /////////////////////////////////////////////////////////
//   getColumnnames() async {
//     Database db = await instance.database;
//     var list =
//         await db.query("SELECT barcode,time FROM 'tableScanLog' WHERE 1=0");
//     return list;
//   }

//   getListOfTables() async {
//     Database db = await instance.database;
//     var list = await db.query('sqlite_master', columns: ['type', 'name']);
//     print(list);
//     list.map((e) => print(e["name"])).toList();
//     return list;
//     // list.forEach((row) {
//     //   print(row.values);
//     // });
//   }

//   getTableData(String tablename) async {
//     Database db = await instance.database;
//     print(tablename);
//     var list = await db.rawQuery('SELECT * FROM $tablename');
//     print(list);
//     return list;
//     // list.map((e) => print(e["name"])).toList();
//     // return list;
//     // list.forEach((row) {
//     //   print(row.values);
//     // });
//   }

//   /////////////////////////////////////////////////
//   // Future<List<Map<String, dynamic>>> queryQtyUpdate(
//   //     String? barcode, String? time, int? qty) async {
//   //   Database db = await instance.database;
//   //   List<Map<String, Object?>> map = await db
//   //       .rawQuery('SELECT * FROM tableScanLog WHERE barcode="${barcode}"');
//   //   print("mappppppppppppp----------${map}");
//   //   if (map.isEmpty) {
//   //     var query =
//   //         'INSERT INTO tableScanLog(barcode, time, qty) VALUES("${barcode}", "${time}", ${qty})';
//   //     var res = await db.rawInsert(query);
//   //   } else {
//   //     var quantity = map[0]["qty"];
//   //     var id = map[0]["id"];
//   //     print("qty---------------------------${quantity}");
//   //     var updatedQty = int.parse(quantity.toString()) + 1;
//   //     var query = 'UPDATE tableScanLog SET qty=${updatedQty} WHERE id=${id} ';
//   //     var res = await db.rawInsert(query);
//   //   }
//   //   return map;
//   // }
//   //////////////////////////////////////////////////////

//   Future<int> queryQtyUpdate(int updatedQty, int id) async {
//     Database db = await instance.database;
//     print("upoadtes---${updatedQty}");
//     // var query =
//     //     'UPDATE tableScanLog SET qty=${updatedQty} WHERE id=${id}';
//     var res = await db
//         .rawUpdate('UPDATE tableScanLog SET qty=$updatedQty WHERE id=$id');
//     return res;
//   }

  Future buildPopupDialog(
      BuildContext context,
      List<Map<String, dynamic>> list,
      String date,
      String time,
      int page_id,
      String type,
      int qty,
      int rowId,
      QRViewController controller) async {
    controller.pauseCamera();
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext ctx) {
          return AlertDialog(
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: FittedBox(
                fit: BoxFit.contain,
                child: DataTable(
                    showCheckboxColumn: false,
                    columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          "Barcode",
                          style: GoogleFonts.aBeeZee(
                            textStyle: Theme.of(context).textTheme.bodyText2,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            // color: P_Settings.loginPagetheme,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Ean",
                          style: GoogleFonts.aBeeZee(
                            textStyle: Theme.of(context).textTheme.bodyText2,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            // color: P_Settings.loginPagetheme,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          "Rate",
                          style: GoogleFonts.aBeeZee(
                            textStyle: Theme.of(context).textTheme.bodyText2,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            // color: P_Settings.loginPagetheme,
                          ),
                        ),
                      ),
                    ],
                    rows: list
                        .map(
                          (list) => DataRow(
                            onSelectChanged: (value) {
                              // Future.delayed(const Duration(seconds: 4),
                              //     () async {
                              print('One second has passed.');

                              //
                              // });

                              if (type == "1") {
                                // Provider.of<BarcodeController>(context, listen: false)
                                //     .listSelected = list[index];
                                var response = barcodeTimeStamp(
                                    date,
                                    time,
                                    qty,
                                    list["rate"],
                                    page_id,
                                    type,
                                    null,
                                    list["barcode"],
                                    rowId,
                                    list["ean"],
                                    list["product"],
                                    list["pcode"],
                                    list["size"],
                                    list["description"],
                                    list["brand"],
                                    list["model"]);
                                Provider.of<BarcodeController>(context,
                                        listen: false)
                                    .setListselected(list);
                                Provider.of<BarcodeController>(context,
                                        listen: false)
                                    .setSelectedList(true);
                                Provider.of<BarcodeController>(context,
                                        listen: false)
                                    .response = response;
                              } else if (type == "2") {
                                Provider.of<BarcodeController>(context,
                                        listen: false)
                                    .setListselected(list);
                                Provider.of<BarcodeController>(context,
                                        listen: false)
                                    .setSelectedList(true);
                                Provider.of<BarcodeController>(context,
                                        listen: false)
                                    .setbuttonEnable(true);
                              }
                              controller.resumeCamera();

                              Navigator.pop(ctx);
                            },
                            cells: [
                              DataCell(
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${list['barcode'].toString()}',
                                        style: TextStyle(
                                          color: ColorThemeComponent.clrgrey,
                                          fontSize: 17,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DataCell(
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    list['ean'],
                                    style: TextStyle(
                                      color: ColorThemeComponent.clrgrey,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    list['rate'].toString(),
                                    // textAlign: TextAlign.end,
                                    style: TextStyle(
                                      color: ColorThemeComponent.clrgrey,
                                      fontSize: 17,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList()),
              ),
            ),
          );
        });
  }

  /////////////////////////////////////////////////////////////////////
  getMaxCommonQuery(String table, String field, String? condition) async {
    var res;
    int max;
    var result;
    Database db = await instance.database;
    print("condition---${condition}");
    if (condition == " ") {
      result = await db.rawQuery("SELECT * FROM '$table'");
    } else {
      result = await db.rawQuery("SELECT * FROM '$table' WHERE $condition");
    }
    // print("result max---$result");
    if (result != null && result.isNotEmpty) {
      print("if");

      if (condition == " ") {
        res = await db.rawQuery("SELECT MAX($field) max_val FROM '$table'");
      } else {
        res = await db.rawQuery(
            "SELECT MAX($field) max_val FROM '$table' WHERE $condition");
      }

      print('res[0]["max_val"] ----${res[0]["max_val"]}');
      // int convertedMax = int.parse(res[0]["max_val"]);
      max = res[0]["max_val"] + 1;
      print("max value.........$max");
      print("SELECT MAX($field) max_val FROM '$table' WHERE $condition");
    } else {
      print("else");
      max = 1;
    }
    print("max common-----$res");

    print(res);
    return max;
  }
}
