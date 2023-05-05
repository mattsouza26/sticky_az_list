import 'package:flutter/material.dart';
import 'enums.dart';

typedef SymbolBuilder = Widget Function(
  BuildContext context,
  String symbol,
);

typedef SymbolStateBuilder = Widget Function(
  BuildContext context,
  String symbol,
  ScrollbarItemState state,
);

typedef SymbolNullableStateBuilder = Widget Function(
  BuildContext context,
  String symbol,
  ScrollbarItemState? state,
);
