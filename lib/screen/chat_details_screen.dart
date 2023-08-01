import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/models/message.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screen/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:intl/intl.dart';

import '../widgets/message_card.dart';

class ChatDetailsScreen extends StatefulWidget {
  final snap;
  const ChatDetailsScreen({super.key, required this.snap});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  final TextEditingController _messageController = TextEditingController();
  bool _isShowEmoji = false;
  List<Message> _list = [];
  Uint8List? _file;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_isShowEmoji) {
              setState(() {
                _isShowEmoji = !_isShowEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream:
                        FirestoreMethods().getAllMessages(widget.snap['uid']),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) log('error');
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.connectionState == ConnectionState.active) {
                        final data = snapshot.data?.docs;
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];
                      }

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          reverse: true,
                          itemCount: _list.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(message: _list[index]);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'Say Hi! 👋',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                if (_isLoading)
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.emoji_emotions_outlined,
                                size: 28,
                              ),
                              onPressed: () {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  _isShowEmoji = !_isShowEmoji;
                                });
                              },
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _messageController,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                autofocus: true,
                                onTapOutside: (event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                onTap: () {
                                  setState(() => _isShowEmoji = !_isShowEmoji);
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Type something...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.image_outlined,
                                size: 28,
                              ),
                              onPressed: () async {
                                List<XFile> files =
                                    await pickImageGallery(ImageSource.gallery);
                                for (var i in files) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  await FirestoreMethods()
                                      .uploadImageMessageFromGalley(
                                          File(i.path), widget.snap['uid']);
                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                size: 28,
                              ),
                              onPressed: () async {
                                Uint8List file =
                                    await pickImage(ImageSource.gallery);
                                setState(() {
                                  _file = file;
                                  _isLoading = true;
                                });
                                FirestoreMethods().uploadImageMessage(
                                    _file!, widget.snap['uid']);
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    MaterialButton(
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            FirestoreMethods().sendMessage(widget.snap['uid'],
                                _messageController.text, 'text');
                            setState(() {
                              _messageController.text = "";
                            });
                          }
                        },
                        minWidth: 0,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.only(
                            top: 10, bottom: 10, right: 5, left: 10),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.blue,
                          size: 28,
                        ))
                  ],
                ),
                if (_isShowEmoji)
                  SizedBox(
                    height: 300,
                    child: EmojiPicker(
                      textEditingController: _messageController,
                      config: Config(
                        bgColor: const Color.fromARGB(255, 39, 39, 39),
                        columns: 8,
                        indicatorColor: Colors.grey,
                        iconColorSelected: Colors.grey,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        emojiSizeMax: 32 * (Platform.isAndroid ? 1.30 : 1.0),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 201, 200, 200)),
                          textAlign: TextAlign.center,
                        ), //
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            uid: widget.snap['uid'],
          ),
        ),
      ),
      child: Row(
        children: [
          IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
              )),
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['photoUrl']),
            radius: 20,
          ),
          const SizedBox(
            width: 8,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.snap['username'],
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              (widget.snap['isOnline'] == true)
                  ? const Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  : Text(
                      'Last online on ${DateFormat.MMMMEEEEd().format(widget.snap['lastActive'].toDate())}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    )
            ],
          )
        ],
      ),
    );
  }
}
