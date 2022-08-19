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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Select Scan Type",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        // backgroundColor: ColorThemeComponent.listclr,
        elevation: 0,
        leading:Builder(
                    builder: (context) => IconButton(
          icon: Icon(
            Icons.menu,
            color: ColorThemeComponent.color3,
          ),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      )),
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
                    color: ColorThemeComponent.listclr,
                    child: Row(
                      children: [
                        SizedBox(
                          height: size.height * 0.07,
                          width: size.width * 0.03,
                        ),
                        Icon(
                          Icons.list_outlined,
                          color: ColorThemeComponent.color3,
                        ),
                        SizedBox(width: size.width * 0.04),
                        Text(
                          "Menus",
                          style: TextStyle(
                              fontSize: 20, color: ColorThemeComponent.color3),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
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
                          "Download",
                          style: TextStyle(fontSize: 17),
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
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: AssetImage("asset/whiteb.png"),
            //     fit: BoxFit.cover,
            //   ),
            // ),
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
                            color: ColorThemeComponent.color3,
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
        ],
      ),
    );
  }
}
