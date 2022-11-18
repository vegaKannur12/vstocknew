// import 'dart:convert';
import 'dart:convert' show utf8;
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/controller/barcodeController.dart';
import 'package:vstock/screen/msgDialogue.dart';

import 'package:vstock/services/dbHelper.dart';
// import 'package:saveimage/db_helper.dart';

class ImportCsvtodb extends StatefulWidget {
  const ImportCsvtodb({Key? key}) : super(key: key);

  @override
  State<ImportCsvtodb> createState() => _ImportCsvtodbState();
}

class _ImportCsvtodbState extends State<ImportCsvtodb> {
  MsgAlert msgAlert = MsgAlert();
  File? file;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  FilePickerResult? result;
  String? fileName;
  // bool? isLoading;
  double? _progressValue;
  List<List<dynamic>> data = [];

  pick_file(BuildContext context) async {
    result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );

    if (result != null) {
      file = File(result!.files.single.path!);
      // print("file contents-----------${contents.length}");

      setState(() {
        fileName = basename(file!.path);
      });
      print("File Name...$fileName");
      // fileName = file!.path.split('/').last;
      print(fileName);
      final input = file!.openRead();
      print("input......$input");
      ///////////////////testing////////////////////////////////////

      //////////////////////////////////////////////////////////////
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();

      print("fields----${data.length}");

      var res = await VstockDB.instance.insertImportedData(fields);

      print("result ftom db----$res");
      // if (res != null) {
      Provider.of<BarcodeController>(context, listen: false)
          .setIsLoading(false);

      // }
      // setState(() {
      //   _progressValue = _progressValue! + 0.2;
      //   // we "finish" downloading here
      //   if (_progressValue!.toStringAsFixed(1) == '1.0') {
      //     isLoading = false;
      //     // t.cancel();
      //     return;
      //   }
      // });
    } else {
      // User canceled the picker
    }
  }

  ////////////////////////////pick csv text//////////////////////////////////////
  pickCSVFile(BuildContext context, Size size) async {
    File? f;
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        // allowMultiple: false,
        // withData: true,
        allowedExtensions: ['csv'], type: FileType.custom);
    if (result != null) {
      Provider.of<BarcodeController>(context, listen: false).setIsLoading(true);
      showDailogue(
          context,
          Provider.of<BarcodeController>(context, listen: false).isLoading,
          _keyLoader,
          1);
      PlatformFile file = result.files.first;
      f = File(result.files.single.path!);

      setState(() {
        fileName = basename(f!.path);
      });

      print("File Name...$fileName");
      print("file-----$file");
      final input = new File(file.path!).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();

      print("fields----------${fields}");

      await VstockDB.instance.deleteFromTableCommonQuery("barcode", "");

      var res = await VstockDB.instance.insertImportedData(fields);

      Provider.of<BarcodeController>(context, listen: false)
          .setIsLoading(false);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      print("reyge----$res");
      if (res == 0) {
        print("errorr");
        return showDialog(
            context: context,
            builder: (ctx) {
              Size size = MediaQuery.of(context).size;

              Future.delayed(Duration(seconds: 3), () {
                // if (map["err_status"] == 0) {
                //   getTransinfoList(context, osId, "delete");
                // }
                Navigator.of(ctx).pop(true);

                // Navigator.of(context).push(
                //   PageRouteBuilder(
                //       opaque: false, // set to false
                //       pageBuilder: (_, __, ___) => TransactionPage()
                //       // OrderForm(widget.areaname,"return"),
                //       ),
                // );
              });
              return AlertDialog(
                  content: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      "Error on Insertion , Please Check the Csv File...",
                      // style: TextStyle(color: P_Settings.loginPagetheme),
                    ),
                  ),
                  Icon(
                    Icons.close,
                    color: Colors.red,
                  )
                ],
              ));
            });
      } else {
        msgAlert.buildPopupDialog(context, size, "Csv File Imported");
      }
    }
  }

  ////////////////////////////////////////dialogue show//////
  showDailogue(
      BuildContext context, bool isLoading, GlobalKey key, int content) {
    return showDialog(
        context: context,
        builder: (context) {
          Size size = MediaQuery.of(context).size;

          return new WillPopScope(
              onWillPop: () async => false,
              child: SimpleDialog(
                  key: key,
                  backgroundColor: content == 1 ? Colors.white : Colors.red,
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
                              content == 1
                                  ? "Loading .... "
                                  : "Error on Insertion",
                              style: TextStyle(
                                  color: content == 1
                                      ? Colors.black
                                      : Colors.white),
                            ),
                            content == 1
                                ? CircularProgressIndicator(
                                    color: Colors.green,
                                  )
                                : Container()
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

  //////////////////////////from asset////////////////////////////////////////////

  // loadString() async {
  //   final myData = await rootBundle.loadString("asset/LK.csv");
  //   List<List<dynamic>> csvTable = CsvToListConverter().convert(myData);
  //   print(csvTable);
  //   data = csvTable;
  //   print("data-----${data.length}");
  //   var res = await VstockDB.instance.insertImportedData(data);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // isLoading = false;
    _progressValue = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Download File Here ...",
          style: TextStyle(color: ColorThemeComponent.color4),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorThemeComponent.color4,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        // actions: [
        //   IconButton(
        //       onPressed: () async {
        //         await VstockDB.instance
        //             .deleteFromTableCommonQuery("barcode", "");
        //       },
        //       icon: Icon(
        //         Icons.delete,
        //         color: Colors.black,
        //       ))
        // ],
      ),
      floatingActionButton:
          Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        // FloatingActionButton(
        //   child: Text("csv"),
        //   onPressed: pick_file,
        //   heroTag: null,
        // ),
        // SizedBox(
        //   height: 10,
        // ),
        FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Show()),
            );
          },
          label: const Text('DB'),
          icon: const Icon(Icons.download),
          backgroundColor: ColorThemeComponent.appbar,
        ),
        // FloatingActionButton(
        //   child: Text("db"),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => Show()),
        //     );
        //   },
        //   heroTag: null,
        // ),
        SizedBox(
          height: 10,
        ),
        // FloatingActionButton.extended(
        //   onPressed: () {
        //     VstockDB.instance.deleteFromTableCommonQuery("barcode", "");
        //   },
        //   label: const Text(''),
        //   icon: const Icon(Icons.delete),
        //   backgroundColor: Color.fromARGB(255, 0, 0, 0),
        // ),
      ]),
      body: Consumer<BarcodeController>(
        builder: (context, value, child) {
          Size size = MediaQuery.of(context).size;
          return Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // await VstockDB.instance
                      //     .deleteFromTableCommonQuery("barcode", "");
                      // Provider.of<BarcodeController>(context, listen: false)
                      //     .setIsLoading(true);

                      pickCSVFile(context, size);

                      // loadString();
                    },
                    child: Container(
                      width: size.width * 0.4,
                      height: size.height * 0.04,
                      decoration:
                          BoxDecoration(color: ColorThemeComponent.appbar
                              // gradient: LinearGradient(
                              //   colors: [
                              //     Color.fromARGB(255, 28, 13, 31),
                              //     Color.fromARGB(255, 68, 164, 241)
                              //   ],
                              //   begin: Alignment.bottomLeft,
                              //   end: Alignment.topRight,
                              // ),
                              ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.file_present,
                            color: Colors.white,
                          ),
                          Text(
                            "Select File !!! ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),

                      // child: ElevatedButton.icon(
                      //   icon: Icon(Icons.file_present),

                      //   onPressed: pick_file,
                      //   label: Text("Select File !!! "),
                      // ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    fileName == null ? " " : fileName.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),

                  // value.isLoading
                  //     ? Column(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           CircularProgressIndicator(
                  //               // strokeWidth: 10,
                  //               // backgroundColor:
                  //               //     Color.fromARGB(255, 59, 209, 255),
                  //               // valueColor: new AlwaysStoppedAnimation<Color>(
                  //               //     Color.fromARGB(255, 7, 6, 6)),
                  //               // value: _progressValue,
                  //               ),
                  //           SizedBox(
                  //             height: size.height * 0.04,
                  //           ),
                  //           // Text('${(_progressValue! * 100).round()}%'),
                  //         ],
                  //       )
                  //     : Text("Press button for downloading",
                  //         style: TextStyle(fontSize: 25)),
                ],
              ),
            ),
          );
        },
      ),
      // body: Center(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     children: [
      //       ElevatedButton(
      //         child: Text("pick csv"),
      //         onPressed: pick_file,
      //       ),
      //       Text(fileName.toString()),
      //       ElevatedButton(
      //           child: Text("show db "),
      //           onPressed: () {
      //             Navigator.push(
      //               context,
      //               MaterialPageRoute(builder: (context) => Show()),
      //             );
      //           }),
      //     ],
      //   ),
      // ),
    );
  }
}

