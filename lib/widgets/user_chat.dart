import 'package:flutter/material.dart';
import 'package:instagram_clone/helper/my_date_utils.dart';
import 'package:instagram_clone/models/message.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screen/chat_details_screen.dart';

class UserChat extends StatefulWidget {
  final snap;
  const UserChat({super.key, this.snap});

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  Message? _message;
  List<Message> _list = [];

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
        child: StreamBuilder(
          stream: FirestoreMethods().getLastMessage(widget.snap['uid']),
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.connectionState == ConnectionState.active) {
              final data = snapshot.data?.docs;
              _list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

              if (_list.isNotEmpty) {
                _message = _list[0];
              }
            }
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.snap['photoUrl']),
                radius: 24,
              ),
              title: Text(widget.snap['username']),
              subtitle: Text(
                _message != null
                    ? (_message!.type == 'text'
                        ? _message!.msg
                        : '${widget.snap['username']} send image')
                    : widget.snap['bio'],
                maxLines: 1,
              ),
              trailing: _message == null
                  ? null
                  : _message!.readDate.isEmpty &&
                          _message!.fromId != AuthMethods().getUserId
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        )
                      : Text(
                          MyDateUtil.getFormattedTime(
                              context: context, time: _message!.sentDate),
                          style: const TextStyle(color: Colors.white),
                        ),
            );
          }),
        ),
      ),
    );
  }
}
