import 'dart:convert';

import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/controller/barcodeController.dart';

import 'package:vstock/services/dbHelper.dart';
// import 'package:saveimage/db_helper.dart';

class ImportCsvtodb extends StatefulWidget {
  const ImportCsvtodb({Key? key}) : super(key: key);

  @override
  State<ImportCsvtodb> createState() => _ImportCsvtodbState();
}

class _ImportCsvtodbState extends State<ImportCsvtodb> {
  File? file;
  FilePickerResult? result;
  String? fileName;

  pick_file() async {
    result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom,
    );
// FilePickerResult result = await FilePicker.platform.pickFiles(
//     allowedExtensions: ['csv'],
//     type: FileType.custom,
//   );
    if (result != null) {
      file = File(result!.files.single.path!);
      print(file);
      setState(() {
        fileName = basename(file!.path);
      });
      print("File Name...$fileName");
      // fileName = file!.path.split('/').last;
      print(fileName);
      final input = file!.openRead();
      print("input......$input");
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();
      print("fields----${fields}");

      await VstockDB.instance.insertImportedData(fields);
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Download File",
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
          onPressed: () async {
            // await VstockDB.instance.insertImportedData(fields);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Show()),
            );
          },
          label: const Text(
            'View File Data',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          icon: const Icon(
            Icons.view_comfy_outlined,
            color: Colors.black,
          ),
          backgroundColor: ColorThemeComponent.color3,
        ),

        SizedBox(
          height: 10,
        ),
      ]),
      body: Consumer(
        builder: (context, value, child) {
          Size size = MediaQuery.of(context).size;
          return Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: size.height * 0.05,
                    width: size.width * 0.5,
                    color: Colors.transparent,
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.file_present),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(0.0),
                        elevation: 0,
                      ),
                      onPressed: pick_file,
                      label: Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            Color.fromARGB(255, 28, 13, 31),
                            Color.fromARGB(255, 68, 164, 241)
                          ]),
                        ),
                        child: Container(
                          height: size.height * 0.05,
                          width: size.width * 0.6,
                          alignment: Alignment.center,
                          child: Text(
                            "Select File !!!",
                            style: GoogleFonts.aBeeZee(
                                textStyle: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            // style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Text(
                    fileName == null ? " " : fileName.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
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
        backgroundColor: ColorThemeComponent.color3,
        elevation: 0,
        title: Text(
          "DB data list",
          style: TextStyle(color: ColorThemeComponent.color4),
        ),
        actions: [
          // IconButton(
          //     onPressed: () async {
          //       await VstockDB.instance.deleteAllRows();
          //     },
          //     icon: Icon(Icons.delete))
        ],
      ),
      body: Stack(
        children: [
          Container(
            height: size.height * 0.05,
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Barcode",
                      style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                        fontSize: 18,
                        color: ColorThemeComponent.color4,
                      )),
                    ),
                    // Spacer(),
                    Text(
                      "Date & Time",
                      style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                        fontSize: 18,
                        color: ColorThemeComponent.color4,
                      )),
                    ),
                    // Spacer(),
                    Text(
                      "Qty",
                      style: GoogleFonts.aBeeZee(
                          textStyle: TextStyle(
                        fontSize: 18,
                        color: ColorThemeComponent.color4,
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Divider(
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Expanded(
              child: FutureBuilder(
                  future:
                      VstockDB.instance.selectCommonQuery("barcode", "*", ""),
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
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  //SizedBox(height: size.height*0.03,),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        // width: size.width * 0.25,
                                        child: Text(
                                          snapshot.data![index]["barcode"],
                                          style: GoogleFonts.aBeeZee(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: ColorThemeComponent.newclr,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // width: size.width * 0.3,
                                        child: Text(
                                          snapshot.data![index]["ean"],
                                          style: GoogleFonts.aBeeZee(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyText2,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: ColorThemeComponent.color4,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        // width: size.width * 0.3,/
                                        child: Text(
                                            snapshot.data![index]["product"]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 60),
                                        child: Container(
                                          // width: size.width * 0.3,
                                          child: Text(
                                              "\u{20B9}${snapshot.data![index]["rate"].toString()}"),
                                        ),
                                      ),
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
                          });
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
