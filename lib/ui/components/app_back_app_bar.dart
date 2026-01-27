import 'package:flutter/material.dart';

PreferredSizeWidget buildBackAppBar(
  BuildContext context, {
  String? title,
}) {
  final canPop = Navigator.of(context).canPop();
  return AppBar(
    title: title != null && canPop ? Text(title) : null,
    automaticallyImplyLeading: false,
    leading: canPop ? const BackButton() : null,
    toolbarHeight: canPop ? kToolbarHeight : 0,
  );
}
