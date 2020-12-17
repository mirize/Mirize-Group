import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mirize/model/comment.dart';
import 'package:mirize/model/post.dart';

class FeedState {
  final String uid;
  FeedState({this.uid});
  final CollectionReference postsCollection =
      FirebaseFirestore.instance.collection("posts");

  List<Post> _postsDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Post(
        textPost: doc.get("textPost") ?? '',
        imagePath: doc.get('imagePath') ?? '',
        uidUser: doc.get('uidUser') ?? '',
        timeCreate: doc.get('timeCreate') ?? '',
        idPost: doc.get('idPost') ?? '',
      );
    }).toList();
  }

  List<Comment> _commentDatabase(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Comment(
        uidComment: doc.get('uidComment') ?? '',
        uidPost: doc.get('uidPost') ?? '',
        fromUserUID: doc.get('fromUserUID') ?? '',
        timeCreated: doc.get('timeCreated') ?? '',
        textComment: doc.get('textComment') ?? '',
      );
    }).toList();
  }

  Stream<List<Post>> get posts {
    return postsCollection.snapshots().map(_postsDatabase);
  }

  Stream<List<Comment>> get comment {
    return postsCollection
        .doc(uid)
        .collection("comment")
        .snapshots()
        .map(_commentDatabase);
  }
}
