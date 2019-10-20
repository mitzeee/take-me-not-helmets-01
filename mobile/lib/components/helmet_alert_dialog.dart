import 'package:flutter/material.dart';

class HelmetDialog {
  showInfoDialog({BuildContext context, String messageText, String extraText}) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context,) {
        return AlertDialog(
          title: Text('Helmet scan unverified'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  height: 80,
                  width: 80,
                  child: Image(
                    image: AssetImage('assets/images/helmet_icon.png'),
                  ),
                ),
                Text(messageText),
                Text(extraText),
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
