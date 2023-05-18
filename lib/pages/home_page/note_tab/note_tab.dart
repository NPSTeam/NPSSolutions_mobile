import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../configs/themes/color_const.dart';
import '../../../controllers/note_list_controller.dart';
import '../../../widgets/widget_refresher.dart';
import 'note_detail_page.dart';

class NoteTab extends StatefulWidget {
  const NoteTab({super.key});

  @override
  State<NoteTab> createState() => _NoteTabState();
}

class _NoteTabState extends State<NoteTab> {
  NoteListController _noteListController = Get.put(NoteListController());

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  loadData() async {
    EasyLoading.show();
    await _noteListController.getNotes();
    EasyLoading.dismiss();
  }

  void _onRefresh() async {
    if (await _noteListController.getNotes()) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.refreshFailed();
    }
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NoteListController>(builder: (noteListController) {
      return Scaffold(
        backgroundColor: ColorConst.primary,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 25.0),
                    Text(
                      'Search your notes',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 25.0),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: Get.width,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(color: Colors.blueAccent, blurRadius: 10)
                    ],
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 6,
                            decoration: BoxDecoration(
                                color: ColorConst.lightPrimary,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: WidgetRefresher(
                              controller: _refreshController,
                              onRefresh: _onRefresh,
                              onLoading: _onLoading,
                              child: MasonryGridView.count(
                                physics: const BouncingScrollPhysics(),
                                crossAxisCount: 2,
                                crossAxisSpacing: 4,
                                mainAxisSpacing: 4,
                                itemCount:
                                    noteListController.notes?.length ?? 0,
                                itemBuilder: (context, index) {
                                  return _noteItem(index, noteListController);
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _noteItem(int index, NoteListController noteListController) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      child: InkWell(
        onTap: () {
          Get.to(() => const NoteDetailPage(), transition: Transition.zoom);
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: Random().nextDouble() * 100 + 200,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (noteListController.notes?[index].image != null &&
                  noteListController.notes?[index].image != '')
                CachedNetworkImage(
                  imageUrl: noteListController.notes?[index].image ?? '',
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      CircularProgressIndicator(
                          value: downloadProgress.progress),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  noteListController.notes?[index].title ?? '',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    noteListController.notes?[index].content ?? '',
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 10,
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
