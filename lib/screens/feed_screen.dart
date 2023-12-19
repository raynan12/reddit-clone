import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ia/auth/controller/auth_controller.dart';
import 'package:ia/common/loader.dart';
import 'package:ia/common/post_card.dart';
import 'package:ia/controllers/auth_controller.dart';
import 'package:ia/controllers/community_controller.dart';
import 'package:ia/core/error/error.dart';
import 'package:ia/post/controller/post_controller.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:reddit_tutorial/core/common/error_text.dart';
// import 'package:reddit_tutorial/core/common/loader.dart';
// import 'package:reddit_tutorial/core/common/post_card.dart';
// import 'package:reddit_tutorial/features/auth/controlller/auth_controller.dart';
// import 'package:reddit_tutorial/features/community/controller/community_controller.dart';
// import 'package:reddit_tutorial/features/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
            data: (communities) => ref.watch(userPostsProvider(communities)).when(
                  data: (data) {
                    return ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final post = data[index];
                        return PostCard(post: post);
                      },
                    );
                  },
                  error: (error, stackTrace) {
            print(error);
            return ErrorText(error: error.toString());
          },
                  loading: () => const Loader(),
                ),
            error: (error, stackTrace) {
            print(error);
            return ErrorText(error: error.toString());
          },
            loading: () => const Loader(),
          );
    }
    return ref.watch(userCommunitiesProvider).when(
          data: (communities) => ref.watch(guestPostsProvider).when(
                data: (data) {
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      final post = data[index];
                      return PostCard(post: post);
                    },
                  );
                },
                error: (error, stackTrace) {
            print(error);
            return ErrorText(error: error.toString());
          },
                loading: () => const Loader(),
              ),
          error: (error, stackTrace) {
            print(error);
            return ErrorText(error: error.toString());
          },
          loading: () => const Loader(),
        );
  }
}

// class FeedScreen extends ConsumerWidget {
//   const FeedScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(userProvider)!;
//     final isGuest = !user.isAuthenticated;

//     if(!isGuest) {
//     return ref.watch(userCommunitiesProvider).when(
//       data: (communities) => ref.watch(userPostsProvider(communities)).when(
//         data: (data) {
//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (BuildContext context, int index) {
//               final post = data[index];
//               return PostCard(post: post);
//             },
//           );
//         }, 
//         error: (error, stackTrace) {
//           // print(error);
//           return ErrorText(
//             error: error.toString(),
//           );  
//         },
//         loading: () => Loader(),
//       ), 
//        error: (error, stackTrace) {
//         print(error);
//         return ErrorText(error: error.toString());
//       }, 
//         loading: () => Loader(),
//       );
//     }
//     return ref.watch(userCommunitiesProvider).when(
//       data: (communities) => ref.watch(guestPostProvider).when(
//         data: (data) {
//           return ListView.builder(
//             itemCount: data.length,
//             itemBuilder: (BuildContext context, int index) {
//               final post = data[index];
//               return PostCard(post: post);
//             },
//           );
//         }, 
//         error: (error, stackTrace) {
//           print(error);
//           return ErrorText(
//             error: error.toString(),
//           );  
//         },
//         loading: () => Loader(),
//       ), 
//        error: (error, stackTrace) {
//         print(error);
//         return ErrorText(error: error.toString());
//       }, 
//         loading: () => Loader(),
//     );
//   }
// }