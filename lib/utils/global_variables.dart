import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/screens/add_post_screen.dart';
import 'package:instagram_clone/screens/feed_screen.dart';
import 'package:instagram_clone/screens/profile_screen.dart';
import 'package:instagram_clone/screens/search_screen.dart';

const webScreensize = 600;
 List<Widget> homeScreenItems = [
  const FeedScreen(),
 const SearchScreen(),
  const AddPostScreen(),
  const Text('scren 4'),
 ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid,),
];
