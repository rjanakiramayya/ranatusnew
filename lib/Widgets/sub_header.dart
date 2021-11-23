import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SubHeader extends StatelessWidget {
  final String title;
  const SubHeader(this.title);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.all(10),
      width: MediaQuery.of(context).size.height,
      color: Theme.of(context).primaryColor,
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }
}