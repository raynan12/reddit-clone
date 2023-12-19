// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ia/auth/controller/auth_controller.dart';
import 'package:ia/common/post_card.dart';
import 'package:ia/controllers/auth_controller.dart';
import 'package:ia/layout/dimensions.dart';
// import 'package:ia/models/post_model.dart';
import 'package:ia/post/controller/post_controller.dart';
import 'package:ia/widgets/comment_card.dart';

import '../common/loader.dart';
import '../error/error.dart';
import '../post_model.dart';

class CommentScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentScreen({super.key, required this.postId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentScreenState();
}

class _CommentScreenState extends ConsumerState<CommentScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
      context: context, 
      text: commentController.text.trim(), 
      post: post,
    );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
        data: (data) {
          return Column(
            children: [
              PostCard(post: data),
              if(!isGuest)
              Responsive(
                child: TextField(
                  onSubmitted: (val) => addComment(data),
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'What are your thoughts?',
                    filled: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              ref.watch(getPostCommentsProvider(widget.postId)).when(
                data: (data) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final comment = data[index];
                        return CommentCard(comment: comment);
                      },
                    ),
                  );
                }, 
                error: (error, stackTrace) {
                  print(error.toString());
                  return ErrorText(
                    error: error.toString(),
                  );
                }, 
                loading: () => Loader(),
              ),
            ],
          );
        }, 
        error: (error, stackTrace) {
        print(error);
        return ErrorText(error: error.toString());
      },  
        loading: () => Loader(),
      ),
    );
  }
}