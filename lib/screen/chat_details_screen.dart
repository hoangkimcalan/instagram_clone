import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/message.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/utils/colors.dart';

import '../widgets/message_card.dart';

class ChatDetailsScreen extends StatefulWidget {
  final snap;
  const ChatDetailsScreen({super.key, required this.snap});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

final TextEditingController _messageController = TextEditingController();

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  bool _isTyping = false;
  List<Message> _list = [];

  @override
  Widget build(BuildContext context) {
    print(_messageController.text);
    print("___");
    print("XX");
    print("___");
    print(AuthMethods().getUserId);
    return SafeArea(
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
                stream: FirebaseFirestore.instance
                    .collection('chats/${AuthMethods().getUserId}/messages')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    final data = (snapshot.data! as dynamic).docs;
                    _list =
                        data?.map((e) => Message.fromSnap(e.data())).toList() ??
                            [];
                  }
                  _list.clear();
                  _list.add(Message(
                    toId: 'id1',
                    fromId: 'id2',
                    msg: 'Hii',
                    sendDate: DateTime.now(),
                    readDate: DateTime.now(),
                    type: Type.text,
                  ));

                  _list.add(Message(
                    toId: 'id2',
                    fromId: 'BgKbDWa7zXVuTHf89wYcaje2ajy2',
                    msg: 'Hello',
                    sendDate: DateTime.now(),
                    readDate: DateTime.now(),
                    type: Type.text,
                  ));

                  if (_list.isNotEmpty) {
                    return ListView.builder(
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
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.emoji_emotions_outlined,
                      size: 28,
                    ),
                    onPressed: () {},
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
                      onChanged: (value) {
                        if (value != '') {
                          setState(() {
                            _isTyping = true;
                          });
                        } else {
                          setState(() {
                            _isTyping = false;
                          });
                        }
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
                  _isTyping == false
                      ? Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.image_outlined,
                                size: 28,
                              ),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                size: 28,
                              ),
                              onPressed: () {},
                            ),
                          ],
                        )
                      : MaterialButton(
                          onPressed: () {
                            setState(() {
                              _messageController.text = "";
                            });
                          },
                          child: const Text(
                            'Send',
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
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
            const Text(
              'offline 2 minutes',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        )
      ],
    );
  }
}
