import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/helper/my_date_utils.dart';
import 'package:instagram_clone/models/message.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
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
            if (widget.message.readDate.isNotEmpty)
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
            padding: EdgeInsets.all(widget.message.type == 'text' ? 12 : 0),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 52, 37, 168),
              border: Border.all(color: const Color.fromARGB(255, 12, 40, 96)),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
                bottomLeft: const Radius.circular(30),
                bottomRight: widget.message.type != 'text'
                    ? const Radius.circular(30)
                    : const Radius.circular(0),
              ),
            ),
            child: widget.message.type == 'text'
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )
                : SizedBox(
                    height: 340,
                    width: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.image, size: 70),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _greyMessage() {
    if (widget.message.readDate.isEmpty) {
      FirestoreMethods().updateMessageReadStatus(widget.message);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(widget.message.type == 'text' ? 12 : 2),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: const Color.fromARGB(115, 66, 66, 66),
              border: Border.all(color: const Color.fromARGB(255, 44, 44, 44)),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(30),
                topRight: const Radius.circular(30),
                bottomRight: const Radius.circular(30),
                bottomLeft: widget.message.type != 'text'
                    ? const Radius.circular(30)
                    : const Radius.circular(0),
              ),
            ),
            child: widget.message.type == 'text'
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  )
                : SizedBox(
                    height: 340,
                    width: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => const Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.image,
                          size: 70,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
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
