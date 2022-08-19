import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

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
    result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result!.files.single.path!);
      print(file);
      setState(() {
        fileName = basename(file!.path);
      });
      // fileName = file!.path.split('/').last;
      print(fileName);
      final input = file!.openRead();
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
      body: Center(
        child: Column(
          children: [
            ElevatedButton(child: Text("pick csv"), onPressed: pick_file),
            Text(fileName.toString()),
            ElevatedButton(
                child: Text("show db "),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Show()),
                  );
                }),
          ],
        ),
      ),
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
          future: VstockDB.instance.selectCommonQuery("barcode","*",""),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading....");
            }
            if (snapshot.data == null) {
              // _isEnabled = false;
              return Center(
                child: Text("No Data"),
              );
            }
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
                                width: size.width * 0.25,
                                child: Text(snapshot.data![index]["name"])),
                            Container(
                                width: size.width * 0.3,
                                child: Text(snapshot.data![index]["place"])),
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
          }),
    );
  }
}
