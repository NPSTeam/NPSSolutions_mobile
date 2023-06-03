import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:npssolutions_mobile/pages/home_page/chat_tab/chat_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../configs/themes/assets_const.dart';
import '../../../configs/themes/color_const.dart';
import '../../../controllers/chat_list_controller.dart';
import '../../../models/contact_model.dart';
import '../../../widgets/widget_refresher.dart';

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final ChatListController _chatListController = Get.put(ChatListController());

  bool isLoading = true;

  _loadData() async {
    await EasyLoading.show();

    await _chatListController.getChatList();
    await _chatListController.getContactList();

    for (var element in _chatListController.chats) {
      element.contact = _chatListController.contacts.firstWhere(
          (contact) => contact.id == element.contactId,
          orElse: () => ContactModel());
    }

    setState(() => isLoading = false);

    await EasyLoading.dismiss();
  }

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    await _loadData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    _loadData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListController>(builder: (chatListController) {
      return Scaffold(
        backgroundColor: ColorConst.primary,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 25.0),
                    // Text(
                    //   MessageKeys.remainingTasks.trParams(
                    //       {'value': '${controller.remainingTasks ?? 0}'}),
                    //   style: const TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 18.0,
                    //       fontWeight: FontWeight.w500),
                    // ),
                    const SizedBox(height: 25.0),
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
                          child: isLoading
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: WidgetRefresher(
                                    controller: _refreshController,
                                    onRefresh: _onRefresh,
                                    onLoading: _onLoading,
                                    child: ListView.separated(
                                      itemCount:
                                          chatListController.chats.length,
                                      separatorBuilder: (context, index) =>
                                          Divider(
                                        color: Colors.grey.shade300,
                                        height: 0.5,
                                      ),
                                      itemBuilder: (context, index) => Card(
                                        clipBehavior: Clip.hardEdge,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: InkWell(
                                          onTap: () => Get.to(
                                              () => ChatPage(
                                                  chat: chatListController
                                                      .chats[index]),
                                              transition: Transition.cupertino),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Container(
                                                      height: 50,
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: Colors.grey[300],
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          chatListController
                                                                  .chats[index]
                                                                  .contact
                                                                  ?.name?[0] ??
                                                              '#',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 25,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          chatListController
                                                                  .chats[index]
                                                                  .contact
                                                                  ?.name ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          )),
                                                      Text(
                                                        chatListController
                                                                .chats[index]
                                                                .lastMessage ??
                                                            '',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
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
}
