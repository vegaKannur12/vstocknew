import 'dart:convert';

import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
          backgroundColor: Color.fromARGB(255, 0, 0, 0),
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
      body: Consumer(
        builder: (context, value, child) {
          Size size = MediaQuery.of(context).size;
          return Center(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: pick_file,
                    child: Container(
                      width: size.width * 0.4,
                      height: size.height * 0.04,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 28, 13, 31),
                            Color.fromARGB(255, 68, 164, 241)
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
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
        actions: [
          // IconButton(
          //     onPressed: () async {
          //       await VstockDB.instance.deleteAllRows();
          //     },
          //     icon: Icon(Icons.delete))
        ],
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
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          //SizedBox(height: size.height*0.03,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                  // width: size.width * 0.25,
                                  child:
                                      Text(snapshot.data![index]["barcode"])),
                              Container(
                                  // width: size.width * 0.3,
                                  child: Text(snapshot.data![index]["ean"])),
                              Container(
                                  // width: size.width * 0.3,/
                                  child:
                                      Text(snapshot.data![index]["product"])),
                              Container(
                                  // width: size.width * 0.3,
                                  child: Text(snapshot.data![index]["rate"]
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
                  });
            }
          }),
    );
  }
}
