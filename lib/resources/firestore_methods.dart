import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:instagram_clone/models/notification.dart';
import 'package:instagram_clone/models/post.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/models/message.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseMessaging fMessaging = FirebaseMessaging.instance;

  static late model.User me;

  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "some error occurred";

    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
      );

      _firestore.collection('posts').doc(postId).set(post.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> pushNotificationReactPost(
      String postId, String guestId, String ownId, bool isLike) async {
    try {
      String notificationId = const Uuid().v1();

      Notification notifi = Notification(
        notificationId: notificationId,
        postId: postId,
        ownId: ownId,
        guestId: guestId,
        isLike: isLike,
        readDate: '',
      );

      _firestore
          .collection('notifications')
          .doc(notificationId)
          .set(notifi.toJson());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> likeComment(
      String postId, String commentId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': []
        });
      } else {
        log('Text is empty');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> followUser(String uid, String followId) async {
    DocumentSnapshot userSnap =
        await _firestore.collection('users').doc(uid).get();

    List following = (userSnap.data()! as dynamic)['following'];

    try {
      if (following.contains(followId)) {
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });

        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
      } else {
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  String getConversation(String id) =>
      AuthMethods().getUserId().hashCode <= id.hashCode
          ? '${AuthMethods().getUserId()}_$id'
          : '${id}_${AuthMethods().getUserId()}';

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      String userChatId) {
    return _firestore
        .collection('chats/${getConversation(userChatId)}/messages/')
        .orderBy('sentDate', descending: true)
        .snapshots();
  }

  //MESSAGE
  Future<void> sendMessage(String userChatId, String msg, String type) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
      toId: userChatId,
      fromId: AuthMethods().getUserId(),
      msg: msg,
      sentDate: time,
      type: type,
      readDate: '',
    );

    await _firestore
        .collection('chats/${getConversation(userChatId)}/messages/')
        .doc(time)
        .set(message.toJson())
        .then((value) => sendPushNotificationMessage(
            userChatId, type == 'text' ? msg : 'sent image'));
  }

  Future<void> updateMessageReadStatus(Message message) async {
    await _firestore
        .collection('chats/${getConversation(message.fromId)}/messages/')
        .doc(message.sentDate)
        .update({'readDate': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(String userId) {
    return _firestore
        .collection('chats/${getConversation(userId)}/messages/')
        .orderBy('sentDate', descending: true)
        .limit(1)
        .snapshots();
  }

  Future<void> uploadImageMessage(Uint8List file, String userChatId) async {
    try {
      String photoUrl = await StorageMethods().uploadImageMessageToStorage(
          'messages', file, getConversation(userChatId));

      await sendMessage(userChatId, photoUrl, 'image');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> uploadImageMessageFromGalley(
      File file, String userChatId) async {
    try {
      String photoUrl = await StorageMethods()
          .uploadImageMessageFromGalleryToStorage(
              'messages', file, getConversation(userChatId));

      await sendMessage(userChatId, photoUrl, 'image');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> updateActiveStatus(bool isOnline) async {
    _firestore.collection('users').doc(AuthMethods().getUserId()).update({
      'isOnline': isOnline,
      'lastActive': DateTime.now(),
      'pushToken': me.pushToken,
    });
  }

  Future<void> getFirebaseMessagingToken() async {
    await fMessaging.requestPermission();

    await fMessaging.getToken().then((token) {
      if (token != null) {
        me.pushToken = token;
        log('Push Token: $token');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('Got a message whilist in foreground');
      log('Message data: $message');
      if (message.notification != null) {
        log('Message also contained a notification: ${message.notification}');
      }
    });
  }

  Future<void> getSelfInfo() async {
    DocumentSnapshot snap = await _firestore
        .collection('users')
        .doc(AuthMethods().getUserId())
        .get();
    if (snap.exists) {
      me = model.User.fromSnap(snap);
      await getFirebaseMessagingToken();
      log('My Data: ${snap.data()}');
    }
    FirestoreMethods().updateActiveStatus(true);
  }

  Future<void> sendPushNotificationMessage(String userId, String msg) async {
    DocumentSnapshot userSnap =
        await _firestore.collection('users').doc(userId).get();
    try {
      final body = {
        "notification": {
          "body": msg,
          "title": (userSnap.data()! as dynamic)['username'],
          "android_channel_id": "chats",
        },
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": (userSnap.data()! as dynamic)['uid'],
          "status": "done"
        },
        "to": (userSnap.data()! as dynamic)['pushToken'],
      };
      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAA8UqfW4w:APA91bGbvx66bI66X-EyOmxsnlLhKVBSr4F9xEdcu6dJ4e6yV_vEiw017APtUx2ScIUb0BF5bhWbylNUC437z7vN6N1MitLozPHqckIOX0Pf776kdS8W7wVgST6UNg4rBwh-lQSq4ow2'
              },
              body: jsonEncode(body));
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log('\nsendPushNotificationF: $e');
    }
  }

  Future<void> sendPushNotificationComment(String userId, String msg) async {
    DocumentSnapshot userSnap =
        await _firestore.collection('users').doc(userId).get();
    try {
      final body = {
        "notification": {
          "body": msg,
          "title": (userSnap.data()! as dynamic)['username'],
          "android_channel_id": "chats",
        },
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "id": (userSnap.data()! as dynamic)['uid'],
          "status": "done"
        },
        "to": (userSnap.data()! as dynamic)['pushToken'],
      };
      var response =
          await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader:
                    'key=AAAA8UqfW4w:APA91bGbvx66bI66X-EyOmxsnlLhKVBSr4F9xEdcu6dJ4e6yV_vEiw017APtUx2ScIUb0BF5bhWbylNUC437z7vN6N1MitLozPHqckIOX0Pf776kdS8W7wVgST6UNg4rBwh-lQSq4ow2'
              },
              body: jsonEncode(body));
      log('Response status: ${response.statusCode}');
      log('Response body: ${response.body}');
    } catch (e) {
      log('\nsendPushNotificationF: $e');
    }
  }
}
