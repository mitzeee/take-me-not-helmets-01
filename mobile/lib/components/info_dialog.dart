import 'package:flutter/material.dart';

class InfoDialog {
  showInfoDialog({BuildContext context, String messageText, String title}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context,) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  height: 80,
                  width: 80,
                  child: Image(
                    image: AssetImage('assets/images/bike.png'),
                  ),
                ),
                Text(messageText),
                
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
