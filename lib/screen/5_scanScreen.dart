import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/components/snackbar.dart';
import 'package:vstock/controller/barcodeController.dart';
import 'package:vstock/controller/registrationController.dart';
import 'package:vstock/model/barcodeScannerModel.dart';
import 'package:vstock/screen/3_scan_type.dart';
import 'package:vstock/screen/4_barcodeScan_list.dart';
import 'package:vstock/services/dbHelper.dart';

class ScanBarcode extends StatefulWidget {
  String type;
  ScanBarcode({required this.type});

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  SnackbarCommon snackbr = SnackbarCommon();
  DateTime now = DateTime.now();
  String? formattedDate;
  bool validation = true;
  List s = [];
  List<Data>? result;
  QRViewController? controller;
  // String _barcodeScanned = "";
  bool _scanCode = false;
  // int count = 0;
  int countInt = 1;
  int c = 0;
  TextEditingController _textController = TextEditingController();
  TextEditingController _barcodeText = TextEditingController();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(
        "jdhjhdjkhjdh----${Provider.of<BarcodeController>(context, listen: false).barcodeScanned}");
    // c = int.parse(
    //           Provider.of<BarcodeController>(context, listen: false).count);
  }

  @override
  Widget build(BuildContext context) {
    double topInsets = MediaQuery.of(context).viewInsets.top;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // resizeToAvoidBottomInset: false,

      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        actions: [
          TextButton(
              onPressed: () {
                Provider.of<BarcodeController>(context, listen: false)
                    .getDataFromScanLog();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScanListBarcode(
                            type: widget.type, comName: "",

                            // queryresult: queryresult,
                          )),
                );
              },
              child: Text(
                "View List",
                style: TextStyle(
                    fontSize: 18,
                    color: ColorThemeComponent.appbar,
                    fontWeight: FontWeight.bold),
              ))
        ],
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: ColorThemeComponent.color4,
            ),
            onPressed: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ScanType(

                        // queryresult: queryresult,
                        )),
              );
            }),
        backgroundColor: ColorThemeComponent.color3,
      ),
      body: SingleChildScrollView(
        // offset: Offset(0.0, -0.5 * MediaQuery.of(context).viewInsets.bottom),
        child: Consumer<BarcodeController>(
          builder: (context, value, child) {
            return Container(
              height: size.height * 0.75,
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(top: 10, right: 20, left: 20),
                      child:
                          QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 58.0),
                            child: Text(
                              "Barcode  : ",
                              style: GoogleFonts.aBeeZee(
                                  textStyle: TextStyle(
                                      fontSize: 20,
                                      color: ColorThemeComponent.gradclr1,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                          // if (widget.type == "2" || widget.type == "4")
                          //   Flexible(
                          //     child: Container(
                          //       // height: size.height * 0.05,
                          //       // width: size.width * 0.1,
                          //       child: TextFormField(
                          //         style: TextStyle(
                          //             fontSize: 19,
                          //             fontWeight: FontWeight.bold),
                          //         controller: _barcodeText,
                          //         decoration: InputDecoration(
                          //           border: InputBorder.none,
                          //         ),
                          //         // decoration: In,
                          //       ),
                          //     ),
                          //   ),
                          // if (widget.type == "1" || widget.type == "3")
                          Container(
                            //  height: size.height*0.057,
                            child: Center(
                                child: Text(
                              value.barcodeScanned == null ||
                                      value.barcodeScanned.isEmpty
                                  ? "scan a code"
                                  : value.barcodeScanned.toString(),
                              style: TextStyle(
                                  fontSize: 19, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.02,
                      ),
                      value.selectedList
                          ? value.listSelected != null &&
                                  value.listSelected.length > 0
                              ? Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      left: 23,
                                      right: 33,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      // children: [Text(value.listSelected.toString())],
                                      children: [
                                        Flexible(
                                            child: Text(
                                          value.listSelected["barcode"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        )),
                                        Flexible(
                                            child: Text(
                                          value.listSelected["ean"],
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        )),
                                        Flexible(
                                            child: Text(
                                          value.listSelected["rate"].toString(),
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                        ))
                                      ],
                                    ),
                                  ),
                                )
                              : Container()
                          : Container(),
                      if (widget.type == "1" || widget.type == "3")
                        Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.02,
                            ),
                            GestureDetector(
                              onTap: () {
                                Provider.of<BarcodeController>(context,
                                        listen: false)
                                    .setSelectedList(false);
                                Provider.of<BarcodeController>(context,
                                        listen: false)
                                    .listSelected = {};
                                Provider.of<BarcodeController>(context,
                                        listen: false)
                                    .getDataFromScanLog();

                                // controller!.resumeCamera();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ScanListBarcode(
                                            type: widget.type, comName: "",

                                            // queryresult: queryresult,
                                          )),
                                );
                              },
                              child: Container(
                                height: size.height * 0.08,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 1,
                                    color: Color(0xFF424242),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    value.count1.toString(),
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.red),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      //  SizedBox(height: 50,),
                      //  widget.type=="1"? ElevatedButton(onPressed: () {}, child: Text("Click")):Container(),
                      if (widget.type == "2" || widget.type == "4")
                        Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: size.width * 0.2,
                              // height: size.height * 0.06,
                              child: Center(
                                child: TextFormField(
                                  scrollPadding: EdgeInsets.only(
                                      bottom: topInsets + size.height * 0.3),
                                  inputFormatters: [
                                    // only accept letters from 0 to 9
                                    FilteringTextInputFormatter(
                                        RegExp(r'[0-9]'),
                                        allow: true)
                                    // Using for Text Only ==>    (RegExp(r'[a-zA-Z]'))
                                  ],
                                  keyboardType: TextInputType.number,
                                  controller: _textController,
                                  onFieldSubmitted: (val) {
                                    value.barcodeScanned = val;
                                    print(
                                        "value----${val} --- ${value.barcodeScanned}");
                                  },
                                  decoration: InputDecoration(hintText: "1"),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: size.height * 0.03,
                            ),
                            Container(
                              height: size.height * 0.045,
                              width: size.width * 0.3,
                              color: Colors.transparent,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: ColorThemeComponent.appbar,
                                  padding: const EdgeInsets.all(0.0),
                                  elevation: 0,
                                ),
                                onPressed: value.buttonEnable
                                    ? () async {
                                        Provider.of<BarcodeController>(context,
                                                listen: false)
                                            .setbuttonEnable(false);

                                        if (_textController.text.isEmpty ||
                                            _textController.text == null) {
                                          print(" empty");
                                          countInt = 1;
                                          print("count int--${countInt}");
                                        }

                                        if (_textController.text.isNotEmpty ||
                                            _textController.text != null) {
                                          print("not empty");
                                          countInt = int.tryParse(
                                                  _textController.text
                                                      .toString()) ??
                                              1;
                                          // int.parse(_textController.text.toString());
                                        }

                                        if (_barcodeText.text.isEmpty) {
                                          print("text empty");
                                          snackbr.showSnackbar(
                                              context, "Invalid Barcode!!!");
                                        }
                                        print(
                                            "save button------${_barcodeText.text}, ");

                                        if (_barcodeText.text.isNotEmpty) {
                                          if (widget.type == "2") {
                                            int qunatity;
                                            if (_textController.text == null ||
                                                _textController.text.isEmpty) {
                                              qunatity = 1;
                                            } else {
                                              qunatity = int.parse(
                                                  _textController.text);
                                            }
                                            print(
                                                "value.listSelected----$qunatity--${value.listSelected}");
                                            int max = await VstockDB.instance
                                                .getMaxCommonQuery(
                                                    'tableScanLog',
                                                    'rowId',
                                                    " ");

                                            if (value.listSelected.length > 0) {
                                              print("yessvvvv");
                                              Provider.of<BarcodeController>(
                                                      context,
                                                      listen: false)
                                                  .insertintoTableScanlog(
                                                      value.listSelected[
                                                          "barcode"],
                                                      qunatity,
                                                      max,
                                                      2,
                                                      widget.type,
                                                      context,
                                                      validation,
                                                      s[0],
                                                      s[1],
                                                      true,
                                                      controller!);
                                              // value.listSelected = {};
                                              // Provider.of<BarcodeController>(
                                              //         context,
                                              //         listen: false)
                                              //     .setSelectedList(false);
                                            } else {
                                              Provider.of<BarcodeController>(
                                                      context,
                                                      listen: false)
                                                  .insertintoTableScanlog(
                                                      value.barcodeScanned,
                                                      qunatity,
                                                      max,
                                                      2,
                                                      widget.type,
                                                      context,
                                                      validation,
                                                      s[0],
                                                      s[1],
                                                      true,
                                                      controller!);
                                              // Provider.of<BarcodeController>(
                                              //         context,
                                              //         listen: false)
                                              //     .setSelectedList(false);
                                            }
                                          }
                                          if (widget.type == "4") {
                                            if (value.barcodeScanned != null ||
                                                value.barcodeScanned
                                                    .isNotEmpty) {
                                              // Provider.of<RegistrationController>(context,
                                              //         listen: false)
                                              //     .postData(
                                              //         _barcodeText.text,
                                              //         formattedDate,
                                              //         context,
                                              //         countInt,
                                              //         4,
                                              //         "API Scan with quantity");
                                            }
                                          }
                                        }

                                        _textController.clear();
                                        value.barcodeScanned = "";
                                        controller!.resumeCamera();
                                        Provider.of<BarcodeController>(context,
                                                listen: false)
                                            .setSelectedList(false);
                                      }
                                    : null,
                                child: Ink(
                                  child: Container(
                                    height: size.height * 0.05,
                                    width: size.width * 0.3,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Save",
                                      style: GoogleFonts.aBeeZee(
                                          textStyle: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      // style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                      SizedBox(
                        height: size.height * 0.08,
                      ),
                      // GestureDetector(
                      //   onLongPress: () {
                      //     print("pressed");
                      //     _cameraUpdate(true);
                      //   },
                      //   onLongPressEnd: (_) {
                      //     print("long press cancel");
                      //     _cameraUpdate(false);
                      //   },
                      //   child: Container(
                      //     child: ElevatedButton(
                      //       style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                      //       onPressed: () {},
                      //       child: Icon(
                      //         Icons.camera,
                      //         size: 50,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      // if (_scanCode) {/
      if (Provider.of<BarcodeController>(context, listen: false)
              .barcodeScanned ==
          scanData.code) {
        Future.delayed(Duration(seconds: 3), () async {
          Provider.of<BarcodeController>(context, listen: false)
              .barcodeScanned = "";
        });
      } else {
        setState(() {
          Provider.of<BarcodeController>(context, listen: false)
              .barcodeScanned = scanData.code!;
          _barcodeText.text =
              Provider.of<BarcodeController>(context, listen: false)
                  .barcodeScanned;
          // Provider.of<BarcodeController>(context, listen: false)
          //     .countFrombarcode();
          // c = int.parse(
          //     Provider.of<BarcodeController>(context, listen: false).count);
          // count = count + 1;
          // print("count====$count");
        });
        await FlutterBeep.beep(true);
        controller.pauseCamera();
        now = DateTime.now();
        print(DateTime.now());
        formattedDate = DateFormat('yyyy-MM-dd kk:mm').format(now);

        s = formattedDate!.split(" ");
        if (Provider.of<BarcodeController>(context, listen: false)
                    .barcodeScanned !=
                null &&
            Provider.of<BarcodeController>(context, listen: false)
                .barcodeScanned
                .isNotEmpty) {
          print(
              "barcode----------------${Provider.of<BarcodeController>(context, listen: false).barcodeScanned}");

          // await BarcodeDB.instance.barcodeTimeStamtttp(_barcodeScanned, formattedDate, count);
          //  await BarcodeScanlogDB.instance.barcodeTimeStamp(_barcodeScanned, formattedDate, count,1);
          int max = await VstockDB.instance
              .getMaxCommonQuery('tableScanLog', 'rowId', " ");
          List list = await VstockDB.instance.selectCommonQuery("barcode", "*",
              " where barcode='${_barcodeText.text.toUpperCase()}' OR ean='${_barcodeText.text.toUpperCase()}'");

          print("hai list-----$list");
          if (list.length == 0) {
            await FlutterBeep.playSysSound(200);
            Provider.of<BarcodeController>(context, listen: false)
                .setbuttonEnable(false);
            Provider.of<BarcodeController>(context, listen: false).setBarcode();
            buildPopup(controller, context);
          } else if (widget.type == "1") {
            // Provider.of<BarcodeController>(context, listen: false)
            //     .setListselected(list[0]);
            Provider.of<BarcodeController>(context, listen: false)
                .setCount(max);
            Provider.of<BarcodeController>(context, listen: false)
                .insertintoTableScanlog(
                    _barcodeText.text,
                    1,
                    max,
                    1,
                    widget.type,
                    context,
                    validation,
                    s[0],
                    s[1],
                    false,
                    controller);
          } else if (widget.type == "2" && list.length > 1) {
            // await FlutterBeep.beep(true);
            Provider.of<BarcodeController>(context, listen: false)
                .insertintoTableScanlog(
                    _barcodeText.text,
                    1,
                    max,
                    1,
                    widget.type,
                    context,
                    validation,
                    s[0],
                    s[1],
                    false,
                    controller);
          } else {
            Provider.of<BarcodeController>(context, listen: false)
                .setbuttonEnable(true);
            Provider.of<BarcodeController>(context, listen: false)
                .setListselected(list[0]);
          }

          if (widget.type == "3") {
            //  var result=await Provider.of<ProviderController>(context, listen: false).searchInTableScanLog(_barcodeScanned);
            //  print("result----${result}");

            // Provider.of<RegistrationController>(context, listen: false).postData(
            //     _barcodeScanned, formattedDate, context, 0, 3, "API Scan");
          }
          if (list.length == 1) {
            controller.resumeCamera();
          }
          // await BarcodeDB.instance
          //     .queryQtyUpdate(_barcodeScanned, formattedDate, count);
          // widget.strcontroller!.add(true);
          // _scanCode = false;
        }
      }
      // }
    });
  }
}

buildPopup(QRViewController controller, BuildContext context) {
  return showDialog(
      context: context,
      builder: (ctx) {
        Size size = MediaQuery.of(context).size;

        Future.delayed(Duration(seconds: 1), () {
          // if (map["err_status"] == 0) {
          //   getTransinfoList(context, osId, "delete");
          // }
          Navigator.of(ctx).pop(true);
          controller.resumeCamera();

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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                "Invalid Barcode",
                style: TextStyle(color: Colors.red),
              ),
            ),
            // Icon(
            //   Icons.close,
            //   color: Colors.red,
            // )
          ],
        ));
      });
}
