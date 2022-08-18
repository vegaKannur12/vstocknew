import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vstock/components/commonColor.dart';

import 'package:vstock/controller/barcodeController.dart';

import 'package:vstock/components/shareFile.dart';

import 'package:vstock/screen/5_scanScreen.dart';
import 'package:vstock/screen/tableList.dart';
import 'package:vstock/services/dbHelper.dart';

import '../controller/registrationController.dart';

class ScanListBarcode extends StatefulWidget {
  String type;
  ScanListBarcode({required this.type});

  @override
  State<ScanListBarcode> createState() => _ScanListBarcodeState();
}

class _ScanListBarcodeState extends State<ScanListBarcode> {
  ShareFilePgm shareFilePgm = ShareFilePgm();
  @override
  void initState() {
    Provider.of<BarcodeController>(context, listen: false).getDataFromScanLog();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ColorThemeComponent.color4,
      appBar: AppBar(
        backgroundColor: ColorThemeComponent.color4,
        title: Text("company name"),
        actions: [
          // IconButton(
          //     onPressed: () {
          //       controller.add(true);
          //     },
          //     icon: Icon(Icons.refresh)),
          IconButton(
            onPressed: () async {
              List<Map<String, dynamic>> list =
                  await VstockDB.instance.getListOfTables();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TableList(list: list)),
              );
            },
            icon: Icon(Icons.table_bar),
          ),
          // IconButton(
          //   onPressed: () {
          //     _showDialog(context, "all", 0);
          //   },
          //   icon: Icon(Icons.delete),
          // ),

          PopupMenuButton(
            color: Color.fromARGB(255, 241, 235, 235),
            elevation: 20,
            enabled: true,
            onSelected: (value) async {
              // await createFolderInAppDocDir("csv");
              // print("attachment:${attachment}");
              // // print("attachment path:${attachment.path}");

              // setState(() {
              //   filepaths.add(attachment);
              // });

              // shareFilePgm.onShareCsv(context, scan1, widget.type);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Share csv"),
                value: "first",
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.pink,
            onPressed: () {
              Provider.of<BarcodeController>(context, listen: false)
                  .countFrombarcode();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScanBarcode(
                          type: widget.type,
                        )),
              );
            },
            child: Icon(Icons.scanner),
          ),
        ],
      ),
      body: Consumer<BarcodeController>(
        builder: (context, value, child) {
          return Stack(
            children: [
              Container(
                height: size.height,
                width: size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("asset/wave2.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                children: [
                  ListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        children: [
                          Text(
                            "Barcode",
                            style: TextStyle(
                                color: ColorThemeComponent.regButtonColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            "Date & Time",
                            style: TextStyle(
                                color: ColorThemeComponent.regButtonColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text(
                            "Qty",
                            style: TextStyle(
                                color: ColorThemeComponent.regButtonColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.scanList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Text(
                                  value.scanList[index]['barcode'],
                                  style: TextStyle(
                                      color: ColorThemeComponent.color3,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text(
                                  value.scanList[index]['time'],
                                  style: TextStyle(
                                      color: ColorThemeComponent.color3,
                                      fontSize: 15),
                                ),
                                Spacer(),
                                Text(
                                  value.scanList[index]['qty'].toString(),
                                  style: TextStyle(
                                      color: ColorThemeComponent.color3,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
      // body: Consumer<RegistrationController>(
      //   builder: (context, value, child) {
      //     return SingleChildScrollView(
      //       scrollDirection: Axis.vertical,
      //       child: value.listResult.length == 0
      //           ? Container(
      //               height: size.height * 0.8,
      //               child: Column(
      //                 mainAxisAlignment: MainAxisAlignment.center,
      //                 // crossAxisAlignment: CrossAxisAlignment.center,
      //                 children: [
      //                   Container(
      //                     child: Center(
      //                       child: Image.asset(
      //                         "asset/No.png",
      //                         color: ColorThemeComponent.color4,
      //                         height: size.height * 0.2,
      //                         width: size.width * 0.2,
      //                       ),
      //                     ),
      //                   ),
      //                   Text(
      //                     'No data!!!',
      //                     style: TextStyle(fontSize: 18),
      //                   )
      //                 ],
      //               ),
      //             )
      //           : Container(
      //               alignment:
      //                   widget.type == "Free Scan" || widget.type == "API Scan"
      //                       ? Alignment.center
      //                       : null,
      //               child: DataTable(
      //                 columnSpacing: widget.type == "Free Scan" ||
      //                         widget.type == "API Scan"
      //                     ? 40
      //                     : 30,
      //                 columns: [
      //                   // DataColumn(label: Text("id")),
      //                   DataColumn(label: Text("barcode")),
      //                   DataColumn(label: Text("time")),
      //                   if (widget.type == "Free Scan with quantity" ||
      //                       widget.type == "API Scan with quantity")
      //                     DataColumn(label: Text("qty")),
      //                   DataColumn(label: Text("")),
      //                   // DataColumn(label: Text("")),

      //                   // DataColumn(label: Text("id")),
      //                 ],
      //                 rows: value.listResult
      //                     .map(
      //                       (e) => DataRow(cells: [
      //                         // DataCell(Text(e["id"].toString())),
      //                         DataCell(Text(e["barcode"].toString())),
      //                         DataCell(Text(e["time"].toString())),
      //                         // DataCell(TextField()),
      //                         // if (widget.type == "Free Scan" ||
      //                         //     widget.type == "API Scan")
      //                         //   DataCell(Text(e["qty"].toString())),

      //                         if (widget.type == "Free Scan with quantity" ||
      //                             widget.type == "API Scan with quantity")
      //                           DataCell(
      //                               TextFormField(
      //                                 // controller: _controllertext,
      //                                 // initialValue: "${e["qty"]}",
      //                                 keyboardType: TextInputType.number,
      //                                 decoration: InputDecoration(
      //                                     border: InputBorder.none,
      //                                     hintText: "1"),
      //                                 // onChanged: (value) {
      //                                 //   Provider.of<ProviderController>(context,
      //                                 //           listen: false)
      //                                 //       .setUpdatedQty(value);
      //                                 // },
      //                                 onFieldSubmitted: (val) {
      //                                   Provider.of<RegistrationController>(
      //                                           context,
      //                                           listen: false)
      //                                       .updateTableScanLog(val, e["id"]);
      //                                   // Provider.of<ProviderController>(context,
      //                                   //         listen: false)
      //                                   //     .setUpdatedQty(val);
      //                                   // print('onSubmited $val');
      //                                 },
      //                               ),
      //                               showEditIcon: true),

      //                         DataCell(Container(
      //                           // width: 5,
      //                           child: IconButton(
      //                               onPressed: () {
      //                                 // _showDialog(context, "single", e["id"]);
      //                               },
      //                               icon: Icon(Icons.delete)),
      //                         )),
      //                         // DataCell(Container(
      //                         //   // width: 5,
      //                         //   child: IconButton(
      //                         //       onPressed: () {
      //                         //         print("edit clicked");
      //                         //         updatedQty=Provider.of<ProviderController>(context,
      //                         //                 listen: false).updatedQty;
      //                         //         print('updatedQty $updatedQty');

      //                         //         Provider.of<ProviderController>(context,
      //                         //                 listen: false)
      //                         //             .updateTableScanLog(updatedQty,e["id"]);
      //                         //       },
      //                         //       icon: Icon(Icons.done),
      //                         //       color: Colors.green,
      //                         //       ),
      //                         // )),
      //                         // DataCell(TextField())
      //                       ]),
      //                     )
      //                     .toList(),
      //               ),
      //             ),
      //     );
      //   },
      // ),
    );
  }
}
