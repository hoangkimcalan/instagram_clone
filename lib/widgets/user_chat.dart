import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';

class UserChat extends StatefulWidget {
  const UserChat({super.key});

  @override
  State<UserChat> createState() => _UserChatState();
}

class _UserChatState extends State<UserChat> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.grey[900],
      child: const ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1688607931530-4767bf468bca?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=464&q=80'),
          radius: 24,
        ),
        title: Text('Demo user'),
        subtitle: Text(
          'Last user message',
          maxLines: 1,
        ),
        trailing: Text(
          '12:00 PM',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
