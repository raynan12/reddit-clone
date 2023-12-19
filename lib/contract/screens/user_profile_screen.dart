// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ia/common/post_card.dart';
import 'package:ia/contract/controllers/user_profile_controller.dart';
import 'package:routemaster/routemaster.dart';

// import '../../auth/controller/auth_controller.dart';
import '../../common/loader.dart';
import '../../controllers/auth_controller.dart';
import '../../error/error.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({
    super.key,
    required this.uid,
  });

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
  
    return Scaffold(
      body: ref.watch(getUserDataProvider(uid)).when(
        data: (user) => NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250,
                floating: true,
                snap: true,
                flexibleSpace: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        user.banner,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.all(20).copyWith(bottom: 70),
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 45,
                      ),
                    ),
                    Container(
                      alignment: Alignment.bottomLeft,
                      padding: EdgeInsets.all(20),
                      child: OutlinedButton(
                          onPressed: () => navigateToEditUser(context),
                          style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 25),
                        ),
                        child: Text('Edit Profile'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'u/${user.name}',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          '${user.karma} karma',
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(thickness: 2),
                    ],
                  ),
                ),
              ),
            ];
          }, 
          body: ref.watch(getUserPostsProvider(uid)).when(
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