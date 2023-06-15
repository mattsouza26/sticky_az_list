import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import '../sticky_az_list.dart';

import './constants.dart';
import './controler.dart';

import 'components/az_list.dart';
import 'components/scroll_bar.dart';
import 'components/symbol_overlay.dart';
import 'grouped_item.dart';
import 'touched_symbol.dart';

class StickyAzList<T extends TaggedItem> extends StatefulWidget {
  final List<T> items;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final Widget Function(BuildContext context, int index, T item) builder;
  final StickyAzOptions options;

  const StickyAzList({
    Key? key,
    required this.items,
    this.physics,
    required this.builder,
    StickyAzOptions? options,
    this.controller,
  })  : options = options ?? const StickyAzOptions(),
        super(key: key);

  @override
  State<StickyAzList<T>> createState() => _StickyAzListState<T>();
}

class _StickyAzListState<T extends TaggedItem> extends State<StickyAzList<T>> {
  final GlobalKey listKey = GlobalKey();
  final GlobalKey scrollBarKey = GlobalKey();
  final SymbolNotifier symbolNotifier = SymbolNotifier();
  late final ScrollController controller;
  List<GroupedItem> groupedList = [];
  SymbolOverlay? symbolOverlay;
  late Map<String, GlobalKey> symbols;

  @override
  void initState() {
    _init();
    controller = widget.controller ?? ScrollController();
    controller.addListener(_getCurrentStickHeader);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant StickyAzList<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.items != widget.items || oldWidget.options != widget.options) {
      {
        setState(() {
          _init();
        });
      }
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      controller.dispose();
    }
    symbolNotifier.dispose();
    super.dispose();
  }

  void _init() {
    symbols = _generateSymbols();
    _sortListandRemoveDuplicates();
    groupedList = _groupedItems();
    symbolNotifier.value = widget.options.listOptions.showSectionHeaderForEmptySections
        ? symbols.keys.first
        : groupedList
            .firstWhereOrNull(
              (e) => e.children.isNotEmpty,
            )
            ?.tag;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.options.padding ?? EdgeInsets.zero,
      child: Row(
        crossAxisAlignment: _getScrollAligment(),
        children: [
          Expanded(
            child: AZList(
              viewKey: listKey,
              data: groupedList,
              controller: controller,
              physics: widget.physics,
              options: widget.options.listOptions,
              defaultSpecialSymbolBuilder: widget.options.specialSymbolBuilder,
            ),
          ),
          ScrollBar(
            key: scrollBarKey,
            items: groupedList,
            options: widget.options.scrollBarOptions,
            symbols: symbols,
            symbolNotifier: symbolNotifier,
            defaultSpecialSymbolBuilder: widget.options.specialSymbolBuilder,
            onSelectedSymbol: _onSelectedSymbol,
            onSelectionEnd: _hideSymbolOverlay,
          ),
        ],
      ),
    );
  }

  Map<String, GlobalKey> _generateSymbols() {
    List<String> symbols = allSymbols.where((e) => SymbolCharExt.alphabeticMatch(e.value)).map((e) => e.value).toList();
    if (widget.options.startWithSpecialSymbol) {
      symbols.insert(0, "#");
    } else {
      symbols.add("#");
    }
    return {
      for (var symbol in symbols) symbol: GlobalKey(),
    };
  }

  List<GroupedItem> _groupedItems() {
    final List<GroupedItem> groupList = [];
    final List<T> data = widget.items.toList();
    final groups = groupBy(data, (item) => SymbolCharExt.fromString(item.sortName()).value);

    for (var symbolChar in symbols.entries) {
      final String symbol = symbolChar.key;
      final groupedItem = GroupedItem(
        tag: symbol,
        children:
            groups.entries.firstWhereOrNull((group) => group.key == symbol)?.value.map((item) => widget.builder.call(context, widget.items.indexOf(item), item)).toList() ?? [],
      );
      groupList.add(groupedItem);
    }
    return groupList;
  }

  void _sortListandRemoveDuplicates() {
    final data = widget.items.toSet().toList();
    widget.items.clear();

    data.sort((a, b) {
      if (widget.options.startWithSpecialSymbol) {
        return a.sortName().compareTo(b.sortName());
      }

      final String symbolFromA = SymbolCharExt.fromString(a.sortName()).value;
      final String symbolFromB = SymbolCharExt.fromString(b.sortName()).value;
      if (!SymbolCharExt.alphabeticMatch(symbolFromA) && SymbolCharExt.alphabeticMatch(symbolFromB)) {
        return 1;
      } else if (SymbolCharExt.alphabeticMatch(symbolFromA) && !SymbolCharExt.alphabeticMatch(symbolFromB)) {
        return -1;
      } else {
        return a.sortName().compareTo(b.sortName());
      }
    });

    widget.items.addAll(data);
  }

  void _getCurrentStickHeader() {
    String? currentTag;

    final RenderBox? renderBoxScrollView = listKey.currentContext?.findRenderObject() as RenderBox?;

    for (final group in groupedList) {
      final RenderSliverStickyHeader? renderBoxItem = group.key.currentContext?.findRenderObject() as RenderSliverStickyHeader?;
      final RenderBox? renderBoxHeader = renderBoxItem?.header;

      final Offset? itemOffset = renderBoxHeader?.globalToLocal(renderBoxScrollView?.localToGlobal(Offset.zero) ?? Offset.zero);

      if (itemOffset != null && itemOffset.dy == 0.0 && currentTag != group.tag) {
        currentTag = group.tag;
        break;
      }
    }

    if (currentTag != null && currentTag != symbolNotifier.value) {
      symbolNotifier.value = currentTag;
    }
  }

  void _onSelectedSymbol(TouchedSymbol touched) {
    _jumpToSymbol(touched.symbol);
    _showSymbolOverlay(touched.position);
    symbolNotifier.value = touched.symbol;
  }

  void _jumpToSymbol(String symbol) {
    final RenderSliverStickyHeader? renderSliverItem = groupedList.firstWhere((item) => item.tag == symbol).key.currentContext!.findRenderObject() as RenderSliverStickyHeader?;

    final RenderObject? renderObjectHeader = renderSliverItem?.header;
    if (renderObjectHeader == null) return;
    final RenderAbstractViewport viewport = RenderAbstractViewport.of(renderObjectHeader);
    double? target;
    target = viewport.getOffsetToReveal(renderObjectHeader, 0).offset.clamp(0, controller.position.maxScrollExtent);

    controller.jumpTo(target);
  }

  void _showSymbolOverlay(Offset position) {
    if (widget.options.overlayOptions.showOverlay == false) return;
    final OverlayOptions overlayOptions = widget.options.overlayOptions;
    final ScrollBarOptions scrollBarOptions = widget.options.scrollBarOptions;

    double left = position.dx;
    double top = position.dy;

    if (overlayOptions.aligment == OverlayAligment.centered) {
      left = (MediaQuery.of(context).size.width / 2).ceilToDouble() - (overlayOptions.width / 2).ceilToDouble() + (overlayOptions.offset?.dx ?? 0);
      top = (MediaQuery.of(context).size.height / 2) - (overlayOptions.height / 2) + (overlayOptions.offset?.dy ?? 0);
    } else if (overlayOptions.aligment == OverlayAligment.dynamic) {
      final RenderBox? scrollBarRenderBox = scrollBarKey.currentContext?.findRenderObject() as RenderBox?;
      final Offset? scrollBarPos = scrollBarRenderBox?.localToGlobal(Offset.zero);

      final overlayInitialPos =
          (scrollBarRenderBox != null ? scrollBarPos!.dx : (MediaQuery.of(context).size.width - (scrollBarOptions.width + scrollBarOptions.margin.horizontal))) -
              scrollBarOptions.margin.horizontal;

      left = overlayInitialPos - (scrollBarOptions.width + scrollBarOptions.margin.horizontal) - scrollBarOptions.margin.left + (overlayOptions.offset?.dx ?? 0);
      top = top - (overlayOptions.height / 2).ceilToDouble() + (overlayOptions.offset?.dy ?? 0);
    }

    if (symbolOverlay == null) {
      symbolOverlay = SymbolOverlay(
        context,
        position: Offset(left, top),
        builder: (BuildContext ctx, position) {
          return Positioned(
            left: position.dx,
            top: position.dy,
            child: symbolNotifier.value == "#" && overlayOptions.specialSymbolBuilder != null || symbolNotifier.value == "#" && widget.options.specialSymbolBuilder != null
                ? overlayOptions.specialSymbolBuilder?.call(context, symbolNotifier.value!, null) ??
                    DefaultOverlaySymbol(
                      width: overlayOptions.width,
                      height: overlayOptions.height,
                      shape: overlayOptions.shape,
                      background: overlayOptions.background,
                      padding: overlayOptions.padding,
                      style: overlayOptions.style,
                      symbolIcon: widget.options.specialSymbolBuilder?.call(context, symbolNotifier.value!, null),
                      symbol: symbolNotifier.value!,
                    )
                : overlayOptions.overlayBuilder?.call(context, symbolNotifier.value!) ??
                    DefaultOverlaySymbol(
                        width: overlayOptions.width,
                        height: overlayOptions.height,
                        shape: overlayOptions.shape,
                        background: overlayOptions.background,
                        padding: overlayOptions.padding,
                        style: overlayOptions.style,
                        symbol: symbolNotifier.value!),
          );
        },
      );
    } else {
      if (overlayOptions.aligment == OverlayAligment.dynamic) {
        symbolOverlay!.rebuild(position: Offset(left, top));
      } else {
        symbolOverlay!.markNeedsBuild();
      }
    }
  }

  void _hideSymbolOverlay() {
    Future.delayed(const Duration(milliseconds: 100)).then((_) {
      if (symbolOverlay?.mounted ?? false) {
        symbolOverlay?.remove();
        symbolOverlay = null;
      }
    });
  }

  CrossAxisAlignment _getScrollAligment() {
    switch (widget.options.scrollBarOptions.alignment) {
      case ScrollBarAlignment.center:
        return CrossAxisAlignment.center;
      case ScrollBarAlignment.start:
        return CrossAxisAlignment.start;
      case ScrollBarAlignment.stretch:
        return CrossAxisAlignment.stretch;
      case ScrollBarAlignment.end:
        return CrossAxisAlignment.end;
    }
  }
}
