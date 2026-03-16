import 'package:flutter/widgets.dart';

// Shared spacing for pages rendered under the floating shell bottom bar.
const double kShellBottomBarClearance = 112;

double shellBottomContentPadding(BuildContext context, {double extra = 0}) {
  return MediaQuery.viewPaddingOf(context).bottom +
      kShellBottomBarClearance +
      extra;
}
