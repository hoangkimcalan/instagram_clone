class Notifications {
  late final String notificationId;
  late final String postId;
  late final String ownId;
  late final String guestId;
  late final bool isLike;
  late final String readDate;
  late final String createdDate;

  Notifications({
    required this.notificationId,
    required this.postId,
    required this.ownId,
    required this.guestId,
    required this.isLike,
    required this.readDate,
    required this.createdDate,
  });

  Notifications.fromJson(Map<String, dynamic> json) {
    notificationId = json['notificationId'].toString();
    postId = json['postId'].toString();
    ownId = json['ownId'].toString();
    guestId = json['guestId'].toString();
    isLike = json['isLike'] ?? false;
    readDate = json['readDate'].toString();
    createdDate = json['createdDate'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['notificationId'] = notificationId;
    data['postId'] = postId;
    data['ownId'] = ownId;
    data['guestId'] = guestId;
    data['isLike'] = isLike;
    data['readDate'] = readDate;
    data['createdDate'] = createdDate;
    return data;
  }
}
