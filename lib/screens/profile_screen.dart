import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/resources/firestore_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/colors.dart';
import '../utils/utils.dart';
import '../widgets/follow_buton.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      // get post lENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length; 
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      following = userSnap.data()!['following'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(
        e.toString(),
        context,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(
                userData['username'],
              ),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              userData['photoUrl'],
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts"),
                                    buildStatColumn(followers, "followers"),
                                    buildStatColumn(following, "following"),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid ==
                                            widget.uid
                                        ? FollowButton(
                                            text: 'Sign Out',
                                            backgroundColor:
                                                mobileBackgroundColor,
                                            textColor: primaryColor,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              await AuthMethods().signOut();
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LoginScreen(),
                                                ),
                                              );
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                text: 'Unfollow',
                                                backgroundColor: Colors.white,
                                                textColor: Colors.black,
                                                borderColor: Colors.grey,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                text: 'Follow',
                                                backgroundColor: Colors.blue,
                                                textColor: Colors.white,
                                                borderColor: Colors.blue,
                                                function: () async {
                                                  await FireStoreMethods()
                                                      .followUser(
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid,
                                                    userData['uid'],
                                                  );

                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          userData['username'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    return GridView.builder(
                      shrinkWrap: true,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 1.5,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];

                        return Container(
                          child: Image(
                            image: NetworkImage(snap['postUrl']),
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    );
                  },
                )
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:instagram_clone/resources/auth_methods.dart';
// import 'package:instagram_clone/resources/firestore_methods.dart';
// import 'package:instagram_clone/screens/login_screen.dart';
// import 'package:instagram_clone/utils/colors.dart';
// import 'package:instagram_clone/utils/utils.dart';
// import 'package:instagram_clone/widgets/follow_buton.dart';

// class ProfileScreen extends StatefulWidget {
//   final String uid;
//   const ProfileScreen({super.key, required this.uid});

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   var userData = {};
//   var postleng = 0;
//   var followers = 0;
//   var following = 0;
//   bool isFollowing = false;
//   bool isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     getdata();
//   }

//   void getdata() async {
//     setState(() {
//       isLoading = true;
//     });
//     try {
//       var snap = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.uid)
//           .get();

//       userData = snap.data()!;

//       var postsnap = await FirebaseFirestore.instance
//           .collection('posts')
//           .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
//           .get();
//       postleng = postsnap.docs.length;
//       followers = snap.data()!['followers'].length;
//       following = snap.data()!['following'].length;
//       isFollowing = snap
//           .data()!['followers']
//           .contains(FirebaseAuth.instance.currentUser!.uid);

//       setState(() {});
//     } catch (e) {
//       showSnackBar(e.toString(), context);
//     }
//     setState(() {
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return isLoading
//         ? const Center(
//             child: CircularProgressIndicator(),
//           )
//         : Scaffold(
//             appBar: AppBar(
//               title: Text(userData['username']),
//             ),
//             body: ListView(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Row(
//                     children: [
//                       CircleAvatar(
//                         backgroundColor: Colors.grey,
//                         backgroundImage: userData['photoUrl'],
//                         radius: 40,
//                       ),
//                       Expanded(
//                         flex: 1,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             buildStatColumn(postleng, 'Posts'),
//                             buildStatColumn(followers, 'Followers'),
//                             buildStatColumn(following, 'Following'),
//                           ],
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           FirebaseAuth.instance.currentUser!.uid == widget.uid
//                               ? FollowButton(
//                                   backgroundColor: mobileBackgroundColor,
//                                   borderColor: Colors.grey,
//                                   text: ' Signout',
//                                   textColor: primaryColor,
//                                   function: () {
//                                     AuthMethods().signOut();
//                                     Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen(),));
//                                   },
//                                 )
//                               : isFollowing
//                                   ? FollowButton(
//                                       backgroundColor: Colors.white,
//                                       borderColor: Colors.grey,
//                                       text: 'Unfollow',
//                                       textColor: Colors.black,
//                                       function: () async {
//                                         FireStoreMethods().followUser(
//                                             FirebaseAuth
//                                                 .instance.currentUser!.uid,
//                                             userData['uid']);
//                                             setState(() {
//                                               isFollowing = false;
//                                               followers--;
//                                             });
//                                       },
//                                     )
//                                   : FollowButton(
//                                       backgroundColor: Colors.blue,
//                                       borderColor: Colors.white,
//                                       text: 'follow',
//                                       textColor: Colors.blue,
//                                       function: () {
//                                         FireStoreMethods().followUser(
//                                             FirebaseAuth
//                                                 .instance.currentUser!.uid,
//                                             userData['uid']);
//                                              setState(() {
//                                               isFollowing = true;
//                                               followers++;
//                                             });
//                                       },
//                                     )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: const EdgeInsets.only(top: 15),
//                   child: Text(
//                     userData['username'],
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   alignment: Alignment.centerLeft,
//                   padding: const EdgeInsets.only(top: 1),
//                   child: Text(
//                     userData['bio'],
//                   ),
//                 ),
//                 const Divider(),
//                 FutureBuilder(
//                   future: FirebaseFirestore.instance
//                       .collection('posts')
//                       .where('uid', isEqualTo: widget.uid)
//                       .get(),
//                   builder: (BuildContext context, AsyncSnapshot snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     return GridView.builder(
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisCount: 3,
//                               crossAxisSpacing: 5,
//                               mainAxisSpacing: 1.5),
//                       itemCount: (snapshot.data! as dynamic).docs.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         DocumentSnapshot snap =
//                             (snapshot.data! as dynamic).docs[index];
//                         return Container(
//                           child: Image(image: NetworkImage(snap['postUrl'])),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//   }

//   Column buildStatColumn(int num, String label) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(
//           num.toString(),
//           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//         ),
//         Container(
//           margin: const EdgeInsets.only(top: 5),
//           child: Text(
//             label,
//             style: const TextStyle(
//                 fontWeight: FontWeight.w400, fontSize: 15, color: Colors.grey),
//           ),
//         )
//       ],
//     );
//   }
// }
