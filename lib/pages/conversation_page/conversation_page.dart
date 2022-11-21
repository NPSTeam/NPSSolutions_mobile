import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:nps_social/controllers/conversation_controller.dart';
import 'package:nps_social/models/conversation_model.dart';
import 'package:nps_social/pages/conversation_page/components/conversation_item.dart';

import '../../configs/theme/color_const.dart';

class ConversationPage extends StatefulWidget {
  const ConversationPage({super.key});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage>
    with AutomaticKeepAliveClientMixin<ConversationPage> {
  final ConversationController _conversationController = Get.find();
  bool isLoadingConversationList = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _conversationController.getConversations().then((_) {
      setState(() {
        isLoadingConversationList = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: RefreshIndicator(
        edgeOffset: 50,
        onRefresh: () async {
          setState(() {
            isLoadingConversationList = true;
          });
          _conversationController.getConversations().then((value) async {
            await Future.delayed(const Duration(seconds: 1)).then((value) {
              setState(() {
                isLoadingConversationList = false;
              });
            });
          });

          debugPrint("Refresh");
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              title: const Text(
                "Message",
                style: TextStyle(
                  color: ColorConst.blue,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2,
                ),
              ),
              centerTitle: false,
              floating: true,
              leading: GestureDetector(
                onTap: () async {
                  setState(() {
                    isLoadingConversationList = true;
                  });
                  _conversationController
                      .getConversations()
                      .then((value) async {
                    await Future.delayed(const Duration(seconds: 1))
                        .then((value) {
                      setState(() {
                        isLoadingConversationList = false;
                      });
                    });
                  });

                  // _homeController.getSuggestions();
                  debugPrint("Refresh");
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    "assets/icons/messages.png",
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              actions: [
                // WidgetCircleButton(
                //   icon: Icons.search,
                //   iconSize: 30.0,
                //   iconColor: Colors.black,
                //   onPressed: () => debugPrint("search"),
                // ),
                GestureDetector(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "assets/icons/search.png",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ],
            ),
            isLoadingConversationList
                ? const SliverPadding(
                    padding: EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                    sliver: SliverToBoxAdapter(
                      child: SpinKitThreeBounce(
                        color: ColorConst.blue,
                        size: 30,
                      ),
                    ),
                  )
                : GetBuilder<ConversationController>(
                    builder: (controller) => SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Card(
                            margin: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            elevation: 5,
                            child: SizedBox(
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ConversationItem(
                                    conversation:
                                        controller.allConversations?[index] ??
                                            ConversationModel()),
                              ),
                            ),
                          );
                        },
                        childCount: controller.allConversations?.length ?? 0,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
