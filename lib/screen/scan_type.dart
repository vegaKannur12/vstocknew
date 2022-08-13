import 'package:flutter/material.dart';
import 'package:vstock/components/commonColor.dart';
import 'package:vstock/screen/tableList.dart';
import 'package:vstock/services/dbHelper.dart';

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
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(actions: [
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
      ], title: Text("Select Scan Type"), 
      backgroundColor: ColorThemeComponent.color4,
      ),
      drawer: Drawer(
        child: Container(
          child: Text("ghdfsh"),
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
                    // tileColor: tappedIndex == index
                    //     ? ColorThemeComponent.tappedtileColor
                    //     :  ColorThemeComponent.regButtonColor,
                    onTap: () async {
                      setState(() {
                        tappedIndex = index;
                      });
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => BarcodeScanner(
                      //             type: types[index],
                      //             // queryresult: queryresult,
                      //           )),
                      // );
                    },
                    title: Text(
                      types[index],
                      style: TextStyle(
                        // fontFamily: "fantasy",
                        fontSize: 20,
                        color: ColorThemeComponent.tileTextColor,
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
