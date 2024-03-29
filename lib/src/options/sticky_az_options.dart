import 'package:flutter/material.dart';

import 'package:sticky_az_list/src/typedef.dart';
import 'package:sticky_az_list/sticky_az_list.dart';

class StickyAzOptions {
  const StickyAzOptions({
    this.startWithSpecialSymbol = false,
    this.specialSymbolBuilder,
    this.listOptions = const ListOptions(),
    this.scrollBarOptions = const ScrollBarOptions(),
    this.overlayOptions = const OverlayOptions(),
    this.padding,
    this.safeArea = const EnableSafeArea(),
  });

  /// Start with special symbol.
  final bool startWithSpecialSymbol;

  /// Define default special symbol for all components.
  final SymbolNullableStateBuilder? specialSymbolBuilder;

  /// Customisation options for the list.
  final ListOptions listOptions;

  /// Customisation options for the scrollbar.
  final ScrollBarOptions scrollBarOptions;

  /// Customisation options for the overlay.
  final OverlayOptions overlayOptions;

  /// Padding for the entire widget.
  final EdgeInsets? padding;

  /// Enable [SafeArea] for the list.
  final EnableSafeArea safeArea;
}
