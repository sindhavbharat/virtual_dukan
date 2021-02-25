import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:virtual_dukan/design_course/course_info_screen.dart';
import 'package:virtual_dukan/design_course/models/course_details_list.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:virtual_dukan/utils_data/fintness_app_theme.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CourseDetails extends StatefulWidget {
  final int id;

  CourseDetails({this.id});

  @override
  _CourseDetailsState createState() => _CourseDetailsState();
}

class _CourseDetailsState extends State<CourseDetails>
    with TickerProviderStateMixin {
  ProgressDialog _progressDialog;
  AnimationController animationController;
  Animation<double> topBarAnimation;
  final DateFormat formatter = DateFormat('dd-MMM-yyyy hh:mm a');
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  int length;
  final DateFormat dateShowFormat = DateFormat('dd MMM');
  final DateTime currentDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState

    print('get id ${widget.id}');
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);

    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

//  @override
//  void dispose() {
//    // TODO: implement dispose
//    super.dispose();
//    animationController.dispose();
//  }
  @override
  Widget build(BuildContext context) {
    _progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
    return Container(
      color: FintnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Transform(
                transform: Matrix4.translationValues(
                    0.0, 30 * (1.0 - topBarAnimation.value), 0.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: FintnessAppTheme.white.withOpacity(topBarOpacity),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: FintnessAppTheme.grey
                              .withOpacity(0.4 * topBarOpacity),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).padding.top,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 16 - 8.0 * topBarOpacity,
                            bottom: 12 - 8.0 * topBarOpacity),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Container(
                                width: AppBar().preferredSize.height - 8,
                                height: AppBar().preferredSize.height - 8,
                                child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: AppTheme.darkText,
                                    ),
                                    onPressed: () =>
                                        Navigator.of(context).pop()),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Course',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FintnessAppTheme.fontName,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 22 + 6 - 6 * topBarOpacity,
                                    letterSpacing: 1.2,
                                    color: FintnessAppTheme.darkerText,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_left,
                                    color: FintnessAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      Icons.calendar_today,
                                      color: FintnessAppTheme.grey,
                                      size: 18,
                                    ),
                                  ),
                                  Text(
                                    dateShowFormat.format(currentDate),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontFamily: FintnessAppTheme.fontName,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 18,
                                      letterSpacing: -0.2,
                                      color: FintnessAppTheme.darkerText,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 38,
                              width: 38,
                              child: InkWell(
                                highlightColor: Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0)),
                                onTap: () {},
                                child: Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_right,
                                    color: FintnessAppTheme.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        )
      ],
    );
  }

  Future<CourseDetailsList> getData() async {
//    _progressDialog.setMessage(UtilsData.kLoadingMsg);
//    _progressDialog.show();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kCourseDetailsMethod + '/${widget.id}',
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
//      _progressDialog.hide();
    if (response.statusCode == 200) {
      return CourseDetailsList.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: UtilsData.kOops,
        desc: UtilsData.kMultiLoginMsg,
        btnCancel: null,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        btnOkOnPress: () {
          preferences.clear();
          exit(0);
        },
      )..show();
    } else {
      throw Exception('Failed to load course list');
    }
  }

  Widget getMainListViewUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: FutureBuilder<CourseDetailsList>(
        future: getData(),
        builder:
            (BuildContext context, AsyncSnapshot<CourseDetailsList> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              child: Center(
                  child: CircularProgressIndicator(
                strokeWidth: 5,
                backgroundColor: Colors.blue,
              )),
            );
          } else {
            length = snapshot.data.course.videos.length;
            return ListView.builder(
              controller: scrollController,
              padding: EdgeInsets.only(
                top: AppBar().preferredSize.height +
                    MediaQuery.of(context).padding.top +
                    24,
                bottom: 62 + MediaQuery.of(context).padding.bottom,
              ),
              itemCount: length,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                animationController.forward();
                return AnimatedBuilder(
                  animation: animationController,
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / length) * 0, 1.0,
                                  curve: Curves.fastOutSlowIn))),
                      child: new Transform(
                        transform: new Matrix4.translationValues(
                            0.0,
                            30 *
                                (1.0 -
                                    Tween<double>(begin: 0.0, end: 1.0)
                                        .animate(CurvedAnimation(
                                            parent: animationController,
                                            curve: Interval(
                                                (1 / length) * 0, 1.0,
                                                curve: Curves.fastOutSlowIn)))
                                        .value),
                            0.0),
                        child: InkWell(
                          splashColor: Colors.grey,
                          onTap: () {
                            print('video index $index');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CourseInfoScreen(snapshot, index)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, top: 16, bottom: 18),
                            child: Container(
                              decoration: BoxDecoration(
                                color: FintnessAppTheme.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.0),
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    topRight: Radius.circular(68.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: FintnessAppTheme.grey
                                          .withOpacity(0.2),
                                      offset: Offset(1.1, 1.1),
                                      blurRadius: 10.0),
                                ],
                              ),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16, left: 16, right: 24),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4, bottom: 8, top: 16),
                                          child: Text(
                                            snapshot.data.course.videos[index]
                                                .title,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily:
                                                    FintnessAppTheme.fontName,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16,
                                                letterSpacing: -0.1,
                                                color:
                                                    FintnessAppTheme.darkText),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
