import 'item.dart';

class Post {
  late final String postId;
  late final String postingDate;
  late final String postText;
  late final String itemName;
  late final String userName;
  late final String questionId;
  late final String userId;
  Post(
      {required this.postId,
      required this.postingDate,
      required this.postText,
      required this.itemName,
      required this.userName,
      required this.userId});
}
