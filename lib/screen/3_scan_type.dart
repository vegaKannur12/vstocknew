import 'package:flutter/material.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/screen/4_barcodeScan_list.dart';

class ScanType extends StatefulWidget {
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          title: Text("Select Scan Type"), 
          backgroundColor: ColorThemeComponent.color4,
          ),
      drawer: Drawer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.045,
                  ),
                  Container(
                    height: size.height * 0.1,
                    width: size.width * 1,
                    color: Color.fromARGB(255, 255, 255, 255),
                    child: Row(
                      children: [
                        SizedBox(
                          height: size.height * 0.07,
                          width: size.width * 0.03,
                        ),
                        Icon(
                          Icons.list_outlined,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Text(
                          "Menus",
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Color.fromARGB(255, 0, 0, 0),
                    indent: 20,
                    endIndent: 20,
                  ),
                  ListTile(
                    title: Text(
                      "Download",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: Container(
         height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("asset/wave2.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
            itemCount: types.length,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  // shape: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(15.0),
                  // ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    onTap: () async {
                      setState(() {
                        tappedIndex = index;
                      });
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScanListBarcode(
                                  type: types[index],
                                  // queryresult: queryresult,
                                )),
                      );
                    },
                    title: Text(
                      types[index],
                      style: TextStyle(
                        // fontFamily: "fantasy",
                        fontSize: 22,
                        color: ColorThemeComponent.tileTextColor2,
                        // color: tappedIndex == index
                        //     ? Colors.black
                        //     : Colors.white
                      ),
                    ),
                  ),
                ),
              );
            })),
      ),
    );
  }
}
