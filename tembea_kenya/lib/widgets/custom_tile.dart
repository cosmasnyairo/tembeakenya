import 'package:flutter/material.dart';

class CustomTile extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget leading;
  final Widget trailing;
  final bool isthreeline;
  final Function ontap;
  final EdgeInsets padding;

  const CustomTile({
    Key key,
    this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.isthreeline,
    this.ontap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: trailing,
      isThreeLine: isthreeline ?? false,
      contentPadding: padding,
      onTap: ontap,
    );
  }
}
