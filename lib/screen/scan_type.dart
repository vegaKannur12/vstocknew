import 'package:flutter/material.dart';

class ScanType extends StatefulWidget {
  const ScanType({Key? key}) : super(key: key);

  @override
  State<ScanType> createState() => _ScanTypeState();
}

class _ScanTypeState extends State<ScanType> {
  List<String> types = [
    "Free Scan",
    "Free Scan with quantity",
    "API Scan",
    "API Scan with quantity"
  ];
  int? tappedIndex;
  late List<Map<String, dynamic>> queryresult;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Select Scan Type"), backgroundColor: Colors.black),
    );
  }
}
