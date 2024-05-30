// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/cubits/appLocalizationCubit.dart';
import 'package:news/utils/constant.dart';
import 'package:share_plus/share_plus.dart';

Future<void> createDynamicLink(
    {required BuildContext context,
    required String id,
    required String title,
    required bool isVideoId,
    required bool isBreakingNews,
    required String image}) async {
  try {
    print("createDynamicLink");
    print(title);
    print(image);
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: deepLinkUrlPrefix,
      link: Uri.parse(
          'https://$deeplinkURL/?id=$id&isVideoId=$isVideoId&isBreakingNews=$isBreakingNews&langId=${context.read<AppLocalizationCubit>().state.id}'),
      androidParameters:
          const AndroidParameters(packageName: packageName, minimumVersion: 1),
      iosParameters: const IOSParameters(
          bundleId: iosPackage, minimumVersion: '1', appStoreId: appStoreId),
      socialMetaTagParameters:
          SocialMetaTagParameters(title: title, imageUrl: Uri.parse(image)),
    );

    final ShortDynamicLink shortenedLink =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);
    var str = "$title\n\n";

    if (iosLink.isNotEmpty) str += "\n\n$iosLbl:\n$iosLink";
    print(str);
    print(shortenedLink.shortUrl.toString());

    Share.share("${shortenedLink.shortUrl.toString()}\n\n$str",
        subject: appName,
        sharePositionOrigin: Rect.fromLTWH(
            0,
            0,
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height / 2));
  } catch (e) {
    print(e);
  }
}
