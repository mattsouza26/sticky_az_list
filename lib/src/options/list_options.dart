// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../typedef.dart';

class ListOptions {
  const ListOptions({
    this.backgroundColor,
    this.headerColor,
    this.padding,
    this.showSectionHeader = true,
    this.stickySectionHeader = true,
    this.showSectionHeaderForEmptySections = false,
    this.listHeaderBuilder,
    this.specialSymbolBuilder,
    this.headerAligment,
    this.beforeList,
    this.afterList,
  });

  /// Optional background color.
  final Color? backgroundColor;

  /// Optional header color.
  final Color? headerColor;

  /// Padding around the list.
  final EdgeInsets? padding;

  /// Show the header above the items.
  final bool showSectionHeader;

  /// Use sticky headers.
  final bool stickySectionHeader;

  /// Show headers for sections without child widgets.
  final bool showSectionHeaderForEmptySections;

  /// Builder function for headers.
  final SymbolBuilder? listHeaderBuilder;

  /// Builder function for special symbol header.
  final SymbolNullableStateBuilder? specialSymbolBuilder;

  /// Optional [Aligment] for header.
  final Alignment? headerAligment;

  /// Optional [Widget] before the list.
  final Widget? beforeList;

  /// Optional [Widget] after the list.
  final Widget? afterList;
}
