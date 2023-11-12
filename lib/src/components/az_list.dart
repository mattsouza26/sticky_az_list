import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

import 'package:sticky_az_list/src/typedef.dart';

import '../../sticky_az_list.dart';
import '../grouped_item.dart';

class AZList extends StatelessWidget {
  final ListOptions options;
  final ScrollPhysics? physics;
  final ScrollController controller;
  final List<GroupedItem> data;
  final GlobalKey? viewKey;
  final SymbolNullableStateBuilder? defaultSpecialSymbolBuilder;
  final EnableSafeArea safeArea;

  const AZList({
    Key? key,
    required this.options,
    this.physics,
    required this.controller,
    required this.data,
    this.viewKey,
    this.defaultSpecialSymbolBuilder,
    required this.safeArea,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return Container(
      color: options.backgroundColor,
      padding: options.padding,
      child: CustomScrollView(
        key: viewKey,
        controller: controller,
        physics: physics,
        slivers: [
          SliverToBoxAdapter(child: options.beforeList),
          ...data
              .map(
                (item) => SliverOffstage(
                  offstage: !item.children.isNotEmpty && !options.showSectionHeaderForEmptySections,
                  sliver: SliverSafeArea(
                    bottom: safeArea.bottom,
                    top: safeArea.top,
                    left: safeArea.left,
                    right: safeArea.right,
                    sliver: SliverStickyHeader(
                      key: item.key,
                      sticky: options.stickySectionHeader,
                      header: options.showSectionHeader
                          ? item.tag == "#" && options.specialSymbolBuilder != null || item.tag == "#" && defaultSpecialSymbolBuilder != null
                              ? options.specialSymbolBuilder?.call(context, item.tag, null) ??
                                  DefaultHeaderSymbol(
                                    alignment: options.headerAligment,
                                    symbolIcon: defaultSpecialSymbolBuilder?.call(context, item.tag, null),
                                    backgroundColor: options.headerColor ?? options.backgroundColor ?? themeData.colorScheme.primary,
                                    symbol: item.tag,
                                  )
                              : options.listHeaderBuilder?.call(context, item.tag) ??
                                  DefaultHeaderSymbol(
                                    alignment: options.headerAligment,
                                    backgroundColor: options.headerColor ?? options.backgroundColor ?? themeData.colorScheme.primary,
                                    symbol: item.tag,
                                  )
                          : const SizedBox.shrink(),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(item.children.toList()),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
          SliverToBoxAdapter(child: options.afterList),
        ],
      ),
    );
  }
}
