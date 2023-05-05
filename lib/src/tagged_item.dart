abstract class TaggedItem {
  String sortName();

  @override
  bool operator ==(covariant TaggedItem other) {
    if (identical(this, other)) return true;
    return other.sortName() == sortName();
  }

  @override
  int get hashCode => sortName().hashCode;
}
