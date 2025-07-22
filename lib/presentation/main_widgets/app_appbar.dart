import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:svg_flutter/svg_flutter.dart';

class MyAppBar extends StatelessWidget {
  final String title;
  final Widget? trailing;
  final Function()? onTap;
  const MyAppBar({
    super.key, required this.title,
    this.trailing, this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 48,
      leading: GestureDetector(
        onTap: onTap ?? () => Navigator.of(context).pop(),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.transparent
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            "assets/additional_icons/arrow_left.svg",
            width: 16
          ),
        ),
      ),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: trailing != null ? [
        trailing!
      ] : null
    );
  }
}