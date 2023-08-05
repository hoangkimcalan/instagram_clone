import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String postId;
  late String? commentId;
  final String guestId;
  final bool isLike;
  final DateTime readDate;

  Notification({
    required this.postId,
    this.commentId,
    required this.guestId,
    required this.isLike,
    required this.readDate,
  });

  Map<String, dynamic> toJson() => {
        "postId": postId,
        "commentId": commentId,
        "guestId": guestId,
        "isLike": isLike,
        "readDate": readDate,
      };

  static Notification fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Notification(
      postId: snapshot['postId'],
      commentId: snapshot['commentId'],
      guestId: snapshot['guestId'],
      isLike: snapshot['isLike'],
      readDate: snapshot['readDate'],
    );
  }
}
