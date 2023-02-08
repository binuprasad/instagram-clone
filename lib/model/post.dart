import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String discription;
  final String uid;
  final String postUrl;
  final String username;
  final DateTime datePublished;
  final String postId;
  final String profImage;
  final likes;

  const Post({
    required this.discription,
    required this.postUrl,
    required this.datePublished,
    required this.postId,
    required this.profImage,
    required this.likes,
    required this.uid,
    required this.username,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'uid': uid,
        'postUrl': postUrl,
        'datePublished': datePublished,
        'postId': postId,
        'profImage': profImage,
        'discription': discription,
        'likes': likes,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        username: snapshot['username'],
        uid: snapshot['uid'],
        postUrl: snapshot['postUrl'].toString(),
        datePublished: snapshot['datePublished'],
        postId: snapshot['postId'].toString(),
        profImage: snapshot['profImage'].toString(),
        discription: snapshot['discription'], likes: snapshot['likes']);
  }
}
