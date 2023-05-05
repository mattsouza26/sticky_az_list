import 'package:flutter/material.dart';

import 'package:sticky_az_list/src/default/default_scrollbar_symbol.dart';
import 'package:sticky_az_list/src/grouped_item.dart';
import 'package:sticky_az_list/src/touched_symbol.dart';
import 'package:sticky_az_list/src/typedef.dart';

import '../controler.dart';
import '../enums.dart';
import '../options/scroll_bar_options.dart';

class ScrollBar extends StatelessWidget {
  final Iterable<GroupedItem> items;
  final Map<String, GlobalKey> symbols;
  final SymbolNotifier symbolNotifier;
  final ScrollBarOptions options;
  final SymbolStateBuilder? defaultSpecialSymbolBuilder;

  final void Function(TouchedSymbol value)? onSelectedSymbol;
  final void Function()? onSelectionEnd;

  const ScrollBar({
    Key? key,
    required this.items,
    required this.symbols,
    required this.symbolNotifier,
    required this.options,
    this.defaultSpecialSymbolBuilder,
    this.onSelectedSymbol,
    this.onSelectionEnd,
  }) : super(key: key);

  _onGestureHandler(details) {
    Offset? touchPos;
    String? touchedSymbol;

    for (final entry in symbols.entries) {
      final key = entry.value;
      final RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox == null) return;
      final Offset globalLocation = renderBox.localToGlobal(Offset(0, renderBox.paintBounds.height / 2));
      final Offset localLocation = renderBox.globalToLocal(Offset(details.globalPosition.dx, details.globalPosition.dy));
      final barWidth = options.width + options.padding.horizontal;

      final boundsWithPadding = Rect.fromLTRB(
        renderBox.paintBounds.left - (barWidth / 3).ceilToDouble(),
        renderBox.paintBounds.top,
        (barWidth / 3).ceilToDouble() * 2,
        renderBox.paintBounds.bottom,
      );

      if (renderBox.paintBounds.contains(localLocation) || renderBox.paintBounds.right < barWidth && boundsWithPadding.contains(localLocation)) {
        touchedSymbol = entry.key;
        touchPos = globalLocation;
        break;
      }
    }

    if (touchedSymbol != null && touchPos != null) {
      if (!options.jumpToSymbolsWithNoEntries ? _getSymbolState(touchedSymbol) != ScrollbarItemState.deactivated : true) {
        onSelectedSymbol?.call(TouchedSymbol(symbol: touchedSymbol, position: touchPos));
      }
    }
  }

  _onGestureEnd([_]) {
    onSelectionEnd?.call();
  }

  ScrollbarItemState _getSymbolState(String symbol) {
    final Iterable<GroupedItem> result = items.where((item) => item.tag == symbol);
    if (result.isNotEmpty) {
      if (result.first.children.isEmpty && !options.jumpToSymbolsWithNoEntries) {
        return ScrollbarItemState.deactivated;
      } else if (result.first.tag == symbolNotifier.value) {
        return ScrollbarItemState.active;
      } else {
        return ScrollbarItemState.inactive;
      }
    } else {
      return ScrollbarItemState.deactivated;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: !options.visible,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragUpdate: _onGestureHandler,
        onVerticalDragDown: _onGestureHandler,
        onVerticalDragCancel: _onGestureEnd,
        onVerticalDragEnd: _onGestureEnd,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            physics: options.scrollable ? const ScrollPhysics() : const NeverScrollableScrollPhysics(),
            scrollDirection: options.alignment == ScrollBarAlignment.stretch ? Axis.horizontal : Axis.vertical,
            child: Container(
              padding: options.padding,
              margin: options.margin,
              alignment: Alignment.center,
              width: options.width,
              decoration: BoxDecoration(
                borderRadius: options.borderRadius,
                color: options.background,
              ),
              child: Semantics(
                explicitChildNodes: true,
                child: ValueListenableBuilder(
                  valueListenable: symbolNotifier,
                  builder: (context, value, child) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: symbols.entries.map((symbol) {
                      final symbolState = _getSymbolState(symbol.key);
                      if (symbolState == ScrollbarItemState.deactivated && !options.showDeactivated) {
                        return SizedBox.shrink(
                          key: symbol.value,
                        );
                      }
                      return Flexible(
                        child: SizedBox(
                          width: options.width,
                          key: symbol.value,
                          child: Semantics(
                            button: true,
                            child: symbol.key == "#" && options.specialSymbolBuilder != null || symbol.key == "#" && defaultSpecialSymbolBuilder != null
                                ? options.specialSymbolBuilder?.call(context, symbol.key, symbolState) ??
                                    DefaultScrollBarSymbol(
                                      state: symbolState,
                                      symbolIcon: defaultSpecialSymbolBuilder?.call(context, symbol.key, symbolState),
                                      symbol: symbol.key,
                                      heightFactor: options.heightFactor,
                                    )
                                : options.symbolBuilder?.call(context, symbol.key, symbolState) ??
                                    DefaultScrollBarSymbol(
                                      symbol: symbol.key,
                                      state: symbolState,
                                      heightFactor: options.heightFactor,
                                    ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
