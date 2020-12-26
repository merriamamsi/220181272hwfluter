import 'package:flutter/material.dart';

class box extends StatefulWidget {
  bool checkBoxValue;

  box(this.checkBoxValue);

  @override
  _boxState createState() => _boxState(checkBoxValue);
}

class _boxState extends State<box> {
  bool checkBoxValue;

  _boxState(this.checkBoxValue);

  @override
  Widget build(BuildContext context) {
    return Checkbox(value:checkBoxValue,
        activeColor: Colors.green,
        onChanged:(bool newValue){
          setState(() {
           	checkBoxValue = newValue;
          });

        })
    ;
  }
}
