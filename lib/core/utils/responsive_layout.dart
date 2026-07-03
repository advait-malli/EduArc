import 'package:flutter/material.dart';

class ResponsiveLayout {
  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 900;

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < mobileBreakpoint;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= mobileBreakpoint &&
      MediaQuery.of(context).size.width < desktopBreakpoint;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= desktopBreakpoint;

  // Get device type from constraints (for LayoutBuilder usage)
  static bool isMobileFromConstraints(BoxConstraints constraints) =>
      constraints.maxWidth < mobileBreakpoint;

  static bool isTabletFromConstraints(BoxConstraints constraints) =>
      constraints.maxWidth >= mobileBreakpoint &&
      constraints.maxWidth < desktopBreakpoint;

  static bool isDesktopFromConstraints(BoxConstraints constraints) =>
      constraints.maxWidth >= desktopBreakpoint;
}
