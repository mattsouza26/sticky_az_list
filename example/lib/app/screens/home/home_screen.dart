import 'package:az_listview/app/common/songs.dart';
import 'package:flutter/material.dart';

import 'package:sticky_az_list/sticky_az_list.dart';

import '../../common/nested_scroll_controller_physics.dart';
import '../../models/artist.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final artists = data
      .map(
        (item) => Artist(
          name: item['artist'] as String,
          soungs: data.where((e) => e['artist'] == item['artist']).length,
        ),
      )
      .toList();
  final ScrollController _nestedController = ScrollController();
  bool hasNestedController = false;
  bool showScrollBar = false;

  @override
  void initState() {
    _nestedController.addListener(_showScrollBar);
    super.initState();
  }

  _showScrollBar() {
    if (_nestedController.offset == _nestedController.position.maxScrollExtent) {
      setState(() {
        showScrollBar = true;
      });
    } else if (_nestedController.offset < _nestedController.position.maxScrollExtent && showScrollBar) {
      setState(() {
        showScrollBar = false;
      });
    }
  }

  @override
  void dispose() {
    _nestedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(right: 25, bottom: 25),
        child: FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                hasNestedController = !hasNestedController;
              });
            },
            label: const Text("NestedScroll")),
      ),
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: hasNestedController
          ? NestedScrollView(
              physics: const BouncingScrollPhysics(),
              controller: _nestedController,
              headerSliverBuilder: (context, _) => [
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 300,
                    child: Placeholder(),
                  ),
                )
              ],
              body: Padding(
                padding: const EdgeInsets.all(0.0),
                child: StickyAzList(
                    options: StickyAzOptions(scrollBarOptions: ScrollBarOptions(visible: showScrollBar)),
                    physics: NestedScrollControllerPhysics(parentController: _nestedController),
                    items: artists,
                    builder: (context, index, item) {
                      return ListTile(
                        title: Text(artists[index].name),
                        leading: Text(index.toString()),
                      );
                    }),
              ),
            )
          : StickyAzList(
              items: artists,
              builder: (context, index, item) {
                return ListTile(
                  title: Text(item.name),
                  leading: Text(index.toString()),
                );
              }),
    );
  }
}
