// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ia/auth/controller/auth_controller.dart';
import 'package:ia/constants/constants.dart';
import 'package:ia/controllers/auth_controller.dart';
import 'package:ia/private/profile.dart';
import 'package:ia/src/search.dart';
import 'package:ia/theme/pallete.dart';
// import 'package:ia/theme/theme.dart';
import 'package:routemaster/routemaster.dart';

import '../stack/drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
} 

  class _HomeScreenState extends ConsumerState<HomeScreen> {
    int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    final currentTheme = ref.watch(themeNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        centerTitle: false,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => displayDrawer(context), 
            );
          }
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchCommunityDelegate(ref));
            }, 
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Routemaster.of(context).push('/add-post');
            }, 
            icon: Icon(Icons.add),
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundImage: NetworkImage(user.profilePic),
                ),
                onPressed: () => displayEndDrawer(context), 
              );
            }
          ),
        ],
      ),
      body: Constants.tabWidgets[_page],
      drawer: CommunityListDrawer(),
      endDrawer: isGuest ? null : ProfileDrawer(),
      bottomNavigationBar: isGuest || kIsWeb
      ? null 
      : CupertinoTabBar(
        activeColor: currentTheme.iconTheme.color,
        backgroundColor: currentTheme.backgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: '',
          ),
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
    );
  }
}