class Show extends StatefulWidget {
  const Show({Key? key}) : super(key: key);

  @override
  State<Show> createState() => _ShowState();
}

class _ShowState extends State<Show> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: FutureBuilder(
          future: VstockDB.instance.selectCommonQuery("barcode", "*", ""),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Text("Loading...."));
            }
            if (snapshot.data == null) {
              // _isEnabled = false;
              return Center(
                child: Text("No Data"),
              );
            } else {
              print("snapshot count-------${snapshot.data!.length}");

              return Column(
                children: [
                  Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.25,
                          child: Text("Barcode"),
                        ),
                        Container(
                          width: size.width * 0.2,
                          child: Text("Ean"),
                        ),
                        Container(
                          width: size.width * 0.3,
                          child: Text("Product"),
                        ),
                        Container(
                          width: size.width * 0.2,
                          child: Text("Rate"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                //SizedBox(height: size.height*0.03,),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: size.width * 0.25,
                                        child: Text(
                                            snapshot.data![index]["barcode"])),
                                    Container(
                                        width: size.width * 0.2,
                                        child:
                                            Text(snapshot.data![index]["ean"])),
                                    Container(
                                        width: size.width * 0.3,
                                        child: Text(
                                            snapshot.data![index]["product"])),
                                    Container(
                                        width: size.width * 0.2,
                                        child: Text(snapshot.data![index]
                                                ["rate"]
                                            .toString())),
                                    // Container(
                                    //   child: IconButton(
                                    //       onPressed: () {
                                    //         BarcodeScanlogDB.instance
                                    //             .delete(snapshot.data![index]["id"]);
                                    //         controller.add(true);
                                    //       },
                                    //       icon: Icon(Icons.delete)),
                                    // ),
                                    // Container(
                                    //   child: Text(snapshot.data![index]["qty"]
                                    //       .toString()),
                                    // )
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  ),
                ],
              );
            }
          }),
    );
  }
}
