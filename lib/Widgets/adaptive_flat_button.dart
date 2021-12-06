import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveFlatButton extends StatelessWidget {
  final String text;
  final Function handler;
  final Color color;

  AdaptiveFlatButton(this.text, this.handler,[this.color = Colors.white]);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed:() => handler,
          )
        : FlatButton(
            textColor: Color(0xff020f72),
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            onPressed: () => handler,
          );
  }
}
