import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String toId;
  final String fromId;
  final String msg;
  final DateTime sendDate;
  final DateTime readDate;
  final Type type;

  const Message({
    required this.toId,
    required this.fromId,
    required this.msg,
    required this.sendDate,
    required this.readDate,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        'toId': toId,
        'fromId': fromId,
        'msg': msg,
        'sendDate': sendDate,
        'readDate': readDate,
        'type': type,
      };

  static Message fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Message(
      toId: snapshot['toId'],
      fromId: snapshot['fromId'],
      msg: snapshot['msg'],
      sendDate: snapshot['sendDate'],
      readDate: snapshot['readDate'],
      type: snapshot['type'],
    );
  }
}

enum Type { text, image }
