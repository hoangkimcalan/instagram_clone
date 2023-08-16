import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/helper/my_date_utils.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screen/post_detail_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class NotificationCard extends StatefulWidget {
  final snap;
  const NotificationCard({super.key, this.snap});

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  var list = [];
  late model.User guestUser;
  String postUrl =
      'https://firebasestorage.googleapis.com/v0/b/instagram-bbee5.appspot.com/o/posts%2FmfQ87DC60xfclTtIMioyfZSXjKz2%2F0b75bbf0-1e56-11ee-8d6c-3fc82572e673?alt=media&token=80e859e2-3658-4e85-a7c4-a1c7de001d11';
  var postDetails;

  void getPostUrl() async {
    final post =
        await FirestoreMethods().getUrlImagePost(widget.snap['postId']);

    setState(() {
      postUrl = post['postUrl'];
      postDetails = post;
    });

    log(postDetails.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPostUrl();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: mobileBackgroundColor,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: widget.snap['guestId'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return InkWell(
            onTap: () {
              FirestoreMethods()
                  .updateStatusReadNotification(widget.snap['notificationId']);

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(snap: postDetails),
                ),
              );
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(snapshot.data?.docs[0].data()['photoUrl']),
                radius: 24,
              ),
              title: Text(
                '${snapshot.data?.docs[0].data()['username']} đã ${widget.snap['isLike'] ? 'thích một bài viết của bạn' : 'bình luận về bài viết của bạn'}',
                style: TextStyle(
                  fontWeight: widget.snap['readDate'].isNotEmpty
                      ? FontWeight.normal
                      : FontWeight.w700,
                ),
              ),
              subtitle: Text(
                MyDateUtil.getFormattedTime(
                    context: context, time: widget.snap['createdDate']),
                style:
                    const TextStyle(color: Color.fromARGB(255, 143, 143, 143)),
              ),
              trailing: SizedBox(
                width: 55,
                height: 100,
                child: ClipRRect(
                  child: CachedNetworkImage(
                    imageUrl: postUrl,
                    placeholder: (context, url) => const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.image, size: 70),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
