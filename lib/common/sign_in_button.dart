// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ia/auth/controller/auth_controller.dart';
import 'package:ia/constants/constants.dart';
// import 'package:ia/theme/theme.dart';

import '../controllers/auth_controller.dart';
import '../theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLigin;
  const SignInButton({super.key, this.isFromLigin = true});

  void signImWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context, isFromLigin);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
        onPressed: () => signImWithGoogle(context, ref),
        icon: Image.asset(
          Constants.googlePath, 
          width: 35,
        ),
        label: Text(
          'Continue with Google',
          style: TextStyle(fontSize: 18),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Pallete.greyColor,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}