import 'package:flutter/material.dart';
import '../constants/app_dimensions.dart';

extension ContextX on BuildContext {
  bool get isWide =>
      MediaQuery.sizeOf(this).width >= AppDimensions.tabletBreakpoint;
}
