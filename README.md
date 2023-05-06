# Sticky AZ List


### A ListView with sticky headers and with an dynamic vertical Alphabet List on the Side which you can drag and tap to scroll to the first item starting with that letter in the list.


## Features

- Easy to create
- Sticky headers with floating option.
- Support index linkage.
- Customizable header
- Customizable sidebar
- Customizable overlay
- Configurable sidebar items
- Work with NestedScrollView


|       |       |       |
|:------|:-----:|------:|
![](https://user-images.githubusercontent.com/74125222/236589285-97666b4b-fc2f-47b5-b2e7-1c74aca094b1.gif)|![](https://user-images.githubusercontent.com/74125222/236589283-520f94a9-5292-4964-aaf2-e3b33fefba49.gif)|![](https://user-images.githubusercontent.com/74125222/236589280-019529f1-c730-499f-a681-66d00cbee439.gif)
![](https://user-images.githubusercontent.com/74125222/236620618-e6793115-3d44-4cfc-8bd9-03b228c6c966.gif)|![](https://user-images.githubusercontent.com/74125222/236620931-d3f1f87a-f698-434d-85fb-cbae46dd1548.gif)|
<style>
table {
  border-collapse: collapse;
}
table td, table th, table tr {
  border: none!important;
}
</style>






## Usage

Depend on it:
```yaml
dependencies:
  sticky_az_list: ^0.0.1
```


Import:
```dart
import 'package:sticky_az_list/sticky_az_list.dart';
```

Example:
```dart
class User extends TaggedItem {
  final String name;
  User({required this.name});

  @override
  String sortName() => name;
}

final usersList = data
      .map(
        (item) => User(
          name: item['name'] as String,
        ),
      )
      .toList();

StickyAzList(
    items: artists,
    builder: (context, index, item) {
        return ListTile(
                title: Text(item.name),
                leading: Text(index.toString()),
            );
    });
```

