import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final Function ontap;
  final Size devicespecs;

  const ErrorPage({Key key, this.ontap, this.devicespecs}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(20),
      children: [
        SizedBox(height: devicespecs.height * 0.33),
        Text(
          'An Error Occured :(',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton.icon(
              onPressed: ontap,
              icon: Icon(Icons.refresh),
              label: Text("Retry")),
        )
      ],
    );
  }
}
