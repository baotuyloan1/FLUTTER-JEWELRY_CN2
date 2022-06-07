import 'package:flutter/material.dart';

class PopUpMenu extends StatelessWidget {
  final List<PopupMenuEntry> menuList;
  final Widget? icon;
  const PopUpMenu({Key? key, required this.menuList, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: ((context) {
        return menuList;
      }),
      icon: icon,
    );
  }
}
