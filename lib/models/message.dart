class Message {
  Message({
    required this.toId,
    required this.fromId,
    required this.msg,
    this.readDate,
    required this.type,
    required this.sentDate,
  });

  late final String toId;
  late final String fromId;
  late final String msg;
  late final String? readDate;
  late final String sentDate;
  late final String type;

  Message.fromJson(Map<String, dynamic> json) {
    toId = json['toId'].toString();
    msg = json['msg'].toString();
    readDate = json['readDate'].toString();
    type = json['type'].toString();
    fromId = json['fromId'].toString();
    sentDate = json['sentDate'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['toId'] = toId;
    data['fromId'] = fromId;
    data['msg'] = msg;
    data['readDate'] = readDate;
    data['type'] = type;
    data['sentDate'] = sentDate;
    return data;
  }
}

enum Type { text, image }
