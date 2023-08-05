import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  final String notificationId;
  final String postId;
  final String ownId;
  final String guestId;
  final bool isLike;
  final String readDate;

  Notification({
    required this.notificationId,
    required this.postId,
    required this.ownId,
    required this.guestId,
    required this.isLike,
    required this.readDate,
  });

  Map<String, dynamic> toJson() => {
        "notificationId": notificationId,
        "postId": postId,
        "ownId": ownId,
        "guestId": guestId,
        "isLike": isLike,
        "readDate": readDate,
      };

  static Notification fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Notification(
      notificationId: snapshot['notificationId'],
      postId: snapshot['postId'],
      ownId: snapshot['ownId'],
      guestId: snapshot['guestId'],
      isLike: snapshot['isLike'],
      readDate: snapshot['readDate'],
    );
  }
}
