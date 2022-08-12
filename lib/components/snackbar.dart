import 'package:flutter/material.dart';

class SnackbarCommon{
  showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color.fromARGB(255, 143, 17, 8),
        duration: const Duration(seconds: 1),
        content: Text('Expired!!!!'),
        action: SnackBarAction(
          label: 'Dissmiss',
          textColor: Colors.yellow,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}