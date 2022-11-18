import 'dart:convert' show utf8;
import 'dart:io';

import 'package:path/path.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstock/components/alertdialog.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/components/shareFile.dart';
import 'package:vstock/components/waveclipper.dart';
import 'package:vstock/screen/4_barcodeScan_list.dart';
import 'package:vstock/screen/5_scanScreen.dart';
import 'package:vstock/screen/csvImport.dart';
import 'package:vstock/screen/deleteAlert.dart';
import 'package:vstock/screen/msgDialogue.dart';
import 'package:vstock/screen/tableList.dart';
import 'package:vstock/services/dbHelper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';

import '../controller/barcodeController.dart';

class ScanType extends StatefulWidget {
  @override
  State<ScanType> createState() => _ScanTypeState();
}

class _ScanTypeState extends State<ScanType> {
  ShareFilePgm shareFilePgm = ShareFilePgm();
  DeleteAlert deleteAlert = DeleteAlert();
  List<Map<String, dynamic>> types = [
    {"id": "1", "value": "Free Scan"},
    {"id": "2", "value": "Free Scan with quantity"}
  ];
  late List<List<dynamic>> scan1;
  AlertCommon alert = AlertCommon();
  String? comName;
  int? tappedIndex;
  late List<Map<String, dynamic>> queryresult;

  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  // FilePickerResult? result;
  String? fileName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scan1 = List<List<dynamic>>.empty(growable: true);
    getComDetails();
  }

  getComDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    comName = pref.getString('companyName');
  }

  // pickCSVFile(BuildContext context) async {
  //   File? f;
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     withData: true,
  //     // allowedExtensions: ['csv'],
  //     // type: FileType.All,
  //   );
  //   if (result != null) {
  //     Provider.of<BarcodeController>(context, listen: false).setIsLoading(true);
  //     showDailogue(
  //         context,
  //         Provider.of<BarcodeController>(context, listen: false).isLoading,
  //         _keyLoader);
  //     PlatformFile file = result.files.first;
  //     f = File(result.files.single.path!);

  //     setState(() {
  //       fileName = basename(f!.path);
  //     });

  //     print("File Name...$fileName");
  //     print("file-----$file");
  //     final input = new File(f.path!).openRead();
  //     final fields = await input
  //         .transform(utf8.decoder)
  //         .transform(new CsvToListConverter())
  //         .toList();

  //     print("fields----------${fields}");

  //     await VstockDB.instance.deleteFromTableCommonQuery("barcode", "");

  //     var res = await VstockDB.instance.insertImportedData(fields);

  //     Provider.of<BarcodeController>(context, listen: false)
  //         .setIsLoading(false);
  //     Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
  //   }
  // }

  ////////////////////////////////////////////////////////
  showDailogue(BuildContext context, bool isLoading, GlobalKey key) {
    return showDialog(
        context: context,
        builder: (context) {
          Size size = MediaQuery.of(context).size;

          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: Colors.white,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Text(
                              "Loading .....",
                              style: TextStyle(color: Colors.black),
                            ),
                            CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          ]),
                    )
                  ]));
          // return AlertDialog(

          //     content: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: [
          //     Flexible(
          //       child: Text(
          //         isLoading ? "Loading ........." : "Completed ......",
          //         style: TextStyle(color: Colors.black),
          //       ),
          //     ),
          //     isLoading
          //         ? CircularProgressIndicator(
          //             color: Colors.green,
          //           )
          //         : Icon(
          //             Icons.done,
          //             color: Colors.green,
          //           )
          //   ],
          // ));

          // });
        });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: () => _onBackPressed(context),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                List<Map<String, dynamic>> list =
                    await VstockDB.instance.getListOfTables();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TableList(list: list)),
                );
              },
              icon: Icon(
                Icons.table_bar,
                color: ColorThemeComponent.color4,
              ),
            ),
          ],
          backgroundColor: ColorThemeComponent.appbar,
          elevation: 0.0,
          // iconTheme: IconThemeData(color: ColorThemeComponent.color3),
        ),
        // appBar: AppBar(
        //   elevation: 0,
        //   leading: IconButton(
        //       icon: Icon(
        //         Icons.arrow_back,
        //         color: ColorThemeComponent.color3,
        //       ),
        //       onPressed: () {
        //         Navigator.pop(context);
        //       }),
        //   title: Text(
        //     "Select Scan Type",
        //     style: GoogleFonts.aBeeZee(
        //         textStyle: TextStyle(
        //       fontSize: 20,
        //       color: ColorThemeComponent.color3,
        //     )),
        //   ),
        //   flexibleSpace: Container(
        //     decoration: const BoxDecoration(
        //       gradient: LinearGradient(
        //         begin: Alignment.bottomLeft,
        //         end: Alignment.topRight,
        //         colors: <Color>[Colors.purple, Colors.blue],
        //       ),
        //     ),
        //   ),
        //   backgroundColor: Color.fromARGB(255, 201, 62, 19),
        // ),
        drawer: Drawer(
          child: LayoutBuilder(
            builder: (ct, constraints) {
              return SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.09,
                    ),
                    Container(
                      color: ColorThemeComponent.appbar,
                      // decoration: const BoxDecoration(
                      //   color:ColorThemeComponent.appbar
                      //   // gradient: LinearGradient(
                      //   //   colors: [
                      //   //     Color.fromARGB(255, 28, 13, 31),
                      //   //     Color.fromARGB(255, 68, 164, 241)
                      //   //   ],
                      //   //   begin: Alignment.bottomLeft,
                      //   //   end: Alignment.topRight,
                      //   // ),
                      // ),
                      height: size.height * 0.1,
                      width: size.width * 1,
                      // color: ColorThemeComponent.gradclr1,
                      child: Row(
                        children: [
                          SizedBox(
                            height: size.height * 0.07,
                            width: size.width * 0.03,
                          ),
                          Icon(Icons.list_outlined, color: Colors.white),
                          SizedBox(width: size.width * 0.04),
                          Text(
                            "Menus",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pop(ct);
                        print("haiiii");
                        // alert.buildPopupDialog(
                        //   context,
                        //   size,
                        // );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImportCsvtodb()),
                        );
                      },
                      title: Row(
                        children: [
                          Icon(
                            Icons.download,
                            color: ColorThemeComponent.color4,
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Text(
                            "Import ( CSV )",
                            style: TextStyle(
                                fontSize: 17,
                                color: ColorThemeComponent.color4),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        shareFilePgm.onShareCsv(context, scan1, "");
                      },
                      title: Row(
                        children: [
                          Icon(
                            Icons.upload,
                            color: ColorThemeComponent.color4,
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Text(
                            "Export ( CSV )",
                            style: TextStyle(
                                fontSize: 17,
                                color: ColorThemeComponent.color4),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        deleteAlert.buildPopupDialog(
                            context, size, "tableScanLog", "Log Deleted !!!");
                      },
                      title: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: ColorThemeComponent.color4,
                            size: 19,
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Text(
                            "Delete ( Log )",
                            style: TextStyle(
                                fontSize: 17,
                                color: ColorThemeComponent.color4),
                          ),
                        ],
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        deleteAlert.buildPopupDialog(
                            context, size, "barcode", "Barcode Deleted !!!");
                      },
                      title: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: ColorThemeComponent.color4,
                            size: 19,
                          ),
                          SizedBox(
                            width: size.width * 0.03,
                          ),
                          Text(
                            "Delete ( Barcode )",
                            style: TextStyle(
                                fontSize: 17,
                                color: ColorThemeComponent.color4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            Container(
              width: double.infinity,
              height: size.height * 0.35,
              // color: Color.fromARGB(255, 230, 207, 0),
              child: Lottie.asset(
                'asset/barcode.json',
                // height: size.height*0.3,
                // width: size.height*0.3,
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: types.length,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 08),
                      child: Card(
                        elevation: 1,
                        color: ColorThemeComponent.loginReg,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          onTap: () async {
                            setState(() {
                              tappedIndex = index;
                            });
                            Provider.of<BarcodeController>(context,
                                    listen: false)
                                .getDataFromScanLog();
                            String count =
                                await VstockDB.instance.countCommonQuery(
                              'tableScanLog',
                              '',
                            );
                            print("jkzs-----$count");
                            Provider.of<BarcodeController>(context,
                                    listen: false)
                                .setCount(int.parse(count));
                            Provider.of<BarcodeController>(context,
                                    listen: false)
                                .setBarcode();
                            Provider.of<BarcodeController>(context,
                                    listen: false)
                                .setSelectedList(false);
                            Provider.of<BarcodeController>(context,
                                    listen: false)
                                .listSelected = {};
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScanBarcode(
                                        type: types[index]["id"],

                                        // queryresult: queryresult,
                                      )),
                            );
                          },
                          title: Row(
                            children: [
                              Image.asset(
                                'asset/barbox.png',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(
                                width: size.width * 0.04,
                              ),
                              Text(
                                types[index]["value"],
                                style: GoogleFonts.aBeeZee(
                                    textStyle: TextStyle(
                                  fontSize: 20,
                                  color: ColorThemeComponent.clrgrey,
                                )),
                                // style: TextStyle(
                                //   // fontFamily: "fantasy",
                                //   fontSize: 22,
                                //   color: ColorThemeComponent.color4,
                                //   // color: tappedIndex == index
                                //   //     ? Colors.black
                                //   //     : Colors.white
                                // ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  })),
            ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _onBackPressed(BuildContext context) async {
  return await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        // title: const Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Do you want to exit from this app'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Ok'),
            onPressed: () {
              exit(0);
            },
          ),
        ],
      );
    },
  );
}
