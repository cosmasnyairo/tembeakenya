import 'package:flutter/material.dart';

class LicencesUsed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceheight = MediaQuery.of(context).size.height;
    return LicensePage(
      applicationIcon: Container(
        height: deviceheight * 0.2,
        padding: EdgeInsets.all(20),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/logo.png', fit: BoxFit.contain)),
      ),
      applicationName: 'Tembea Kenya',
      applicationVersion: 'Version 1.0.0',
    );
  }
}
