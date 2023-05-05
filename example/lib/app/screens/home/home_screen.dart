// ignore_for_file: public_member_api_docs, sort_constructors_first

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
  final artists = data.map((item) => Artist(name: item['artist'] as String, soungs: data.where((e) => e['artist'] == item['artist']).length)).toList();
  final ScrollController _nestedController = ScrollController();
  bool hasNestedController = false;

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
                  title: Text(artists[index].name),
                  leading: Text(index.toString()),
                );
              }),
    );
  }
}
