
  import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CommentCard extends StatelessWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              snap.data()['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: snap.data()['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold,)
                        ),
                        TextSpan(
                          text: ' ${snap.data()['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        snap.data()['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400,),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(
              Icons.favorite,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:instagram_clone/model/user.dart';
// import 'package:instagram_clone/provider/user_provider.dart';
// import 'package:instagram_clone/utils/colors.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class CommentCard extends StatefulWidget {
//   const CommentCard({super.key,required this.snap});
//   final snap;
//   @override
//   State<CommentCard> createState() => _CommentCardState();
// }

// class _CommentCardState extends State<CommentCard> {
//   @override
//   Widget build(BuildContext context) {

//     final User user = Provider.of<UserProvider>(context).getUser;
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
//       child: Row(
//         children: [
//            CircleAvatar(
//             backgroundImage: NetworkImage(user.photoUrl),
//             backgroundColor: blueColor,
//             radius: 18,
//           ),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   RichText(
//                     text:  TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'comment as ${user.username}',
//                           style: const TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                          TextSpan(
//                           text: '   ${widget.snap['text']}',
//                         ),
//                       ],
//                     ),
//                   ),
//                    Padding(
//                     padding: EdgeInsets.only(left: 4),
//                     child: Text(
//                       DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
//                       style:
//                           TextStyle(fontWeight: FontWeight.w400, fontSize: 13),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(Icons.favorite),
//           ),
//         ],
//       ),
//     );
//   }
// }
