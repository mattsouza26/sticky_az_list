import 'package:flutter/material.dart';

class DefaultOverlaySymbol extends StatelessWidget {
  final TextStyle? style;

  final double? width;
  final double? height;

  final EdgeInsets? padding;
  final ShapeBorder? shape;

  final Color? background;
  final String? symbol;
  final Widget? symbolIcon;

  const DefaultOverlaySymbol({
    super.key,
    this.style,
    this.width,
    this.height,
    this.shape,
    this.background,
    this.symbol,
    this.symbolIcon,
    this.padding,
  }) : assert(symbol != null || symbolIcon != null);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return SizedBox(
      width: width,
      height: height,
      child: Material(
        shape: shape,
        color: background ?? themeData.colorScheme.secondary.withOpacity(0.8),
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: FittedBox(
            child: Center(
              child: symbolIcon != null
                  ? Theme(
                      data: themeData.copyWith(
                        iconTheme: IconThemeData(
                          color:
                              style?.color ?? themeData.colorScheme.onPrimary,
                          size: style?.fontSize,
                        ),
                      ),
                      child: DefaultTextStyle(
                        style: TextStyle(color: style?.color),
                        child: symbolIcon!,
                      ),
                    )
                  : Text(
                      symbol!,
                      style: style?.copyWith(
                        color: style?.color ?? themeData.colorScheme.onPrimary,
                        fontWeight: style?.fontWeight ?? FontWeight.w400,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
