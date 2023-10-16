import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/like_detail_card.dart';

class LikeDetailsScreen extends StatefulWidget {
  List snap;
  LikeDetailsScreen({super.key, required this.snap});

  @override
  State<LikeDetailsScreen> createState() => _LikeDetailsScreenState();
}

class _LikeDetailsScreenState extends State<LikeDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Lượt thích',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        centerTitle: false,
      ),
      body: widget.snap.isNotEmpty
          ? Column(
              children: [
                for (var idUser in widget.snap) LikeDetailCard(idUser: idUser)
              ],
            )
          : Container(
              alignment: Alignment.center,
              child: const Text(
                'Chưa có lượt thích nào 😢',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
              ),
            ),
    );
  }
}
