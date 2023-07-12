import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/chat_details_screen.dart';
import 'package:instagram_clone/screen/chats_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class UserChat extends StatefulWidget {
  final snap;
  const UserChat({super.key, this.snap});

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.grey[900],
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChatDetailsScreen(snap: widget.snap),
            ),
          );
        },
        child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.snap['photoUrl']),
              radius: 24,
            ),
            title: Text(widget.snap['username']),
            subtitle: const Text(
              'Last user message',
              maxLines: 1,
            ),
            trailing: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: Colors.greenAccent.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
            )
            // const Text(
            //   '12:00 PM',
            //   style: TextStyle(color: Colors.white),
            // ),
            ),
      ),
    );
  }
}
