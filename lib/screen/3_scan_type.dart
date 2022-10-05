import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/components/waveclipper.dart';
import 'package:vstock/screen/4_barcodeScan_list.dart';
import 'package:vstock/screen/csvImport.dart';

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
  String? comName;
  int? tappedIndex;
  late List<Map<String, dynamic>> queryresult;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComDetails();
  }

  getComDetails() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    comName = pref.getString('companyName');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: ColorThemeComponent.color3),
      ),
      // appBar: AppBar(
      //   elevation: 0,
      //   leading: IconButton(
      //       icon: Icon(
      //         Icons.arrow_back,
      //         color: ColorThemeComponent.color3,
      //       ),
      //       onPressed: () {
      //         Navigator.pop(context);
      //       }),
      //   title: Text(
      //     "Select Scan Type",
      //     style: GoogleFonts.aBeeZee(
      //         textStyle: TextStyle(
      //       fontSize: 20,
      //       color: ColorThemeComponent.color3,
      //     )),
      //   ),
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //       gradient: LinearGradient(
      //         begin: Alignment.bottomLeft,
      //         end: Alignment.topRight,
      //         colors: <Color>[Colors.purple, Colors.blue],
      //       ),
      //     ),
      //   ),
      //   backgroundColor: Color.fromARGB(255, 201, 62, 19),
      // ),
      drawer: Drawer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.09,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 28, 13, 31),
                          Color.fromARGB(255, 68, 164, 241)
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    height: size.height * 0.1,
                    width: size.width * 1,
                    // color: ColorThemeComponent.gradclr1,
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
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImportCsvtodb()),
                      );
                    },
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
                          style: TextStyle(
                              fontSize: 17, color: ColorThemeComponent.color4),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        Icon(
                          Icons.upload,
                          color: ColorThemeComponent.color4,
                        ),
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        Text(
                          "Upload",
                          style: TextStyle(
                              fontSize: 17, color: ColorThemeComponent.color4),
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
            child: Column(
              children: [
                // SizedBox(
                //   height: size.height * 0.04,
                // ),
                Stack(
                  children: [
                    Container(
                      child: Stack(
                        children: <Widget>[
                          ClipPath(
                            clipper:
                                WaveClipper(), //set our custom wave clipper.
                            child: Container(
                              padding: EdgeInsets.only(
                                bottom: 50,
                              ),
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 28, 13, 31),
                                    Color.fromARGB(255, 68, 164, 241)
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                              ),
                              // color: Color.fromARGB(255, 201, 62, 19),
                              height: size.height * 0.27,
                              alignment: Alignment.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: types.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            elevation: 1,
                            color: Color.fromARGB(255, 255, 254, 252),
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
                                            comName: "",
                                            // queryresult: queryresult,
                                          )),
                                );
                              },
                              title: Row(
                                children: [
                                  Image.asset(
                                    'asset/barbox.png',
                                    width: 30.0,
                                    height: 30.0,
                                    fit: BoxFit.cover,
                                  ),
                                  SizedBox(
                                    width: size.width * 0.04,
                                  ),
                                  Text(
                                    types[index],
                                    style: GoogleFonts.aBeeZee(
                                        textStyle: TextStyle(
                                      fontSize: 20,
                                      color: ColorThemeComponent.clrgrey,
                                    )),
                                    // style: TextStyle(
                                    //   // fontFamily: "fantasy",
                                    //   fontSize: 22,
                                    //   color: ColorThemeComponent.color4,
                                    //   // color: tappedIndex == index
                                    //   //     ? Colors.black
                                    //   //     : Colors.white
                                    // ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      })),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
