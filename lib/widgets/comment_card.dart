import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final snap;
  final String postId;
  final String userId;
  const CommentCard(
      {super.key,
      required this.snap,
      required this.postId,
      required this.userId});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLikeAnimating = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['text']}',
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.all(8),
          //   child: LikeAnimation(
          //     isAnimating: widget.snap['likes'].contains(user.uid),
          //     child: IconButton(
          //       onPressed: () async {
          //         await FirestoreMethods().likeComment(
          //           widget.postId,
          //           widget.snap['commentId'],
          //           widget.userId,
          //           widget.snap['likes'],
          //         );
          //       },
          //       icon: widget.snap['likes']
          //               .contains(widget.userId != null ? widget.userId : "")
          //           ? const Icon(
          //               Icons.favorite,
          //               color: Colors.red,
          //             )
          //           : const Icon(
          //               Icons.favorite_border,
          //             ),
          //     ),
          //   ),
          // ),
          LikeAnimation(
            isAnimating: widget.snap['likes'].contains(user.uid),
            child: IconButton(
              onPressed: () async {
                await FirestoreMethods().likeComment(
                  widget.postId,
                  widget.snap['commentId'],
                  widget.userId,
                  widget.snap['likes'],
                );
              },
              icon: widget.snap['likes'].contains(user.uid)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_border,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
