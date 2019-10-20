import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {

  final String buttonText;
  final Function onPressed;

  RoundButton({this.buttonText, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5.0,
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      color: Colors.black,
      child: MaterialButton(
        minWidth: 200.0,
        child: Text(buttonText, style: TextStyle(fontSize: 20.0, color: Colors.white),),
        onPressed: onPressed,
      )

    );
  }
}