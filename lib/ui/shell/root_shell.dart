import 'package:flutter/material.dart';

class RootShell extends StatelessWidget {
  const RootShell({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.extendBody = false,
  });

  final Widget body;
  final Widget? bottomNavigationBar;
  final bool extendBody;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: extendBody,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
