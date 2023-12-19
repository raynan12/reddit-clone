// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ia/auth/controller/auth_controller.dart';
import 'package:ia/common/loader.dart';
import 'package:ia/common/sign_in_button.dart';
import 'package:ia/controllers/auth_controller.dart';
// import 'package:ia/controllers/community_controller.dart';
import 'package:ia/controllers/community_controller.dart';
import 'package:ia/error/error.dart';
// import 'package:ia/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../community_model.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push('/r/${community.name}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            isGuest ? SignInButton() :
            ListTile(
              title: Text('Create a community'),
              leading: Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            if(!isGuest)
            ref.watch(userCommunitiesProvider).when(data: (communities) => Expanded(
              child: ListView.builder(
                itemCount: communities.length,
                itemBuilder: (BuildContext context, int index) {
                  final community = communities[index];
                  return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(community.avatar),
                      ),
                      title: Text('r/${community.name}'),
                      onTap: () {
                        navigateToCommunity(context, community);
                      },
                    );
                  },
                ),
            ), 
              error: (error, stackTrace) {
        print(error);
        return ErrorText(error: error.toString());
      },  
              loading: () => Loader(),
            ),
          ],
        ),
      ),
    );
  }
}