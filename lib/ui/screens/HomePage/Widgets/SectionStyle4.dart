// ignore_for_file: file_names

import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:news/app/routes.dart';
import 'package:news/data/models/FeatureSectionModel.dart';
import 'package:news/data/models/NewsModel.dart';
import 'package:news/ui/styles/colors.dart';
import 'package:news/ui/widgets/customTextLabel.dart';
import 'package:news/ui/widgets/networkImage.dart';
import 'package:news/utils/uiUtils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../../../utils/internetConnectivity.dart';
import '../../../widgets/SnackBarWidget.dart';
import '../../../widgets/createDynamicLink.dart';

class Style4Section extends StatelessWidget {
  final FeatureSectionModel model;

  Style4Section({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return style4Data(model, context);
  }

  ScreenshotController screenshotController = ScreenshotController();
  shareButton(NewsModel model, BuildContext context) async {
    print('this sahre');
    String base64Image = '';
    var im = await screenshotController
        .capture(pixelRatio: 2, delay: Duration(milliseconds: 10))
        .then((value) async {
      if (value == null) return;
      final tempDir = await getTemporaryDirectory();

      final file =
          await File('${tempDir.path}/${DateTime.now().toString()}.png')
              .create();
      await file.writeAsBytes(value!);

      base64Image = file.path.toString();
      final storageRef = FirebaseStorage.instance
          .ref('temt')
          .child(file.path.replaceFirst(tempDir.path, ''));
      await storageRef.putFile(file);
      final imageUrl = await storageRef.getDownloadURL();

      if (await InternetConnectivity.isNetworkAvailable()) {
        print('i am here');
        createDynamicLink(
            context: context,
            id: model!.id!,
            title: model!.title!,
            isVideoId: false,
            isBreakingNews: false,
            image: imageUrl);
      } else {
        showSnackBar(
            UiUtils.getTranslatedLabel(context, 'internetmsg'), context);
      }
    });
  }

  bool sharing = false;

  Widget style4Data(FeatureSectionModel model, BuildContext context) {
    print("Style 4 Data: ${model.newsType}");
    print("Style 4 Data: ${model.news!.length}");
    if (model.videos!.isNotEmpty || model.news!.isNotEmpty) {
      return Screenshot(
        controller: screenshotController,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: (model.newsType == 'news' ||
                  model.videosType == "news" ||
                  model.newsType == "user_choice")
              ? setGridLayout(
                  context: context,
                  totalCount: (model.newsType == 'news' ||
                          model.newsType == "user_choice")
                      ? model.news!.length
                      : model.videos!.length,
                  childWidget: (context, index) {
                    NewsModel data = (model.newsType == 'news' ||
                            model.newsType == "user_choice")
                        ? model.news![index]
                        : model.videos![index];
                    //  print("Data: ${data.title}");
                    return InkWell(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.7,
                        margin: const EdgeInsets.only(top: 10),
                        // padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: UiUtils.getColorScheme(context).background),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),

                            Stack(children: [
                              setNewsImage(
                                  context: context, imageURL: data.image!),
                              if (data.categoryName != null &&
                                  data.categoryName != "")
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Container(
                                      margin: const EdgeInsetsDirectional.only(
                                          start: 7.0, top: 7.0),
                                      height: 18.0,
                                      padding: const EdgeInsetsDirectional.only(
                                          start: 6.0, end: 6.0, top: 2.5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color:
                                              Theme.of(context).primaryColor),
                                      child: CustomTextLabel(
                                          text: data.categoryName!,
                                          textAlign: TextAlign.center,
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(color: secondaryColor),
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: true)),
                                ),
                              if (model.newsType == 'videos')
                                Positioned.directional(
                                  textDirection: Directionality.of(context),
                                  top: MediaQuery.of(context).size.height *
                                      0.065,
                                  start: MediaQuery.of(context).size.width / 6,
                                  end: MediaQuery.of(context).size.width / 6,
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pushNamed(
                                            Routes.newsVideo,
                                            arguments: {
                                              "from": 1,
                                              "model": data
                                            });
                                      },
                                      child: UiUtils.setPlayButton(
                                          context: context)),
                                ),
                            ]),
                            SizedBox(height: 5),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.alarm),
                                  SizedBox(width: 5),
                                  Text(
                                    DateFormat('h:mm a, d MMM')
                                        .format(DateTime.parse(data.date!)),
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                    onPressed: () {
                                      shareButton(data, context);
                                    },
                                    icon: Icon(
                                      Icons.share,
                                      size: 20,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                data.title!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                        color: UiUtils.getColorScheme(context)
                                            .primaryContainer,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: HtmlWidget(data.desc!,
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                            color:
                                                UiUtils.getColorScheme(context)
                                                    .primaryContainer)),
                              ),
                            ),

                            // Text(data.desc!,
                            //     style: Theme.of(context)
                            //         .textTheme
                            //         .bodySmall!
                            //         .copyWith(
                            //             color: UiUtils.getColorScheme(context)
                            //                 .primaryContainer)),
                          ],
                        ),
                      ),
                      onTap: () {
                        if (model.newsType == 'news' ||
                            model.newsType == "user_choice") {
                          List<NewsModel> newsList = [];
                          newsList.addAll(model.news!);
                          newsList.removeAt(index);
                          Navigator.of(context).pushNamed(Routes.newsDetails,
                              arguments: {
                                "model": data,
                                "newsList": newsList,
                                "isFromBreak": false,
                                "fromShowMore": false
                              });
                        }
                      },
                    );
                  })
              : Container(),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget setGridLayout(
      {required BuildContext context,
      required int totalCount,
      required Widget? Function(BuildContext, int) childWidget}) {
    return PageView.builder(
        scrollDirection: Axis.vertical,
        // padding: EdgeInsets.zero,
        //gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(mainAxisExtent: MediaQuery.of(context).size.height * 0.27, crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 13),
        // shrinkWrap: true,
        itemCount: totalCount,
        scrollBehavior: ScrollBehavior(),
        onPageChanged: (index) {
          print("Page Changed: $index");
        },
        //   physics: const NeverScrollableScrollPhysics(),
        itemBuilder: childWidget);
  }

  Widget setNewsImage(
      {required BuildContext context, required String imageURL}) {
    //print("Image URL: $imageURL");
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CustomNetworkImage(
          networkImageUrl: imageURL,
          height: MediaQuery.of(context).size.height * 0.32,
          width: MediaQuery.of(context).size.width * 1.2,
          fit: BoxFit.cover,
          isVideo: model.newsType == 'videos' ? true : false),
    );
  }
}
