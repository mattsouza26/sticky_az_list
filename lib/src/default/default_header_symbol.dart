import 'package:flutter/material.dart';

class DefaultHeaderSymbol extends StatelessWidget {
  final String? symbol;
  final Widget? symbolIcon;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final Alignment? alignment;

  const DefaultHeaderSymbol({
    super.key,
    this.symbol,
    this.symbolIcon,
    this.backgroundColor,
    this.alignment,
    this.padding,
  }) : assert(symbol != null || symbolIcon != null);

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);

    return Container(
      color: backgroundColor ?? themeData.colorScheme.primary,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Center(
        child: SizedBox(
          width: double.infinity,
          child: Align(
            alignment: alignment ?? Alignment.centerLeft,
            child: symbolIcon != null
                ? Theme(
                    data: themeData.copyWith(
                      iconTheme: IconThemeData(color: themeData.textTheme.bodyMedium?.color),
                    ),
                    child: DefaultTextStyle(
                      style: themeData.textTheme.bodyMedium?.copyWith() ?? const TextStyle(),
                      child: symbolIcon!,
                    ),
                  )
                : Text(
                    symbol!,
                    style: themeData.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
