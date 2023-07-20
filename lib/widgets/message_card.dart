import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/helper/my_date_utils.dart';
import 'package:instagram_clone/models/message.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:intl/intl.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    print("CCCCC");
    print(widget.message.fromId);
    print(FirebaseAuth.instance.currentUser!.uid);
    print(AuthMethods().getUserId());
    return FirebaseAuth.instance.currentUser!.uid == widget.message.fromId
        ? _blueMessage()
        : _greyMessage();
  }

  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const SizedBox(
              width: 16,
            ),
            const Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.message.sentDate),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 52, 37, 168),
              border: Border.all(color: const Color.fromARGB(255, 12, 40, 96)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomLeft: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _greyMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(115, 66, 66, 66),
              border: Border.all(color: Color.fromARGB(255, 44, 44, 44)),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Text(
              widget.message.msg,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sentDate),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        )
      ],
    );
  }
}
