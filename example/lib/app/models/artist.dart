import 'package:sticky_az_list/sticky_az_list.dart';

class Artist extends TaggedItem {
  final String name;
  final int soungs;
  Artist({
    required this.name,
    required this.soungs,
  });
  @override
  String sortName() => name;

  @override
  String toString() => name;
}
