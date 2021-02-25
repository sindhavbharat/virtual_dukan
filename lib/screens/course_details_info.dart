import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:virtual_dukan/design_course/course_info_screen.dart';
import 'package:virtual_dukan/design_course/design_course_app_theme.dart';
import 'package:virtual_dukan/design_course/models/course_details_list.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:virtual_dukan/utils_data/fintness_app_theme.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:ribbon/ribbon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'cart_items.dart';

class CourseDetailsInfo extends StatefulWidget {
  final int id;
  final double discount;
  final String type;

  CourseDetailsInfo({this.id, this.discount, this.type});

  @override
  _CourseDetailsInfoState createState() => _CourseDetailsInfoState();
}

class _CourseDetailsInfoState extends State<CourseDetailsInfo>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  ProgressDialog progressDialog;
  Future<CourseDetailsList> _future;

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    _future = _getDetailsWiseData();
    super.initState();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage(UtilsData.kLoadingMsg);
    double nearLength = 30;
    double farLength = 60;
    RibbonLocation location = RibbonLocation.topEnd;
    final DateFormat formatter = DateFormat('dd-MMM-yyyy hh:mm a');

    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder(
          future: _future,
          builder: (BuildContext context,
              AsyncSnapshot<CourseDetailsList> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      backgroundColor: Colors.blue,
                    )),
              );
            } else {
              double different =
                  double.parse(snapshot.data.course.mrpPrice) -
                      double.parse(snapshot.data.course.salePrice);
              different = different *
                  100 /
                  double.parse(snapshot.data.course.mrpPrice);
              return Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 1.2,
                        child: Image.network(
                            snapshot.data.course.thumbnailUrl),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: widget.type == 'free' ? false : true,
                    child: SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.all(20),
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Text(
                              widget.type == 'free'
                                  ? ''
                                  : widget.discount.toStringAsFixed(0) +
                                  '%\noff',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                letterSpacing: 0.27,
                                color: DesignCourseAppTheme.nearlyWhite,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: (MediaQuery
                        .of(context)
                        .size
                        .width / 1.2) - 24.0,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Ribbon(
                      nearLength: nearLength,
                      farLength: farLength,
                      title: (snapshot.data.course.typeOfCourse == 'free')
                          ? 'Free'
                          : (snapshot.data.course.typeOfCourse == 'paid')
                          ? 'Paid'
                          : 'Purchase',
                      titleStyle: TextStyle(
                          color: UtilsData.kWhite,
                          fontWeight: FontWeight.w500),
                      color: (snapshot.data.course.typeOfCourse == 'free')
                          ? Colors.blue
                          : (snapshot.data.course.typeOfCourse == 'paid')
                          ? Colors.redAccent
                          : Colors.green,
                      location: location,
                      child: Container(
                        decoration: BoxDecoration(
                          color: DesignCourseAppTheme.nearlyWhite,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32.0),
                              topRight: Radius.circular(32.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: DesignCourseAppTheme.grey
                                    .withOpacity(0.2),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 10.0),
                          ],
                        ),
                        child: Padding(
                          padding:
                          const EdgeInsets.only(left: 16, right: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DefaultTabController(
                              length: 3,
                              child: Scaffold(
                                  backgroundColor: Colors.white,
                                  bottomNavigationBar: Visibility(
                                    visible: (snapshot.data.course
                                        .typeOfCourse ==
                                        'free')
                                        ? false
                                        : (snapshot.data.course
                                        .typeOfCourse ==
                                        'purchased')
                                        ? false
                                        : true,
                                    child: InkWell(
                                      onTap: () {
                                        progressDialog.show();
                                        _addToCartItem(
                                            id: snapshot.data.course.id,
                                            context: context);
                                      },
                                      child: Container(
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: UtilsData.kDarkBlue,
                                          borderRadius:
                                          const BorderRadius.all(
                                            Radius.circular(
                                              16.0,
                                            ),
                                          ),
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                              color: DesignCourseAppTheme
                                                  .nearlyBlue
                                                  .withOpacity(
                                                0.5,
                                              ),
                                              offset: const Offset(
                                                1.1,
                                                1.1,
                                              ),
                                              blurRadius: 10.0,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            UtilsData.kAddToCart,
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              letterSpacing: 0.0,
                                              color: DesignCourseAppTheme
                                                  .nearlyWhite,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  body: Column(
                                    children: <Widget>[
                                      TabBar(
                                        tabs: [
                                          Tab(
                                            child: Text(
                                              'Overview',
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color:
                                                  DesignCourseAppTheme
                                                      .darkerText,
                                                  fontWeight:
                                                  FontWeight.w900,
                                                  letterSpacing: 1.0),
                                            ),
                                          ),
                                          Tab(
                                            child: Text(
                                              'Video',
                                              style: TextStyle(
                                                  color:
                                                  DesignCourseAppTheme
                                                      .darkerText,
                                                  fontWeight:
                                                  FontWeight.w900,
                                                  letterSpacing: 1.0),
                                            ),
                                          ),
                                          Tab(
                                            child: Text(
                                              'Material',
                                              style: TextStyle(
                                                  color:
                                                  DesignCourseAppTheme
                                                      .darkerText,
                                                  fontWeight:
                                                  FontWeight.w900,
                                                  letterSpacing: 1.0),
                                            ),
                                          )
                                        ],
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: TabBarView(
                                          children: [
                                            SingleChildScrollView(
                                              child: Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8),
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                          top: 20.0,
                                                          left: 18,
                                                          right: 16),
                                                      child: Text(
                                                        snapshot.data
                                                            .course.title,
                                                        textAlign:
                                                        TextAlign
                                                            .left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          fontSize: 22,
                                                          letterSpacing:
                                                          0.27,
                                                          color: DesignCourseAppTheme
                                                              .darkerText,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .only(
                                                        left: 16,
                                                        right: 16,
                                                        bottom: 8,
                                                        top: 16,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                        children: <
                                                            Widget>[
                                                          Row(
                                                            children: <
                                                                Widget>[
                                                              Text(
                                                                snapshot.data
                                                                    .course
                                                                    .typeOfCourse ==
                                                                    'free'
                                                                    ? ''
                                                                    : '\₹${snapshot
                                                                    .data.course
                                                                    .mrpPrice}',
                                                                textAlign:
                                                                TextAlign
                                                                    .left,
                                                                style:
                                                                TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                                  fontSize:
                                                                  16,
                                                                  letterSpacing:
                                                                  0.27,
                                                                  color: DesignCourseAppTheme
                                                                      .grey,
                                                                  decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                snapshot.data
                                                                    .course
                                                                    .typeOfCourse ==
                                                                    'free'
                                                                    ? 'Free'
                                                                    : '\₹${snapshot
                                                                    .data.course
                                                                    .salePrice}(${different
                                                                    .toStringAsFixed(
                                                                    2)}%)',
                                                                textAlign:
                                                                TextAlign
                                                                    .left,
                                                                style:
                                                                TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w200,
                                                                  fontSize:
                                                                  22,
                                                                  letterSpacing:
                                                                  0.27,
                                                                  color: DesignCourseAppTheme
                                                                      .nearlyBlue,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Container(
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '4.3',
                                                                  textAlign:
                                                                  TextAlign
                                                                      .left,
                                                                  style:
                                                                  TextStyle(
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .w200,
                                                                    fontSize:
                                                                    22,
                                                                    letterSpacing:
                                                                    0.27,
                                                                    color:
                                                                    DesignCourseAppTheme
                                                                        .grey,
                                                                  ),
                                                                ),
                                                                Icon(
                                                                  Icons
                                                                      .star,
                                                                  color: DesignCourseAppTheme
                                                                      .nearlyBlue,
                                                                  size:
                                                                  24,
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
//                                                    Padding(
//                                                      padding:
//                                                          const EdgeInsets.only(
//                                                              left: 16,
//                                                              right: 16,
//                                                              bottom: 8,
//                                                              top: 16),
//                                                      child: Row(
//                                                        mainAxisAlignment:
//                                                            MainAxisAlignment
//                                                                .start,
//                                                        children: <Widget>[
//                                                          Icon(
//                                                            Icons.access_time,
//                                                            color:
//                                                                FintnessAppTheme
//                                                                    .grey
//                                                                    .withOpacity(
//                                                                        0.5),
//                                                            size: 16,
//                                                          ),
////                                                          Padding(
////                                                            padding:
////                                                                const EdgeInsets
////                                                                        .only(
////                                                                    left: 4.0),
////                                                            child: Text(
////                                                              formatter.format(
////                                                                  DateTime.parse(
////                                                                      snapshot
////                                                                          .data
////                                                                          .course
////                                                                          .createdAt)),
////                                                              textAlign:
////                                                                  TextAlign
////                                                                      .center,
////                                                              style: TextStyle(
////                                                                fontFamily:
////                                                                    FintnessAppTheme
////                                                                        .fontName,
////                                                                fontWeight:
////                                                                    FontWeight
////                                                                        .w500,
////                                                                fontSize: 14,
////                                                                letterSpacing:
////                                                                    0.0,
////                                                                color: FintnessAppTheme
////                                                                    .grey
////                                                                    .withOpacity(
////                                                                        0.5),
////                                                              ),
////                                                            ),
////                                                          ),
//                                                        ],
//                                                      ),
//                                                    ),
                                                    AnimatedOpacity(
                                                      duration:
                                                      const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                      opacity: opacity1,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .all(
                                                          8,
                                                        ),
                                                        child: Wrap(
                                                          children: <
                                                              Widget>[
                                                            getTimeBoxUI(
                                                              snapshot
                                                                  .data
                                                                  .course
                                                                  .standardName,
                                                              'Std',
                                                            ),
                                                            getTimeBoxUI(
                                                              snapshot
                                                                  .data
                                                                  .course
                                                                  .boardName,
                                                              'Board',
                                                            ),
                                                            getTimeBoxUI(
                                                              snapshot
                                                                  .data
                                                                  .course
                                                                  .mediumName,
                                                              'Medium',
                                                            ),
                                                            getTimeBoxUI(
                                                              snapshot
                                                                  .data
                                                                  .course
                                                                  .streamName,
                                                              'Stream',
                                                            ),
                                                            getTimeBoxUI(
                                                              snapshot
                                                                  .data
                                                                  .course
                                                                  .videos
                                                                  .length
                                                                  .toString(),
                                                              'Videos',
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    AnimatedOpacity(
                                                      duration:
                                                      const Duration(
                                                        milliseconds: 500,
                                                      ),
                                                      opacity: opacity2,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .only(
                                                          left: 16,
                                                          right: 16,
                                                          top: 8,
                                                          bottom: 8,
                                                        ),
                                                        child: Column(
                                                          children: <
                                                              Widget>[
                                                            Text(
                                                              snapshot
                                                                  .data
                                                                  .course
                                                                  .description,
                                                              overflow:
                                                              TextOverflow
                                                                  .visible,
                                                              softWrap:
                                                              true,
                                                              textAlign:
                                                              TextAlign
                                                                  .left,
                                                              style:
                                                              TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w200,
                                                                fontSize:
                                                                14,
                                                                letterSpacing:
                                                                0.27,
                                                                color: DesignCourseAppTheme
                                                                    .grey,
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height:
                                                      MediaQuery
                                                          .of(
                                                          context)
                                                          .padding
                                                          .bottom,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            snapshot.data.course.videos
                                                .length ==
                                                0
                                                ? Center(
                                              child: Image.asset(
                                                UtilsData
                                                    .kNoDataImageDir,
                                                fit: BoxFit.fill,
                                              ),
                                            )
                                                : ListView.builder(
                                                itemCount: snapshot
                                                    .data
                                                    .course
                                                    .videos
                                                    .length,
                                                itemBuilder:
                                                    (context, index) {
                                                  print(
                                                      'video index $index');
                                                  return Ribbon(
                                                    nearLength:
                                                    nearLength,
                                                    farLength:
                                                    farLength,
                                                    title: (snapshot
                                                        .data
                                                        .course
                                                        .videos[
                                                    index]
                                                        .keepAsDemo ==
                                                        1)
                                                        ? 'Free'
                                                        : (snapshot
                                                        .data
                                                        .course
                                                        .videos[index]
                                                        .keepAsDemo ==
                                                        2)
                                                        ? 'Purchase'
                                                        : 'Paid',
                                                    titleStyle: TextStyle(
                                                        color: UtilsData
                                                            .kWhite,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                    color: (snapshot
                                                        .data
                                                        .course
                                                        .videos[
                                                    index]
                                                        .keepAsDemo ==
                                                        1)
                                                        ? Colors.blue
                                                        : (snapshot
                                                        .data
                                                        .course
                                                        .videos[
                                                    index]
                                                        .keepAsDemo ==
                                                        0)
                                                        ? Colors
                                                        .redAccent
                                                        : Colors
                                                        .green,
                                                    location:
                                                    location,
                                                    child: Card(
                                                      elevation: 10.0,
                                                      shadowColor:
                                                      AppTheme
                                                          .notWhite,
                                                      margin:
                                                      EdgeInsets
                                                          .all(
                                                          10),
                                                      child: ListTile(
                                                        leading:
                                                        CircleAvatar(
                                                          backgroundImage:
                                                          NetworkImage(
                                                            snapshot
                                                                .data
                                                                .course
                                                                .videos[
                                                            index]
                                                                .videoThumbnailUrl,
                                                          ),
                                                        ),
                                                        title: Text(
                                                          snapshot
                                                              .data
                                                              .course
                                                              .videos[
                                                          index]
                                                              .title,
                                                          style:
                                                          TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            fontSize:
                                                            14,
                                                            letterSpacing:
                                                            0.27,
                                                            color: DesignCourseAppTheme
                                                                .darkerText,
                                                          ),
                                                        ),
//                                                            subtitle: Row(
//                                                              children: <
//                                                                  Widget>[
//                                                                Text(
//                                                                  snapshot.data.course
//                                                                              .typeOfCourse ==
//                                                                          'free'
//                                                                      ? ''
//                                                                      : '\₹${snapshot.data.course.mrpPrice}',
//                                                                  textAlign:
//                                                                      TextAlign
//                                                                          .left,
//                                                                  style:
//                                                                      TextStyle(
//                                                                    fontWeight:
//                                                                        FontWeight
//                                                                            .w200,
//                                                                    fontSize:
//                                                                        12,
//                                                                    letterSpacing:
//                                                                        0.27,
//                                                                    color:
//                                                                        DesignCourseAppTheme
//                                                                            .grey,
//                                                                    decoration:
//                                                                        TextDecoration
//                                                                            .lineThrough,
//                                                                  ),
//                                                                ),
//                                                                SizedBox(
//                                                                    width: 5),
//                                                                Text(
//                                                                  snapshot.data.course
//                                                                              .typeOfCourse ==
//                                                                          'free'
//                                                                      ? 'Free'
//                                                                      : '\₹${snapshot.data.course.salePrice}',
//                                                                  textAlign:
//                                                                      TextAlign
//                                                                          .left,
//                                                                  style:
//                                                                      TextStyle(
//                                                                    fontWeight:
//                                                                        FontWeight
//                                                                            .w200,
//                                                                    fontSize:
//                                                                        12,
//                                                                    letterSpacing:
//                                                                        0.27,
//                                                                    color: DesignCourseAppTheme
//                                                                        .nearlyBlue,
//                                                                  ),
//                                                                ),
//                                                              ],
//                                                            ),
                                                        onTap: () {
                                                          if (snapshot
                                                              .data
                                                              .course
                                                              .videos[index]
                                                              .keepAsDemo ==
                                                              1) {
                                                            Navigator.of(
                                                                context).push(
                                                                MaterialPageRoute(
                                                                    builder: (
                                                                        context) =>
                                                                        CourseInfoScreen(
                                                                            snapshot,
                                                                            index)));
                                                          } else if (snapshot
                                                              .data
                                                              .course
                                                              .videos[index]
                                                              .keepAsDemo ==
                                                              2) {
                                                            Navigator.of(
                                                                context).push(
                                                                MaterialPageRoute(
                                                                    builder: (
                                                                        context) =>
                                                                        CourseInfoScreen(
                                                                            snapshot,
                                                                            index)));
                                                          } else {
                                                            AwesomeDialog(
                                                              context:
                                                              context,
                                                              dialogType:
                                                              DialogType
                                                                  .WARNING,
                                                              animType:
                                                              AnimType
                                                                  .BOTTOMSLIDE,
                                                              title: UtilsData
                                                                  .kErrorHey,
                                                              desc: UtilsData
                                                                  .kErrorPurchaseCourse,
                                                              btnCancelOnPress:
                                                                  () {},
                                                              btnOkOnPress:
                                                                  () {},
                                                            )
                                                              ..show();
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }),
                                            snapshot.data.course.materials
                                                .length ==
                                                0
                                                ? Center(
                                              child: Image.asset(
                                                UtilsData
                                                    .kNoDataImageDir,
                                                fit: BoxFit.fill,
                                              ),
                                            )
                                                : ListView.builder(
                                                itemCount: snapshot
                                                    .data
                                                    .course
                                                    .materials
                                                    .length,
                                                itemBuilder:
                                                    (context, index) {
                                                  return Ribbon(
                                                    nearLength:
                                                    nearLength,
                                                    farLength:
                                                    farLength,
                                                    title: (snapshot
                                                        .data
                                                        .course
                                                        .materials[
                                                    index]
                                                        .keepAsDemo ==
                                                        1)
                                                        ? 'Free'
                                                        : (snapshot
                                                        .data
                                                        .course
                                                        .materials[index]
                                                        .keepAsDemo ==
                                                        0)
                                                        ? 'Paid'
                                                        : 'Purchase',
                                                    titleStyle: TextStyle(
                                                        color: UtilsData
                                                            .kWhite,
                                                        fontWeight:
                                                        FontWeight
                                                            .w500),
                                                    color: (snapshot
                                                        .data
                                                        .course
                                                        .materials[
                                                    index]
                                                        .keepAsDemo ==
                                                        1)
                                                        ? Colors.blue
                                                        : (snapshot
                                                        .data
                                                        .course
                                                        .materials[
                                                    index]
                                                        .keepAsDemo ==
                                                        0)
                                                        ? Colors
                                                        .redAccent
                                                        : Colors
                                                        .green,
                                                    location:
                                                    location,
                                                    child: Card(
                                                      elevation: 10.0,
                                                      shadowColor:
                                                      AppTheme
                                                          .notWhite,
                                                      margin:
                                                      EdgeInsets
                                                          .all(
                                                          10),
                                                      child: ListTile(
                                                        leading:
                                                        CircleAvatar(
                                                          backgroundImage:
                                                          NetworkImage(
                                                            snapshot
                                                                .data
                                                                .course
                                                                .materials[
                                                            index]
                                                                .materialThumbnailUrl,
                                                          ),
                                                        ),
                                                        title: Text(
                                                          snapshot
                                                              .data
                                                              .course
                                                              .materials[
                                                          index]
                                                              .title,
                                                          style:
                                                          TextStyle(
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            fontSize:
                                                            14,
                                                            letterSpacing:
                                                            0.27,
                                                            color: DesignCourseAppTheme
                                                                .darkerText,
                                                          ),
                                                        ),
                                                        subtitle:
                                                        Text(
                                                          snapshot
                                                              .data
                                                              .course
                                                              .materials[
                                                          index]
                                                              .type,
                                                          style:
                                                          TextStyle(
                                                            letterSpacing:
                                                            0.27,
                                                          ),
                                                        ),
                                                        trailing:
                                                        Padding(
                                                          padding: const EdgeInsets
                                                              .only(
                                                              top: 4,
                                                              bottom:
                                                              14),
                                                          child:
                                                          GestureDetector(
                                                            onTap:
                                                                () {
                                                              if (snapshot.data
                                                                  .course
                                                                  .materials[index]
                                                                  .keepAsDemo ==
                                                                  1) {
                                                                CircularProgressIndicator();
                                                                _lunchUrl(
                                                                    url: snapshot
                                                                        .data
                                                                        .course
                                                                        .materials[index]
                                                                        .materialUrl);
                                                              } else
                                                              if (snapshot.data
                                                                  .course
                                                                  .materials[index]
                                                                  .keepAsDemo ==
                                                                  2) {
                                                                CircularProgressIndicator();
                                                                _lunchUrl(
                                                                    url: snapshot
                                                                        .data
                                                                        .course
                                                                        .materials[index]
                                                                        .materialUrl);
                                                              } else {
                                                                AwesomeDialog(
                                                                  context:
                                                                  context,
                                                                  dialogType:
                                                                  DialogType
                                                                      .WARNING,
                                                                  animType:
                                                                  AnimType
                                                                      .BOTTOMSLIDE,
                                                                  title:
                                                                  UtilsData
                                                                      .kErrorHey,
                                                                  desc:
                                                                  UtilsData
                                                                      .kErrorPurchaseCourse,
                                                                  btnCancelOnPress:
                                                                      () {},
                                                                  btnOkOnPress:
                                                                      () {},
                                                                )
                                                                  ..show();
                                                              }
                                                            },
                                                            child:
                                                            Text(
                                                              'View Materials',
                                                              textAlign:
                                                              TextAlign.center,
                                                              style:
                                                              TextStyle(
                                                                fontFamily:
                                                                FintnessAppTheme
                                                                    .fontName,
                                                                fontWeight:
                                                                FontWeight.w500,
                                                                fontSize:
                                                                12,
                                                                decoration:
                                                                TextDecoration
                                                                    .underline,
                                                                letterSpacing:
                                                                0.0,
                                                                color:
                                                                FintnessAppTheme
                                                                    .nearlyDarkBlue,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
//                                                onTap: () {
//                                                  if(snapshot.data.course.typeOfCourse=='free'){
//                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CourseInfoScreen(snapshot, index)));
//                                                  }else{
//                                                    UtilsData.kErrorDialog(context: context,errorMsg: 'Please first purchase course');
//                                                  }
//
//                                                },
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ],
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
//                  Positioned(
//                    top: (MediaQuery
//                        .of(context)
//                        .size
//                        .width / 1.2) - 24.0 - 35,
//                    right: 35,
//                    child: ScaleTransition(
//                      alignment: Alignment.center,
//                      scale: CurvedAnimation(
//                          parent: animationController,
//                          curve: Curves.fastOutSlowIn),
//                      child: Card(
//                        color: DesignCourseAppTheme.nearlyBlue,
//                        shape: RoundedRectangleBorder(
//                            borderRadius: BorderRadius.circular(50.0)),
//                        elevation: 10.0,
//                        child: Container(
//                          width: 60,
//                          height: 60,
//                          child: Center(
//                            child: Icon(
//                              Icons.favorite,
//                              color: DesignCourseAppTheme.nearlyWhite,
//                              size: 30,
//                            ),
//                          ),
//                        ),
//                      ),
//                    ),
//                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery
                            .of(context)
                            .padding
                            .top),
                    child: SizedBox(
                      width: AppBar().preferredSize.height,
                      height: AppBar().preferredSize.height,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                              AppBar().preferredSize.height),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: DesignCourseAppTheme.nearlyBlack,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void _lunchUrl({String url}) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
      );
    } else {
      throw 'Could not lunch $url';
    }
  }

  Widget getButtonUI(String text, bool isSelected) {
    String txt = text;
//    if (CategoryType.ui == categoryTypeData) {
//      txt = 'Ui/Ux';
//    } else if (CategoryType.coding == categoryTypeData) {
//      txt = 'Coding';
//    } else if (CategoryType.basic == categoryTypeData) {
//      txt = 'Basic UI';
//    }
    return Container(
      decoration: BoxDecoration(
          color: isSelected
              ? DesignCourseAppTheme.nearlyBlue
              : DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          splashColor: Colors.white24,
          borderRadius: const BorderRadius.all(Radius.circular(24.0)),
          onTap: () {
            setState(() {
              isSelected = !isSelected;
            });
          },
          child: Padding(
            padding:
                const EdgeInsets.only(top: 12, bottom: 12, left: 18, right: 18),
            child: Center(
              child: Text(
                txt,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 0.27,
                  color: isSelected
                      ? DesignCourseAppTheme.nearlyWhite
                      : DesignCourseAppTheme.nearlyBlue,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<CourseDetailsList> _getDetailsWiseData() async {
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
    print('response from my details ${jsonDecode(response.body)}');
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

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.nearlyBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addToCartItem({int id, BuildContext context}) async {
    print('id $id');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    print(
        'request ${UtilsData.kBaseUrl + UtilsData.kAddCartMethod +
            id.toString()}');
    final http.Response response = await http
        .post(
      UtilsData.kBaseUrl + UtilsData.kAddCartMethod + id.toString(),
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
      body: jsonEncode(<String, String>{
        'type': 'course',
      }),
    )
        .timeout(Duration(minutes: 60));

    Navigator.of(context).pop();

    var _responseData = jsonDecode(response.body);
    print('response from add to cart $_responseData');

    if (response.statusCode == 200) {
      if (_responseData[UtilsData.kResponseErrorMessage] ==
          'This course is already in cart') {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Already in cart',
          desc: _responseData[UtilsData.kResponseErrorMessage],
          btnCancelOnPress: () {},
          btnOkOnPress: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => CartItems()));
          },
        )
          ..show();
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
        )
          ..show();
      } else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.BOTTOMSLIDE,
          title: UtilsData.kSuccess,
          desc: _responseData[UtilsData.kResponseErrorMessage],
          btnCancelOnPress: () {},
          btnOkOnPress: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => CartItems()));
          },
        )
          ..show();
      }
    } else {
      return UtilsData.kErrorDialog(
          context: context,
          errorMsg: _responseData[UtilsData.kResponseErrorMessage]);
    }
  }
}
