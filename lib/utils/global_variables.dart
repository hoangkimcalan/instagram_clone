import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/screen/add_post_screen.dart';
import 'package:instagram_clone/screen/feed_screen.dart';
import 'package:instagram_clone/screen/profile_screen.dart';
import 'package:instagram_clone/screen/search_screen.dart';
import 'package:provider/provider.dart';

const webScreenSize = 600;

Future<String> getUid() async {
  return await FirebaseAuth.instance.currentUser!.uid;
}

List<Widget> homeScreenItem = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Text('notif'),
  ProfileScreen(uid: "NOT_OWN"),
];
