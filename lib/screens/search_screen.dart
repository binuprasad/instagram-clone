import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/utils/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration:
                const InputDecoration(labelText: 'Search for a user...'),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
              print(_);
            },
          ),
        ),
      ),
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .where(
                    'username',
                    isGreaterThanOrEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: (snapshot.data! as dynamic).docs[index]['uid'],
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            (snapshot.data! as dynamic).docs[index]['photoUrl'],
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          (snapshot.data! as dynamic).docs[index]['username'],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('datePublished')
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                  return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Image.network(
                      (snapshot.data! as dynamic).docs[index]['postUrl'],
                    );
                  },
                );
              },
            ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:instagram_clone/screens/profile_screen.dart';
// import 'package:instagram_clone/utils/colors.dart';

// class SearchScreen extends StatefulWidget {
//   const SearchScreen({super.key});

//   @override
//   State<SearchScreen> createState() => _SearchScreenState();
// }

// class _SearchScreenState extends State<SearchScreen> {
//   bool isShowUser = false;
//   final TextEditingController searchController = TextEditingController();

//   @override
//   void dispose() {
//     super.dispose();
//     searchController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mobileBackgroundColor,
//         title: TextFormField(
//           controller: searchController,
//           decoration: const InputDecoration(
//             labelText: 'Search for a user',
//           ),
//           onFieldSubmitted: (String _) {
//             setState(() {
//               isShowUser = true;
//             });
//           },
//         ),
//       ),
//       body: isShowUser
//           ? FutureBuilder(
//               future: FirebaseFirestore.instance
//                   .collection('user')
//                   .where('username',
//                       isGreaterThanOrEqualTo: searchController.text)
//                   .get(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 return ListView.builder(
//                   itemCount: (snapshot.data! as dynamic).docs.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return InkWell(
//                       onTap: () => Navigator.of(context).push(MaterialPageRoute(
//                         builder: (context) => ProfileScreen(
//                           uid: (snapshot.data! as dynamic).doc[index]['uid'],
//                         ),
//                       )),
//                       child: ListTile(
//                         leading: (snapshot.data! as dynamic).doc[index]
//                             ['photoUrl'],
//                         title: (snapshot.data! as dynamic).doc[index]
//                             ['username'],
//                       ),
//                     );
//                   },
//                 );
//               },
//             )
//           : FutureBuilder(
//               future: FirebaseFirestore.instance.collection('posts').get(),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (!snapshot.hasData) {
//                   return const Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 return GridView.builder(
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                   ),
//                   itemCount: (snapshot.data! as dynamic).docs.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     return Image.network(
//                       (snapshot.data! as dynamic).docs[index]['postUrl'],
//                     );
//                   },
//                 );
//               },
//             ),
//     );
//   }
// }
