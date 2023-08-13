import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class LikeDetailCard extends StatefulWidget {
  final idUser;
  const LikeDetailCard({super.key, required this.idUser});

  @override
  State<LikeDetailCard> createState() => _LikeDetailCardState();
}

class _LikeDetailCardState extends State<LikeDetailCard> {
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
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(snapshot.data?.docs[0].data()['photoUrl']),
                radius: 24,
              ),
              title: Text(snapshot.data?.docs[0].data()['username']),
            );
          }),
    );
  }
}
