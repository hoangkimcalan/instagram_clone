import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/follow_button.dart';

class LikeDetailCard extends StatefulWidget {
  final idUser;
  const LikeDetailCard({super.key, required this.idUser});

  @override
  State<LikeDetailCard> createState() => _LikeDetailCardState();
}

class _LikeDetailCardState extends State<LikeDetailCard> {
  bool isFollowing = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: mobileBackgroundColor,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', isEqualTo: widget.idUser)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.connectionState == ConnectionState.active) {
            isFollowing = snapshot.data?.docs[0].data()['uid'] !=
                FirebaseAuth.instance.currentUser!.uid;
          }

          return ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(snapshot.data?.docs[0].data()['photoUrl']),
              radius: 24,
            ),
            title: Text(snapshot.data?.docs[0].data()['username']),
            trailing: SizedBox(
              width: 150,
              height: 80,
              child: isFollowing
                  ? (snapshot.data?.docs[0]
                          .data()['followers']
                          .contains(FirebaseAuth.instance.currentUser!.uid)
                      ? FollowButton(
                          text: 'Unfollow',
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          borderColor: Colors.grey,
                          function: () async {
                            await FirestoreMethods().followUser(
                                FirebaseAuth.instance.currentUser!.uid,
                                snapshot.data?.docs[0].data()['uid']);

                            setState(() {
                              isFollowing = false;
                            });
                          },
                        )
                      : FollowButton(
                          text: 'Follow',
                          backgroundColor: Colors.blue,
                          textColor: Colors.white,
                          borderColor: Colors.blue,
                          function: () async {
                            await FirestoreMethods().followUser(
                                FirebaseAuth.instance.currentUser!.uid,
                                snapshot.data?.docs[0].data()['uid']);

                            setState(() {
                              isFollowing = true;
                            });
                          },
                        ))
                  : const Text(''),
            ),
          );
        },
      ),
    );
  }
}
