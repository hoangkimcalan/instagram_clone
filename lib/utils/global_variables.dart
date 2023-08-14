import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screen/add_post_screen.dart';
import 'package:instagram_clone/screen/feed_screen.dart';
import 'package:instagram_clone/screen/notification_screen.dart';
import 'package:instagram_clone/screen/profile_screen.dart';
import 'package:instagram_clone/screen/search_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItem = [
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const NotificationScreen(),
  const ProfileScreen(uid: "NOT_OWN"),
];
