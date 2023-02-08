
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/model/user.dart';
import 'package:instagram_clone/provider/user_provider.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/utils/utils.dart';
import 'package:instagram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';
import '../utils/colors.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();

  void postComment(String uid, String name, String profilePic) async {
    try {
      String res = await FireStoreMethods() .postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,
      );

      if (res != 'success') {
        showSnackBar( res,context);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
       
        err.toString(), context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text(
          'Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index) => CommentCard(
              snap: snapshot.data!.docs[index],
            ),
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  user.uid,
                  user.username,
                  user.photoUrl,
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:instagram_clone/model/user.dart';
// import 'package:instagram_clone/provider/user_provider.dart';
// import 'package:instagram_clone/resources/firestore_methods.dart';
// import 'package:instagram_clone/utils/colors.dart';
// import 'package:instagram_clone/widgets/comment_card.dart';
// import 'package:provider/provider.dart';

// class CommentScreen extends StatefulWidget {
//   final snap;
//   const CommentScreen({super.key, required this.snap});

//   @override
//   State<CommentScreen> createState() => _CommentScreenState();
// }

// class _CommentScreenState extends State<CommentScreen> {
//   final TextEditingController commentcontroller = TextEditingController();
//   @override
//   void dispose() {
//     super.dispose();
//     commentcontroller.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final User user = Provider.of<UserProvider>(context).getUser;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         title: const Text('comment'),
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('posts')
//             .doc(widget.snap['postId'])
//             .collection('commmets')
//             .snapshots(),
//         builder: (BuildContext context,   AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot ) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           return ListView.builder(
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (BuildContext context, int index) {
//               return CommentCard(
//                 snap: (snapshot.data! as dynamic).docs[index].data,
//               );
//             },
//           );
//         },
//       ),
//       bottomNavigationBar: SafeArea(
//         child: Container(
//           height: kToolbarHeight,
//           margin: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           padding: const EdgeInsets.only(left: 16, right: 8),
//           child: Row(
//             children: [
//                CircleAvatar(
//                 backgroundImage: NetworkImage(widget. snap.data()['profilePic']),
//                 backgroundColor: Colors.red,
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.only(left: 16.0, right: 8.0),
//                   child: TextFormField(
//                     controller: commentcontroller,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       hintText: 'comment as username',
//                     ),
//                   ),
//                 ),
//               ),
//               InkWell(
//                 onTap: () async {
//                   await FireStoreMethods().postComment(
//                     widget.snap['postId'],
//                     commentcontroller.text,
//                     user.uid,
//                     user.username,
//                     user.photoUrl,
//                   );
//                   setState(() {
//                     commentcontroller.text = '';
//                   });
//                 },
//                 child: const Text(
//                   'Post',
//                   style: TextStyle(color: Colors.blueAccent),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

