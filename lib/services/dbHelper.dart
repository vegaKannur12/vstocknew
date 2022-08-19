import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:vstock/model/barcodeScannerModel.dart';
import 'package:vstock/model/registrationModel.dart';

class VstockDB {
  static final VstockDB instance = VstockDB._init();
  static Database? _database;
  VstockDB._init();
  //////////////////////////////////////

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB("barcodeScan.db");
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
            barcode TEXT NOT NULL,
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
          CREATE TABLE tableRegistration (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            company_code TEXT NOT NULL,
            device_id TEXT NOT NULL,
            appType TEXT NOT NULL,
            company_id TEXT NOT NULL,
            company_name TEXT NOT NULL,
            user_id TEXT NOT NULL,
            expiry_date TEXT NOT NULL
          )
          ''');
  }

//   ///////////////////////////////////////////////
  Future insertRegistrationDetails(String company_code, String device_id,
      String appType, RegistrationModel rgModel) async {
    final db = await database;
    // print("userId*****${user_id}");
    // print(user_id.runtimeType);
    var query =
        'INSERT INTO tableRegistration(company_code, device_id, appType, company_id, company_name, user_id, expiry_date) VALUES("${company_code}", "${device_id}", "${appType}", "${rgModel.companyId}", "${rgModel.companyName}", "${rgModel.userId}", "${rgModel.expiryDate}")';
    var res = await db.rawInsert(query);
    print(query);
    print(res);
    return res;
  }

  ////////////////////////////////////////////////
  Future barcodeTimeStamp(String? time, int? qty, double rate, int page_id,
      String type, Data? barcodeData, String barcode) async {
    var query;
    print("entered insertion table");
    final db = await database;

    if (type == "Free Scan" || type == "Free Scan with quantity") {
      query =
          'INSERT INTO tableScanLog(barcode, time, qty, page_id, model, brand, description, rate, size, product, pcode, ean) VALUES("${barcode}", "${time}", ${qty}, ${page_id},"","","","","","","","")';
    }
    if (type == "API Scan" || type == "API Scan with quantity") {
      query =
          'INSERT INTO tableScanLog(barcode, time, qty, page_id, model, brand, description, rate, size, product, pcode, ean) VALUES("${barcodeData!.barcode}", "${time}", ${qty}, ${page_id},"${barcodeData.model}","${barcodeData.brand}","${barcodeData.description}","${barcodeData.rate}","${barcodeData.size}","${barcodeData.product}","${barcodeData.pcode}","${barcodeData.ean}")';
    }

    var res = await db.rawInsert(query);
    print(query);
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
    print("query----$query");
    var list = await db.rawQuery(query);
    print("dmks----$list");
    return list;
  }

//////////////////////compare local db and scanned code/////////////
  compareScannedbarcode(
      String time, int qty, int page_id, String type, String barcode) async {
    Database db = await instance.database;
    var response;
    List<Map<String, dynamic>> list =
        await selectCommonQuery("barcode", "*", "");
    print("list---$list");

    List<Map<String, dynamic>> listtimeStamp = await selectCommonQuery(
        "tableScanLog", "*", "where barcode='$barcode' OR ean='$barcode'");
    print("barcode----list---$listtimeStamp");
    if (list.length > 0) {
      if (list[0]["barcode"] == barcode || list[0]["ean"] == barcode) {
        if (listtimeStamp.length > 0) {
          print("updation---");
          int updatedqty = listtimeStamp[0]["qty"] + 1;
          print("hszjj-----${listtimeStamp[0]["qty"].runtimeType}");
          response = await updateCommonQuery(
              "tableScanLog",
              "qty='${updatedqty}'",
              "where barcode='$barcode' or ean='$barcode' ");
        } else {
          print("insertion---${list[0]["rate"].runtimeType}");

          response = await barcodeTimeStamp(
              time, qty, list[0]["rate"], page_id, type, null, barcode);
        }
      } else {
        return 0;
      }
    } else {
      return 0;
    }
    print("response----$response");
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
    var res = await db.rawUpdate(query);
    return res;
  }
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
}
