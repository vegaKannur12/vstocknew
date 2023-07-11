import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vstock/components/commonColor.dart';

import '../controller/barcodeController.dart';

class Report extends StatefulWidget {
  String title;
  String reportType;
  Report({required this.title, required this.reportType});

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorThemeComponent.appbar,
        title: Text(widget.title.toString()),
      ),
      body: Consumer<BarcodeController>(
        builder: (context, value, child) {
          return Column(
            children: [
              bodyData(size),
              Container(
                height: size.height * 0.05,
                width: double.infinity,
                color: Colors.yellow,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Total : ",
                      style: TextStyle(
                          fontSize: 19,
                          color: ColorThemeComponent.clrgrey,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 18.0),
                      child: Text(
                        "\u{20B9} ${value.sum}",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget bodyData(Size size) => Consumer<BarcodeController>(
        builder: (context, value, child) {
          print("valuee---cgcfgfcg---${value.scanList}");
          return Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(2),
              child: FittedBox(
                fit: BoxFit.fill,
                child: DataTable(
                  showBottomBorder: true,
                  dividerThickness: 1.0,
                  sortColumnIndex: 1,
                  sortAscending: true,
                  columns: <DataColumn>[
                    DataColumn(
                      label: Container(
                        width: size.width * 0.4,
                        child: Text(
                          widget.reportType == "1" ? "Product" : "Barcode",
                          style: GoogleFonts.aBeeZee(
                            textStyle: Theme.of(context).textTheme.bodyText2,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            // color: P_Settings.loginPagetheme,
                          ),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Qty",
                        style: GoogleFonts.aBeeZee(
                          textStyle: Theme.of(context).textTheme.bodyText2,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          // color: P_Settings.loginPagetheme,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        "Value",
                        style: GoogleFonts.aBeeZee(
                          textStyle: Theme.of(context).textTheme.bodyText2,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          // color: P_Settings.loginPagetheme,
                        ),
                      ),
                    ),
                  ],
                  rows: value.reportList
                      .map(
                        (list) => DataRow(
                          cells: [
                            DataCell(
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      width: size.width * 0.3,
                                      child: Text(
                                        widget.reportType == "1"
                                            ? '${list['product'].toString()}'
                                            : '${list['barcode'].toString()}',
                                        style: TextStyle(fontSize: 16),
                                      )),
                                  // list['ean'].toString() == null ||
                                  //         list['ean'].toString().isEmpty
                                  //     ? Container()
                                  //     : Text(
                                  //         '(${list['ean'].toString()})',
                                  //         style: TextStyle(fontSize: 12),
                                  //       ),
                                ],
                              ),
                            ),
                            DataCell(
                              Container(
                                  alignment: Alignment.center,
                                  child: Text(
                                    // "7464747.00",

                                    list["sum(qty)"].toString(),
                                    style: TextStyle(fontSize: 16),
                                  )),
                            ),
                            DataCell(
                              Container(
                                alignment: Alignment.center,
                                child: Text(
                                  // "746474.00",
                                  list["sum(qty*rate)"].toString(),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          );
        },
      );
}
