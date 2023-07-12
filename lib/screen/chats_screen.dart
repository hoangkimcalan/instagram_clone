import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/widgets/user_chat.dart';
import 'package:instagram_clone/models/user.dart' as model;

class ChatScreens extends StatefulWidget {
  const ChatScreens({super.key});

  @override
  State<ChatScreens> createState() => _ChatScreensState();
}

class _ChatScreensState extends State<ChatScreens> {
  final List<model.User> _searchList = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: mobileBackgroundColor,
            centerTitle: false,
            leading: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.arrow_back_ios_new),
            ),
            title: _isSearching
                ? TextFormField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter username...',
                    ),
                    onFieldSubmitted: (String _) {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                    autofocus: true,
                    onTapOutside: (event) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    style: const TextStyle(fontSize: 17, letterSpacing: 0.5),
                  )
                : const Text('Chat'),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    _searchController.text = "";
                  });
                },
                icon: Icon(
                    _isSearching ? Icons.clear_rounded : Icons.search_sharp),
              ),
            ],
          ),
          body: StreamBuilder(
            stream: _isSearching
                ? FirebaseFirestore.instance
                    .collection('users')
                    .where('username', isEqualTo: _searchController.text)
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('users')
                    .where('uid',
                        isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return UserChat(
                      snap: snapshot.data!.docs[index].data(),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
