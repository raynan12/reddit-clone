// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:ia/admin/add_moders_screen.dart';
import 'package:ia/auth/login.dart';
import 'package:ia/contract/screens/edit_screen.dart';
import 'package:ia/contract/screens/user_profile_screen.dart';
import 'package:ia/home/home.dart';
import 'package:ia/messages/comment_screen.dart';
import 'package:ia/screens/add_post_screen.dart';
import 'package:ia/screens/add_post_type.dart';
import 'package:ia/screens/community.dart';
import 'package:ia/screens/edit_community_screen.dart';
import 'package:ia/screens/mod_tools.dart';
import 'package:routemaster/routemaster.dart';

import '../screens/community_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(child: HomeScreen()),
  '/create-community': (_) => MaterialPage(child: CreateCommunityScreen()),
  '/r/:name': (route) => MaterialPage(
    child: CommunityScreen(
      name: route.pathParameters['name']!,
    ),
  ),
  '/mod-tools/:name': (routeData) => MaterialPage(
    child: ModToolsScreen(
      name: routeData.pathParameters['name']!,
    ),
  ),
  '/edit-community/:name': (routeData) => MaterialPage(
    child: EditCommunityScreen(
      name: routeData.pathParameters['name']!,
    ),
  ),
  '/add-mods/:name': (routeData) => MaterialPage(
    child: AddModsScreen(
      name: routeData.pathParameters['name']!,
    ),
  ),
  '/u/:uid': (routeData) => MaterialPage(
    child: UserProfileScreen(
      uid: routeData.pathParameters['uid']!,
    ),
  ),
  '/edit-profile/:uid': (routeData) => MaterialPage(
    child: EditiProfileScreen(
      uid: routeData.pathParameters['uid']!,
    ),
  ),
  '/add-post/:type': (routeData) => MaterialPage(
    child: AddPostTypeScreen(
      type: routeData.pathParameters['type']!,
    ),
  ),
  '/post/:postId/comments': (route) => MaterialPage(
    child: CommentScreen(
      postId: route.pathParameters['postId']!,
    ),
  ),
  '/add-post': (routeData) => MaterialPage(
    child: AddPostScreen(),
  ),
});