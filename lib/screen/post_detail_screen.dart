import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/post_card.dart';

class PostDetailScreen extends StatefulWidget {
  final snap;
  const PostDetailScreen({super.key, required this.snap});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.snap.toString());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Bài viết'),
        centerTitle: false,
      ),
      body: PostCard(snap: widget.snap),
    );
  }
}
