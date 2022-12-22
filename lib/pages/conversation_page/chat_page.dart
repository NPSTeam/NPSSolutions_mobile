import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:nps_social/configs/theme/color_const.dart';
import 'package:nps_social/configs/theme/style_const.dart';
import 'package:nps_social/controllers/auth_controller.dart';
import 'package:nps_social/controllers/conversation_controller.dart';
import 'package:nps_social/models/image_model.dart';
import 'package:nps_social/models/user_model.dart';
import 'package:nps_social/pages/call_page/call_page.dart';
import 'package:nps_social/pages/call_page/controllers/call_controller.dart';
import 'package:nps_social/pages/conversation_page/components/message_item.dart';
import 'package:nps_social/repositories/cloudinary_repo.dart';
import 'package:nps_social/services/peer_client.dart';
import 'package:nps_social/services/socket_client.dart';
import 'package:image_picker_platform_interface/src/types/image_source.dart'
    as image_source;
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:peerdart/peerdart.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final AuthController _authController = Get.find();
  final ConversationController _conversationController = Get.find();
  final TextEditingController _chatEditingController = TextEditingController();
  UserModel? recipient;

  bool isLoadingMessages = true;
  ScrollController _scrollController = ScrollController();

  ImagePicker picker = ImagePicker();
  List<File> selectedImages = [];

  @override
  void initState() {
    try {
      if (_conversationController.selectedConversation?.recipients?[0].id !=
          _authController.currentUser?.id) {
        recipient =
            _conversationController.selectedConversation?.recipients?[0];
      } else {
        recipient =
            _conversationController.selectedConversation?.recipients?[1];
      }
    } catch (e) {}

    _conversationController.recipient = recipient;
    _conversationController.getMessages().then((_) {
      setState(() {
        isLoadingMessages = false;
      });
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _conversationController.page++;
        _conversationController.getMessages();
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          recipient?.fullName ?? '',
          style: const TextStyle(
            color: ColorConst.blue,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            letterSpacing: -1.2,
          ),
        ),
        centerTitle: false,
        elevation: 5,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 20.0,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(recipient?.avatar ?? ''),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              SocketClient.socket.emit(
                'callUser',
                {
                  'sender': _authController.currentUser?.id ?? '',
                  'recipient': recipient?.id ?? '',
                  'avatar': _authController.currentUser?.avatar ?? '',
                  'fullName': _authController.currentUser?.fullName ?? '',
                  'video': false,
                },
              );

              Get.dialog(
                barrierDismissible: false,
                AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        recipient?.fullName ?? '',
                        style: StyleConst.boldStyle(fontSize: 25),
                      ),
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(recipient?.avatar ?? ''),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Calling Audio...",
                        style: StyleConst.regularStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          dynamic data = {
                            'sender': _authController.currentUser?.id ?? '',
                            'recipient': recipient?.id ?? '',
                            'avatar': _authController.currentUser?.avatar ?? '',
                            'fullName':
                                _authController.currentUser?.fullName ?? '',
                            'video': false,
                          };

                          if (PeerClient.peer.open) {
                            debugPrint("Peer iddd: ${PeerClient.peer.id}");
                            data["peerId"] = PeerClient.peer.id;
                          }

                          SocketClient.socket.emit('endCall', {
                            data,
                          });
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.red, // <-- Button color
                          foregroundColor: ColorConst.blue, // <-- Splash color
                        ),
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Ionicons.call,
                color: ColorConst.blue,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              SocketClient.socket.emit(
                'callUser',
                {
                  'sender': _authController.currentUser?.id ?? '',
                  'recipient': recipient?.id ?? '',
                  'avatar': _authController.currentUser?.avatar ?? '',
                  'fullName': _authController.currentUser?.fullName ?? '',
                  'video': true,
                  'peerId': PeerClient.peer.id,
                },
              );

              PeerClient.peer
                  .on<MediaConnection>("call")
                  .listen((newCall) async {
                PeerClient.openStream().then((stream) {
                  PeerClient.newCall = newCall;
                  PeerClient.newCall.answer(stream);
                  PeerClient.newCall
                      .on<webrtc.MediaStream>("stream")
                      .listen((event) {
                    Get.find<CallController>()
                        .setMediaStream(myMedia: stream, remoteMedia: event);
                    if (Get.isDialogOpen ?? false) Get.back();
                    Get.to(() => CallPage(endCall: () {
                          Get.back();
                          PeerClient.newCall.close();
                          SocketClient.socket.emit('endCall', {
                            'sender': recipient?.id,
                          });
                        }));
                  });

                  PeerClient.newCall.on("close").listen((event) {
                    PeerClient.newCall.close();
                  });
                });
              });

              Get.dialog(
                barrierDismissible: false,
                AlertDialog(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        recipient?.fullName ?? '',
                        style: StyleConst.boldStyle(fontSize: 25),
                      ),
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[200],
                        backgroundImage: NetworkImage(recipient?.avatar ?? ''),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Calling Video...",
                        style: StyleConst.regularStyle(fontSize: 15),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          SocketClient.socket.emit('endCall', {
                            {
                              'sender': _authController.currentUser?.id ?? '',
                              'recipient': recipient?.id ?? '',
                              'avatar':
                                  _authController.currentUser?.avatar ?? '',
                              'fullName':
                                  _authController.currentUser?.fullName ?? '',
                              'video': true,
                            },
                          });
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: Colors.red, // <-- Button color
                          foregroundColor: ColorConst.blue, // <-- Splash color
                        ),
                        child: const Icon(
                          Icons.call_end,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Ionicons.videocam,
                color: ColorConst.blue,
              ),
            ),
          ),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(10),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Ionicons.trash,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
      body: GetBuilder<ConversationController>(builder: (controller) {
        return Column(
          children: [
            Expanded(
              child: isLoadingMessages
                  ? const SpinKitWave(
                      color: ColorConst.blue,
                      size: 30,
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: controller.messages.length,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2.0),
                            child: MessageItem(
                                message: controller.messages[index]),
                          )),
            ),
            if (selectedImages.isNotEmpty)
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: selectedImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(selectedImages[index]),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedImages.removeAt(index);
                                });
                              },
                              child: const Icon(
                                Ionicons.close_circle_outline,
                                color: ColorConst.red,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _chatEditingController,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        hintText: 'Say something',
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      XFile? image = await picker.pickImage(
                          source: image_source.ImageSource.gallery);
                      setState(() {
                        selectedImages.add(File(image?.path ?? ''));
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Ionicons.images_outline),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (_chatEditingController.text.trim() == '' &&
                          selectedImages.isEmpty) return;

                      List<ImageModel> uploadedImageUrls = [];
                      if (selectedImages.isNotEmpty) {
                        await cloudinaryRepository
                            .uploadImages(imageFiles: selectedImages)
                            .then((value) {
                          uploadedImageUrls = value ?? [];
                          setState(() {
                            selectedImages = [];
                          });
                        });
                      }

                      controller.createMessage(
                        senderId: _authController.currentUser?.id ?? '',
                        recipientId: recipient?.id ?? '',
                        text: _chatEditingController.text.trim(),
                        media: uploadedImageUrls,
                      );

                      setState(() {
                        _chatEditingController.text = '';
                      });
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(Ionicons.send),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
