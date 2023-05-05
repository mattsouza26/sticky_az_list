const List<SymbolChar> allSymbols = SymbolChar.values;

enum SymbolChar {
  A,
  B,
  C,
  D,
  E,
  F,
  G,
  H,
  I,
  J,
  K,
  L,
  M,
  N,
  O,
  P,
  Q,
  R,
  S,
  T,
  U,
  V,
  W,
  X,
  Y,
  Z,
  others,
}

extension SymbolCharExt on SymbolChar {
  String get value {
    if (name.length > 1) {
      return '#';
    }
    return name;
  }

  static SymbolChar fromString(String letter) {
    final char = letter[0].toUpperCase();
    if (RegExp('[A-Z]').hasMatch(char)) {
      for (final letter in SymbolChar.values) {
        if (letter.value == char) {
          return letter;
        }
      }
    }
    return SymbolChar.others;
  }

  static bool alphabeticMatch(String text) {
    return RegExp('[A-Z]').hasMatch(text);
  }
}
