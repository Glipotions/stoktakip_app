import 'package:flutter/material.dart';
import 'package:stoktakip_app/const/text_const.dart';

class MyContainerColumn extends StatelessWidget {
  final String? yazi;
  final IconData? icon;
  MyContainerColumn({this.yazi = '', this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 40,
          color: Colors.black54,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          yazi!,
          style: kBaslikStili,
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
