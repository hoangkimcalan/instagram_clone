import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/user_chat.dart';

class ChatScreens extends StatefulWidget {
  const ChatScreens({super.key});

  @override
  State<ChatScreens> createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(Icons.arrow_back_ios_new),
        ),
        title: const Text("username"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search_sharp),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: 5,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return const UserChat();
          }),
    );
  }
}
