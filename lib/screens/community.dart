// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ia/common/loader.dart';
import 'package:ia/controllers/community_controller.dart';
import 'package:ia/layout/dimensions.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(
      communityNameController.text.trim(), 
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Create a community'),
      ),
      body: isLoading 
        ? Loader() 
        : Responsive(
          child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text('Community'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: communityNameController,
                decoration: InputDecoration(
                  hintText: 'r/Community_name',
                  filled: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
                maxLength: 21,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: createCommunity, 
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                child: Text(
                  'Create community',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
              ),
        ),
    );
  }
}