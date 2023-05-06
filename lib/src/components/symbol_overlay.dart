import 'package:flutter/material.dart';

class SymbolOverlay {
  late final OverlayState _overlayState;
  late OverlayEntry _overlayEntry;
  final Widget Function(BuildContext context, Offset position) builder;
  final Offset position;
  final BuildContext context;

  SymbolOverlay(
    this.context, {
    required this.position,
    required this.builder,
  }) {
    _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(builder: (context) {
      return builder.call(context, position);
    });
    _overlayState.insert(_overlayEntry);
  }

  bool get mounted => _overlayEntry.mounted;

  markNeedsBuild() {
    _overlayEntry.markNeedsBuild();
  }

  rebuild(
      {Widget Function(BuildContext context, Offset position)? builder,
      Offset? position}) {
    if (builder != null || position != null) {
      _overlayEntry.remove();
      _overlayEntry = OverlayEntry(builder: (context) {
        return builder?.call(context, position ?? this.position) ??
            this.builder.call(context, position ?? this.position);
      });
      _overlayState.insert(_overlayEntry);
    } else {
      _overlayEntry.markNeedsBuild();
    }
  }

  remove() {
    _overlayEntry.remove();
    _overlayEntry.dispose();
  }

  dispose() {
    _overlayEntry.dispose();
  }
}
