// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ia/auth/controller/auth_controller.dart';
import 'package:ia/common/loader.dart';
import 'package:ia/controllers/community_controller.dart';
import 'package:ia/core/error/error.dart';

import '../controllers/auth_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({super.key, required this.name});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int ctr = 0;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveMods() {
    ref.read(communityControllerProvider.notifier).addMods(
      widget.name, 
      uids.toList(), 
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods, 
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community) => ListView.builder(
          itemCount: community.members.length,
          itemBuilder: (BuildContext context, int index) {
            final member = community.members[index];

            return ref.watch(getUserDataProvider(member)).when(
              data: (user) {
                if(community.mods.contains(member) && ctr == 0) {
                  uids.add(member);
                }
                ctr++;
                return CheckboxListTile(
                  value: uids.contains(user.uid), 
                  onChanged: (val) {
                    if(val!) {
                      addUid(user.uid);
                    } else {
                      removeUid(user.uid);
                    }
                  },
                  title: Text(user.name),
                );
              }, 
              error: (error, stackTrace) {
                print(error);
                return ErrorText(error: error.toString());
              }, 
              loading: () => Loader(),
            );
          },
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