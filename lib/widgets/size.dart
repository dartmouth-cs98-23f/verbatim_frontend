import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// NOT FULLY IMPLEMENTED YET (but added to most documents)

// This functions are responsible to make UI responsive across all the mobile devices.
// code logic from dhi wise

// Get window size
MediaQueryData mediaQueryData = MediaQueryData.fromView(ui.window);

const num WIDTH = 390;
const num HEIGHT = 844;
const num STATUS_BAR = 0;

///This extension is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
extension ResponsiveExtension on num {
  ///This method is used to get device viewport width.
  get _width {
    return mediaQueryData.size.width;
  }

  ///This method is used to get device viewport height.
  get _height {
    num statusBar = mediaQueryData.viewPadding.top;
    num bottomBar = mediaQueryData.viewPadding.bottom;
    num screenHeight = mediaQueryData.size.height - statusBar - bottomBar;
    return screenHeight;
  }

  ///This method is used to set padding/margin (for the left and Right side) & width of the screen or widget according to the Viewport width.
  double get h => ((this * _width) / WIDTH);

  ///This method is used to set padding/margin (for the top and bottom side) & height of the screen or widget according to the Viewport height.
  double get v => (this * _height) / (HEIGHT - STATUS_BAR);

  ///This method is used to set smallest px in image height and width
  double get adaptSize {
    var height = v;
    var width = h;
    return height < width ? height.toDoubleValue() : width.toDoubleValue();
  }

  ///set text font size according to Viewport
  double get fSize => adaptSize;
}

extension FormatExtension on double {
  /// Return a [double] value formatted according to provided fractionDigits
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}