//                                              Padding(
//                                                padding: const EdgeInsets.only(
//                                                    left: 4, bottom: 3),
//                                                child: Text(
//                                                  '',
//                                                  textAlign: TextAlign.center,
//                                                  style: TextStyle(
//                                                    fontFamily:
//                                                        FintnessAppTheme.fontName,
//                                                    fontWeight: FontWeight.w600,
//                                                    fontSize: 32,
//                                                    color: FintnessAppTheme
//                                                        .nearlyDarkBlue,
//                                                  ),
//                                                ),
//                                              ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 5, bottom: 8),
                                                  child: Text(
                                                    snapshot
                                                        .data.course.mediumName,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FintnessAppTheme
                                                              .fontName,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 18,
                                                      letterSpacing: -0.2,
                                                      color: FintnessAppTheme
                                                          .nearlyDarkBlue,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: <Widget>[
                                                CachedNetworkImage(
                                                  imageUrl: snapshot
                                                      .data
                                                      .course
                                                      .videos[index]
                                                      .videoThumbnailUrl,
                                                  width: 120,
                                                  height: 80,
                                                  placeholder: (context, url) =>
                                                      CircularProgressIndicator(),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                ),
//                                                Image.network(
//                                                  snapshot
//                                                      .data
//                                                      .course
//                                                      .videos[index]
//                                                      .videoThumbnailUrl,
//                                                  width: 120,
//                                                  height: 80,
//                                                ),
//                                              Row(
//                                                mainAxisAlignment:
//                                                MainAxisAlignment.center,
//                                                children: <Widget>[
//                                                  Icon(
//                                                    Icons.access_time,
//                                                    color: FintnessAppTheme.grey
//                                                        .withOpacity(0.5),
//                                                    size: 16,
//                                                  ),
//                                                  Padding(
//                                                    padding:
//                                                    const EdgeInsets.only(
//                                                        left: 4.0),
//                                                    child: Text(
//                                                      formatter.format(
//                                                          DateTime.parse(
//                                                              snapshot
//                                                                  .data
//                                                                  .course
//                                                                  .createdAt)),
//                                                      textAlign:
//                                                      TextAlign.center,
//                                                      style: TextStyle(
//                                                        fontFamily:
//                                                        FintnessAppTheme
//                                                            .fontName,
//                                                        fontWeight:
//                                                        FontWeight.w500,
//                                                        fontSize: 14,
//                                                        letterSpacing: 0.0,
//                                                        color: FintnessAppTheme
//                                                            .grey
//                                                            .withOpacity(0.5),
//                                                      ),
//                                                    ),
//                                                  ),
//                                                ],
//                                              ),
//                                              Padding(
//                                                padding: const EdgeInsets.only(
//                                                    top: 4, bottom: 14),
//                                                child: GestureDetector(
//                                                  onTap: () {
//                                                    CircularProgressIndicator();
//                                                    _lunchUrl(
//                                                        url: snapshot
//                                                            .data
//                                                            .course
//                                                            .materials[index]
//                                                            .materialUrl);
//                                                  },
//                                                  child: Text(
//                                                    'View Materials',
//                                                    textAlign: TextAlign.center,
//                                                    style: TextStyle(
//                                                      fontFamily:
//                                                      FintnessAppTheme
//                                                          .fontName,
//                                                      fontWeight:
//                                                      FontWeight.w500,
//                                                      fontSize: 12,
//                                                      decoration: TextDecoration
//                                                          .underline,
//                                                      letterSpacing: 0.0,
//                                                      color: FintnessAppTheme
//                                                          .nearlyDarkBlue,
//                                                    ),
//                                                  ),
//                                                ),
//                                              ),
                                              ],
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 24, right: 24, top: 8, bottom: 8),
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: FintnessAppTheme.background,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 24,
                                        right: 24,
                                        top: 8,
                                        bottom: 16),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                snapshot.data.course.boardName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily:
                                                      FintnessAppTheme.fontName,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                  letterSpacing: -0.2,
                                                  color:
                                                      FintnessAppTheme.darkText,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 6),
                                                child: Text(
                                                  'Board\nName',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: FintnessAppTheme
                                                        .fontName,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12,
                                                    color: FintnessAppTheme.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
//                                            mainAxisAlignment:
//                                                MainAxisAlignment.center,
//                                            crossAxisAlignment:
//                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    snapshot
                                                        .data.course.streamName,
                                                    overflow: TextOverflow.clip,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FintnessAppTheme
                                                              .fontName,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      letterSpacing: -0.2,
                                                      color: FintnessAppTheme
                                                          .darkText,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6),
                                                    child: Text(
                                                      'Stream\nName',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            FintnessAppTheme
                                                                .fontName,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color: FintnessAppTheme
                                                            .grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: <Widget>[
                                                  Text(
                                                    snapshot.data.course
                                                        .standardName,
                                                    style: TextStyle(
                                                      fontFamily:
                                                          FintnessAppTheme
                                                              .fontName,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 16,
                                                      letterSpacing: -0.2,
                                                      color: FintnessAppTheme
                                                          .darkText,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 6),
                                                    child: Text(
                                                      'Std\n  ',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            FintnessAppTheme
                                                                .fontName,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 12,
                                                        color: FintnessAppTheme
                                                            .grey
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
