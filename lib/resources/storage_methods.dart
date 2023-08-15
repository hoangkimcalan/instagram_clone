import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();

      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> uploadImageMessageToStorage(
      String childName, Uint8List file, String chatUserId) async {
    Reference ref = _storage
        .ref()
        .child(childName)
        .child(FirestoreMethods().getConversation(chatUserId))
        .child('${DateTime.now().millisecondsSinceEpoch}');
    ;

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }

  Future<String> uploadImageMessageFromGalleryToStorage(
      String childName, File file, String chatUserId) async {
    Reference ref = _storage
        .ref()
        .child(childName)
        .child(FirestoreMethods().getConversation(chatUserId))
        .child('${DateTime.now().millisecondsSinceEpoch}');
    ;

    UploadTask uploadTask = ref.putFile(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }
}
