import 'package:flutter/material.dart';

PreferredSizeWidget buildBackAppBar(
  BuildContext context, {
  String? title,
}) {
  final canPop = Navigator.of(context).canPop();
  return AppBar(
    title: title != null && canPop ? Text(title) : null,
    automaticallyImplyLeading: false,
    leading: canPop
        ? IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => Navigator.of(context).maybePop(),
          )
        : null,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    toolbarHeight: canPop ? kToolbarHeight : 0,
  );
}
