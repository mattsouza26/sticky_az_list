import 'package:flutter/material.dart';

class GroupedItem {
  final String tag;
  final GlobalKey key;
  final Iterable<Widget> children;

  GroupedItem({
    required this.tag,
    required this.children,
  }) : key = GlobalKey();
}
