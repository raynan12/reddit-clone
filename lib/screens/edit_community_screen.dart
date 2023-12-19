// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ia/common/loader.dart';
import 'package:ia/constants/constants.dart';
import 'package:ia/controllers/community_controller.dart';
import 'package:ia/error/error.dart';
import 'package:ia/layout/dimensions.dart';
// import 'package:ia/models/community_model.dart';
import 'package:ia/theme/pallete.dart';
// import 'package:ia/theme/theme.dart';
import 'dart:io';

import 'package:ia/utils/utils.dart';

import '../community_model.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    super.key,
    required this.name,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;

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

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
      profileFile: profileFile, 
      bannerFile: bannerFile, 
      context: context, 
      community: community,
      profileWebFile: profileWebFile,
      bannerWebFile: bannerWebFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getCommunityByNameProvider(widget.name)).when(
      data: (community) => Scaffold(
        backgroundColor: currentTheme.backgroundColor,
        appBar: AppBar(
          title: Text('Edit Community'),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: () => save(community), 
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
                                : community.banner.isEmpty || community.banner == Constants.bannerDefault
                                  ? Center(
                                    child: Icon(
                                      Icons.camera_alt_outlined,
                                      size: 40,
                                    ),
                                  ) 
                                  : Image.network(community.banner),
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
                                backgroundImage: NetworkImage(community.avatar),
                                radius: 32,
                            ),
                          ),
                        ),
                      ],
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