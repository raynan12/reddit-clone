// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get/get.dart';
// import 'package:ia/auth/controller/auth_controller.dart';
import 'package:ia/common/loader.dart';
import 'package:ia/common/sign_in_button.dart';
import 'package:ia/constants/constants.dart';
import 'package:ia/layout/dimensions.dart';

import '../controllers/auth_controller.dart';
// import 'package:ia/controllers/login_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authControllerProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    // final controller = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          Constants.logoPath,
          height: 40,
        ),
        actions: [
          TextButton(
            onPressed: () => signInAsGuest(ref, context), 
            child: Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: isLoading 
        ? Loader() 
        : Column(
          children: [
            SizedBox(height: 30),
            Text(
              'Dive into anything',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Image.asset(
                Constants.loginEmotePath,
                height: 400,
              ),
            ),
          SizedBox(height: 20),
          Responsive(child: SignInButton()),
        ],
      ),
    );
  }
}