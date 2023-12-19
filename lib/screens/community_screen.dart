// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ia/auth/controller/auth_controller.dart';
import 'package:ia/common/loader.dart';
import 'package:ia/controllers/auth_controller.dart';
import 'package:ia/controllers/community_controller.dart';
import 'package:ia/error/error.dart';
// import 'package:ia/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../common/post_card.dart';
import '../community_model.dart';
import '../contract/controllers/user_profile_controller.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('/mod-tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref.read(communityControllerProvider.notifier).joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
        data: (community) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 150,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        community.banner,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),
                          radius: 35,
                        ),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'r/${community.name}',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if(!isGuest)
                          community.mods.contains(user.uid)
                            ? OutlinedButton(
                            onPressed: () {
                              navigateToModTools(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 25),
                            ),
                            child: Text('Mod Tools'),
                          ) :
                          OutlinedButton(
                            onPressed: () => joinCommunity(ref, community, context),
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 25),
                            ),
                            child: Text(community.members.contains(user.uid) ? 'Joined' : 'Join'),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          '${community.members.length} members',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ];
          }, 
          body: ref.watch(getCommunityPostsProvider(name)).when(
            data: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final post = data[index];
                  return PostCard(post: post);
                }
              );
            },  
            error: (error, stackTrace) {
        print(error);
        return ErrorText(error: error.toString());
      }, 
            loading: () => Loader(),
          ),
        ), 
        error: (error, stackTrace) {
        print(error);
        return ErrorText(error: error.toString());
      }, 
        loading: () => Loader(),
      ),
    );
  }
}