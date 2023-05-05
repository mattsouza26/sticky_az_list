// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:sticky_az_list/src/enums.dart';

class DefaultScrollBarSymbol extends StatelessWidget {
  final Widget? symbolIcon;
  final String? symbol;
  final ScrollbarItemState state;
  final double? heightFactor;

  const DefaultScrollBarSymbol({
    Key? key,
    this.symbolIcon,
    this.symbol,
    required this.state,
    this.heightFactor,
    this.styleActive,
    this.styleInactive,
    this.styleDeactivated,
  })  : assert(symbol != null || symbolIcon != null),
        super(key: key);

  /// style if symbol is active
  final TextStyle? styleActive;

  /// style if symbol is inactive
  final TextStyle? styleInactive;

  /// style if symbol is deactivated
  final TextStyle? styleDeactivated;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    TextStyle? textStyle;

    switch (state) {
      case ScrollbarItemState.active:
        textStyle = styleActive ?? themeData.textTheme.bodyMedium?.copyWith(color: themeData.colorScheme.primary);
        break;
      case ScrollbarItemState.inactive:
        textStyle = styleInactive ?? themeData.textTheme.bodyMedium?.copyWith();
        break;
      case ScrollbarItemState.deactivated:
        textStyle = styleDeactivated ?? themeData.textTheme.bodyMedium?.copyWith(color: Colors.grey);
        break;
    }

    return Center(
      heightFactor: heightFactor,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: symbolIcon != null
            ? Theme(
                data: themeData.copyWith(
                  iconTheme: IconThemeData(
                    color: textStyle?.color ?? themeData.colorScheme.onPrimary,
                    size: textStyle?.fontSize,
                  ),
                ),
                child: DefaultTextStyle(
                  style: themeData.textTheme.bodyMedium?.copyWith(color: textStyle?.color) ?? TextStyle(color: textStyle?.color),
                  child: symbolIcon!,
                ),
              )
            : Text(
                symbol!,
                style: textStyle,
              ),
      ),
    );
  }
}
