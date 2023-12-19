import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ia/core/common/error_text.dart';
// import 'package:ia/firebase_options.dart';
// import 'package:ia/models/user_model.dart';
// import 'package:ia/router.dart';
import 'package:ia/theme/pallete.dart';
import 'package:ia/user_model.dart';
// import 'package:reddit_tutorial/core/common/error_text.dart';
// import 'package:reddit_tutorial/core/common/loader.dart';
// import 'package:reddit_tutorial/features/auth/controlller/auth_controller.dart';
// import 'package:reddit_tutorial/firebase_options.dart';
// import 'package:reddit_tutorial/models/user_model.dart';
// import 'package:reddit_tutorial/router.dart';
// import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import 'common/loader.dart';
import 'controllers/auth_controller.dart';
import 'error/error.dart';
import 'routes/routes.dart';

// import 'core/common/loader.dart';
// import 'features/auth/controlller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if(kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDRxD1mKUDpJcAxmq0VlGupcon9n3kGpY0",
        authDomain: "honeybc039.firebaseapp.com",
        projectId: "honeybc039",
        storageBucket: "honeybc039.appspot.com",
        messagingSenderId: "627421571021",
        appId: "1:627421571021:web:cb6d1a92e719c7c5800684"
    ));
  } else {
    await Firebase.initializeApp();
  }
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
          data: (data) => MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Reddit Tutorial',
            theme: ref.watch(themeNotifierProvider),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (data != null) {
                  getData(ref, data);
                  if (userModel != null) {
                    return loggedInRoute;
                  }
                }
                return loggedOutRoute;
              },
            ),
            routeInformationParser: const RoutemasterParser(),
          ),
          error: (error, stackTrace) {
            print(error);
            return ErrorText(error: error.toString());
          },
          loading: () => const Loader(),
        );
  }
}
