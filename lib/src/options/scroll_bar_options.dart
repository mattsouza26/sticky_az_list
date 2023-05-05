// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:sticky_az_list/src/typedef.dart';

import '../enums.dart';

class ScrollBarOptions {
  const ScrollBarOptions({
    this.scrollable = false,
    this.visible = true,
    this.showDeactivated = true,
    this.padding = const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
    this.margin = const EdgeInsets.only(right: 5, left: 5),
    this.width = 25,
    this.heightFactor,
    this.background,
    this.alignment = ScrollBarAlignment.start,
    this.borderRadius,
    this.jumpToSymbolsWithNoEntries = false,
    this.symbolBuilder,
    this.specialSymbolBuilder,
  });

  /// Enable scroll;
  final bool scrollable;

  /// Visibility of the scrollbar.
  final bool visible;

  /// Show the deactivated symbols;
  final bool showDeactivated;

  /// Padding of the scrollbar.
  final EdgeInsets padding;

  // Margin of the scrollbar.
  final EdgeInsets margin;

  /// The width of the scrollbar.
  final double width;

  /// Symbol heightFactor.
  final double? heightFactor;

  /// Optional background color for the scrollbar.
  final Color? background;

  /// Placement of the children in the scrollbar.
  final ScrollBarAlignment alignment;

  /// Border of the scrollbar
  final BorderRadiusGeometry? borderRadius;

  /// Enables jumping to the position even if there are no entries present.
  final bool jumpToSymbolsWithNoEntries;

  /// Builder function for scrollbar symbols.
  final SymbolStateBuilder? symbolBuilder;

  /// Builder function for scrollbar special symbol.
  final SymbolStateBuilder? specialSymbolBuilder;
}
