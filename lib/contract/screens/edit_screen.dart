// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:ia/auth/controller/auth_controller.dart';
import 'package:ia/contract/controllers/user_profile_controller.dart';
import 'package:ia/controllers/auth_controller.dart';
import 'package:ia/layout/dimensions.dart';
import 'package:ia/theme/pallete.dart';
// import 'package:ia/contract/res/user_res.dart';

import '../../common/loader.dart';
import '../../constants/constants.dart';
import '../../error/error.dart';
// import '../../theme/theme.dart';
import '../../utils/utils.dart';

class EditiProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditiProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditiProfileScreenState();
}

class _EditiProfileScreenState extends ConsumerState<EditiProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController nameController;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if(res != null) {
      if(kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
      
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if(res != null) {
      if(kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editCommunity(
      profileFile: profileFile, 
      bannerFile: bannerFile, 
      context: context, 
      name: nameController.text.trim(),
      bannerWebFile: bannerWebFile,
      profileWebFile: profileWebFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
      data: (user) => Scaffold(
        backgroundColor: currentTheme.backgroundColor,
        appBar: AppBar(
          title: Text('Edit Profile'),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: save, 
              child: Text('Save'),
            ),
          ],
        ),
        body: isLoading 
          ? Loader() 
          : Responsive(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: selectBannerImage,
                          child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: Radius.circular(10),
                            dashPattern: [10, 4],
                            strokeCap: StrokeCap.round,
                            color: currentTheme.textTheme.bodyText2!.color!,
                            child: Container(
                              width: double.infinity,
                              height: 150,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: bannerWebFile != null
                                  ? Image.memory(bannerWebFile!)
                                  : bannerFile != null
                                ? Image.file(bannerFile!)
                                : user.banner.isEmpty || user.banner == Constants.bannerDefault
                                  ? Center(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                    ),
                                  ) 
                                  : Image.network(user.banner),
                              ),
                            ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: GestureDetector(
                            onTap: selectProfileImage,
                            child: profileWebFile != null
                                  ? CircleAvatar(
                                    backgroundImage: MemoryImage(profileWebFile!),
                                    radius: 32 
                                  ) 
                                  : profileFile != null
                              ? CircleAvatar(
                                backgroundImage: FileImage(profileFile!),
                                radius: 32 
                                ) 
                              : CircleAvatar(
                                backgroundImage: NetworkImage(user.profilePic),
                                radius: 32,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      filled: true,
                      hintText: 'Name',
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      loading: () => Loader(),
      error: (error, stackTrace) {
        print(error);
        return ErrorText(error: error.toString());
      }, 
    );
  }
}