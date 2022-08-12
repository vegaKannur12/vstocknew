// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:vstock/controller/registrationController.dart';


// class DeletePopup{
//     void _showDialog(BuildContext context, String type, int id) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           content: new Text("Are u sure! u want to delete?"),
//           actions: <Widget>[
//             ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: Text('cancel')),
//             ElevatedButton(
//               child: new Text("OK"),
//               onPressed: () {
//                 if (type == "all") {
//                   Provider.of<RegistrationController>(context, listen: false)
//                       .deleteAllFromTableScanLog();
//                 } else if (type == "single") {
//                   Provider.of<RegistrationController>(context, listen: false)
//                       .deleteFromTableScanlog(id);
//                 }

//                 // BarcodeScanlogDB.instance.deleteAllRows();
//                 // controller.add(true);
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }