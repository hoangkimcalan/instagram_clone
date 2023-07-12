import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/utils/colors.dart';

class ChatDetailsScreen extends StatefulWidget {
  final snap;
  const ChatDetailsScreen({super.key, required this.snap});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          centerTitle: false,
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Column(
          children: [_chatInput()],
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

Widget _chatInput() {
  return Row(
    children: [
      const TextField(
        decoration: const InputDecoration(
          hintText: 'Enter message',
        ),
      ),
      IconButton(
        icon: const Icon(Icons.emoji_emotions_outlined),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.image_outlined),
        onPressed: () {},
      ),
      IconButton(
        icon: const Icon(Icons.camera_alt_outlined),
        onPressed: () {},
      ),
    ],
  );
}
