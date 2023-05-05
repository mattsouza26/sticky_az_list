import 'package:flutter/material.dart';

import '../enums.dart';
import '../typedef.dart';

class OverlayOptions {
  const OverlayOptions({
    this.showOverlay = true,
    this.style = const TextStyle(),
    this.width = 50,
    this.height = 50,
    this.shape = const CircleBorder(),
    this.background,
    this.offset = const Offset(0, 0),
    this.padding = const EdgeInsets.all(10),
    this.aligment = OverlayAligment.dynamic,
    this.overlayBuilder,
    this.specialSymbolBuilder,
  });

  /// Showing an overlay of the current icon when swiping across the sidebar.
  final bool showOverlay;

  /// The [TextStyle] of the overlay.
  final TextStyle? style;

  /// The width of the overlay.
  final double width;

  /// The height of the overlay.
  final double height;

  /// The [ShapeBorder] of the overlay.
  final ShapeBorder shape;

  /// Optional overlay background.
  final Color? background;

  /// Optional [Offset] of the overlay position.
  final Offset? offset;

  /// The padding of the overlay.
  final EdgeInsets padding;

  /// The [OverlayAligment] of the overlay.
  final OverlayAligment aligment;

  /// Builder function for the overlay.
  final SymbolBuilder? overlayBuilder;

  /// Builder function for the special symbol overlay.
  final SymbolNullableStateBuilder? specialSymbolBuilder;
}
