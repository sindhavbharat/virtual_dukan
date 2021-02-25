import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_dukan/design_course/design_course_app_theme.dart';
import 'package:virtual_dukan/design_course/models/institutes_model.dart';
import 'package:virtual_dukan/design_course/models/publisher_model.dart';
import 'package:virtual_dukan/screens/institutes_details_info.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:ribbon/ribbon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InstitutesListView extends StatefulWidget {
  @override
  _InstitutesListViewState createState() => _InstitutesListViewState();
}

class _InstitutesListViewState extends State<InstitutesListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Future<PublisherModel> _future;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _future = getData();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<PublisherModel> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kPublisherMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
    print('response from institutes view $response');
//    var data = jsonDecode(response.body);
//    var courses = data['courses'] as List;
    if (response.statusCode == 200) {
      return PublisherModel.fromJson(jsonDecode(response.body));
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
//        btnCancelOnPress: () {},
        btnOkOnPress: () {
          preferences.clear();
          print(
              'after signout token${preferences.getString((UtilsData.kToken))}');
          exit(0);
        },
      )..show();
    } else {
      throw Exception('Failed to load course list');
    }
  }

  Future<void> _getRefreshData() async {
    setState(() {
      this._future = getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    double nearLength = 30;
    double farLength = 50;
    RibbonLocation location = RibbonLocation.topEnd;
    return RefreshIndicator(
      onRefresh: _getRefreshData,
      child: Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        child: Container(
          height: 190,
          width: double.infinity,
          child: FutureBuilder<PublisherModel>(
            future: _future,
            builder: (BuildContext context,
                AsyncSnapshot<PublisherModel> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 0, right: 16, left: 16),
                  itemCount: snapshot.data.publishers.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final int count = snapshot.data.publishers.length > 10
                        ? 10
                        : snapshot.data.publishers.length;

                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    animationController.forward();
                    return AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget child) {
                        return FadeTransition(
                          opacity: animation,
                          child: Transform(
                            transform: Matrix4.translationValues(
                                100 * (1.0 - animation.value), 0.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
//                                Navigator.of(context).push(MaterialPageRoute(
//                                    builder: (context) => CourseDetails(
//                                          id: _listCourse[index].id,
//                                        )));
                                print(
                                    'id of publisher ${snapshot.data.publishers[index].id}');
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => InstitutesDetailsInfo(
                                          id: snapshot
                                              .data.publishers[index].id,
                                          profileImage: snapshot
                                              .data
                                              .publishers[index]
                                              .logoUrl,
                                        )));

//                              callback();
                              },
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(10.0),
                                    width: 170,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      color: Colors.white,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          snapshot.data.publishers[index]
                                              .logoUrl,
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
//                              child: Padding(
//                                padding: const EdgeInsets.only(
//                                    top: 24, bottom: 24, left: 10),
//                                child: Row(
//                                  children: <Widget>[
//                                    ClipRRect(
//                                      borderRadius: const BorderRadius.all(
//                                        Radius.circular(16.0),
//                                      ),
//                                      child: Image.network(
//                                        snapshot.data.institutes[index]
//                                            .profileImageUrl,
//                                        fit: BoxFit.fill,
//                                      ),
//                                    )
//                                  ],
//                                ),
//                              ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        snapshot.data.publishers[index].name,
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          letterSpacing: 0.27,
                                          color: DesignCourseAppTheme.darkerText,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
//              return ListView.builder(
//                padding: const EdgeInsets.only(
//                    top: 0, bottom: 0, right: 16, left: 16),
//                itemCount: snapshot.data.institutes.length,
//                scrollDirection: Axis.horizontal,
//                itemBuilder: (BuildContext context, int index) {
//                  final int count = snapshot.data.institutes.length > 10
//                      ? 10
//                      : snapshot.data.institutes.length;
//
//                  final Animation<double> animation =
//                      Tween<double>(begin: 0.0, end: 1.0).animate(
//                          CurvedAnimation(
//                              parent: animationController,
//                              curve: Interval((1 / count) * index, 1.0,
//                                  curve: Curves.fastOutSlowIn)));
//                  animationController.forward();
//                  return AnimatedBuilder(
//                    animation: animationController,
//                    builder: (BuildContext context, Widget child) {
//                      return FadeTransition(
//                        opacity: animation,
//                        child: Transform(
//                          transform: Matrix4.translationValues(
//                              100 * (1.0 - animation.value), 0.0, 0.0),
//                          child: InkWell(
//                            splashColor: Colors.transparent,
//                            onTap: () {
////                                Navigator.of(context).push(MaterialPageRoute(
////                                    builder: (context) => CourseDetails(
////                                          id: _listCourse[index].id,
////                                        )));
//                              print(
//                                  'id of institutes ${snapshot.data.institutes[index].id}');
//                              Navigator.of(context).push(MaterialPageRoute(
//                                  builder: (context) => InstitutesDetailsInfo(
//                                        id: snapshot.data.institutes[index].id,
//                                        profileImage: snapshot.data
//                                            .institutes[index].profileImageUrl,
//                                      )));
//
////                              callback();
//                            },
//                            child: SizedBox(
//                              width: 280,
//                              child: Stack(
//                                children: <Widget>[
//                                  Container(
//                                    child: Row(
//                                      children: <Widget>[
//                                        const SizedBox(
//                                          width: 48,
//                                        ),
//                                        Expanded(
//                                          child: Container(
//                                            decoration: BoxDecoration(
//                                              color: HexColor('#F8FAFB'),
//                                              borderRadius:
//                                                  const BorderRadius.all(
//                                                      Radius.circular(16.0)),
//                                            ),
//                                            child: Row(
//                                              children: <Widget>[
//                                                const SizedBox(
//                                                  width: 48 + 24.0,
//                                                ),
//                                                Expanded(
//                                                  child: Container(
//                                                    child: Column(
//                                                      children: <Widget>[
//                                                        Padding(
//                                                          padding:
//                                                              const EdgeInsets
//                                                                      .only(
//                                                                  top: 16),
//                                                          child: Align(
//                                                            alignment: Alignment
//                                                                .topLeft,
//                                                            child: Text(
//                                                              snapshot
//                                                                  .data
//                                                                  .institutes[
//                                                                      index]
//                                                                  .name,
//                                                              maxLines: 3,
//                                                              textAlign:
//                                                                  TextAlign
//                                                                      .left,
//                                                              style: TextStyle(
//                                                                fontWeight:
//                                                                    FontWeight
//                                                                        .w600,
//                                                                fontSize: 14,
//                                                                letterSpacing:
//                                                                    0.27,
//                                                                color: DesignCourseAppTheme
//                                                                    .darkerText,
//                                                              ),
//                                                            ),
//                                                          ),
//                                                        ),
//                                                        const Expanded(
//                                                          child: SizedBox(),
//                                                        ),
//                                                        Padding(
//                                                          padding:
//                                                              const EdgeInsets
//                                                                      .only(
//                                                                  right: 16,
//                                                                  bottom: 8),
//                                                          child: Row(
//                                                            mainAxisAlignment:
//                                                                MainAxisAlignment
//                                                                    .spaceBetween,
//                                                            crossAxisAlignment:
//                                                                CrossAxisAlignment
//                                                                    .center,
//                                                            children: <Widget>[
//                                                              Text(
//                                                                snapshot
//                                                                    .data
//                                                                    .institutes[
//                                                                        index]
//                                                                    .mobileNo,
//                                                                textAlign:
//                                                                    TextAlign
//                                                                        .left,
//                                                                style:
//                                                                    TextStyle(
//                                                                  fontWeight:
//                                                                      FontWeight
//                                                                          .w200,
//                                                                  fontSize: 12,
//                                                                  letterSpacing:
//                                                                      0.27,
//                                                                  color:
//                                                                      DesignCourseAppTheme
//                                                                          .grey,
//                                                                ),
//                                                              ),
//                                                            ],
//                                                          ),
//                                                        ),
//                                                        Padding(
//                                                          padding:
//                                                              const EdgeInsets
//                                                                      .only(
//                                                                  bottom: 5,
//                                                                  right: 16),
//                                                          child: Wrap(
//                                                            alignment:
//                                                                WrapAlignment
//                                                                    .start,
//                                                            crossAxisAlignment:
//                                                                WrapCrossAlignment
//                                                                    .start,
//                                                            children: <Widget>[
//                                                              Text(
//                                                                snapshot
//                                                                    .data
//                                                                    .institutes[
//                                                                        index]
//                                                                    .email,
//                                                                softWrap: true,
//                                                                overflow:
//                                                                    TextOverflow
//                                                                        .visible,
//                                                                textAlign:
//                                                                    TextAlign
//                                                                        .left,
//                                                                style:
//                                                                    TextStyle(
//                                                                  fontWeight:
//                                                                      FontWeight
//                                                                          .w600,
//                                                                  fontSize: 12,
//                                                                  letterSpacing:
//                                                                      0.27,
//                                                                  color: DesignCourseAppTheme
//                                                                      .nearlyBlue,
//                                                                ),
//                                                              ),
//                                                            ],
//                                                          ),
//                                                        ),
//
////                                                          Padding(
////                                                            padding:
////                                                                const EdgeInsets
////                                                                        .only(
////                                                                    right: 16,
////                                                                    bottom: 8),
////                                                            child: Align(
////                                                              alignment: Alignment.topLeft,
////                                                              child: Text(
////                                                                '${_listCourse[index].description}',
////                                                                overflow: TextOverflow.ellipsis,
////                                                                textAlign:
////                                                                    TextAlign
////                                                                        .left,
////                                                                style: TextStyle(
////                                                                  fontWeight:
////                                                                      FontWeight
////                                                                          .w200,
////                                                                  fontSize: 12,
////                                                                  letterSpacing:
////                                                                      0.27,
////                                                                  color:
////                                                                      DesignCourseAppTheme
////                                                                          .grey,
////                                                                ),
////                                                              ),
////                                                            )
////                                                            /*Row(
////                                                              mainAxisAlignment:
////                                                                  MainAxisAlignment
////                                                                      .spaceBetween,
////                                                              crossAxisAlignment:
////                                                                  CrossAxisAlignment
////                                                                      .center,
////                                                              children: <Widget>[
////                                                                Text(
////                                                                  '${_listCourse[index].description}',
////                                                                  textAlign:
////                                                                      TextAlign
////                                                                          .left,
////                                                                  style:
////                                                                      TextStyle(
////                                                                    fontWeight:
////                                                                        FontWeight
////                                                                            .w200,
////                                                                    fontSize: 12,
////                                                                    letterSpacing:
////                                                                        0.27,
////                                                                    color:
////                                                                        DesignCourseAppTheme
////                                                                            .grey,
////                                                                  ),
////                                                                ),
//////                                                              Container(
//////                                                                child: Row(
//////                                                                  children: <Widget>[
//////                                                                    Text(
//////                                                                      '${category.rating}',
//////                                                                      textAlign:
//////                                                                      TextAlign.left,
//////                                                                      style: TextStyle(
//////                                                                        fontWeight:
//////                                                                        FontWeight.w200,
//////                                                                        fontSize: 18,
//////                                                                        letterSpacing: 0.27,
//////                                                                        color:
//////                                                                        DesignCourseAppTheme
//////                                                                            .grey,
//////                                                                      ),
//////                                                                    ),
//////                                                                    Icon(
//////                                                                      Icons.star,
//////                                                                      color:
//////                                                                      DesignCourseAppTheme
//////                                                                          .nearlyBlue,
//////                                                                      size: 20,
//////                                                                    ),
//////                                                                  ],
//////                                                                ),
//////                                                              )
////                                                              ],
////                                                            )*/
////                                                            ,
////                                                          ),
//                                                        Padding(
//                                                          padding:
//                                                              const EdgeInsets
//                                                                      .only(
//                                                                  bottom: 16,
//                                                                  right: 16),
////                                                            child: Row(
////                                                              mainAxisAlignment:
////                                                                  MainAxisAlignment
////                                                                      .spaceBetween,
////                                                              crossAxisAlignment:
////                                                                  CrossAxisAlignment
////                                                                      .start,
////                                                              children: <Widget>[
////                                                                Text(
////                                                                  '${_listCourse[index].typeOfCourse}',
////                                                                  textAlign:
////                                                                      TextAlign
////                                                                          .left,
////                                                                  style:
////                                                                      TextStyle(
////                                                                    fontWeight:
////                                                                        FontWeight
////                                                                            .w600,
////                                                                    fontSize: 18,
////                                                                    letterSpacing:
////                                                                        0.27,
////                                                                    color: DesignCourseAppTheme
////                                                                        .nearlyBlue,
////                                                                  ),
////                                                                ),
////                                                                Visibility(
////                                                                  visible: false,
////                                                                  child: Container(
////                                                                    decoration:
////                                                                        BoxDecoration(
////                                                                      color: DesignCourseAppTheme
////                                                                          .nearlyBlue,
////                                                                      borderRadius:
////                                                                          const BorderRadius
////                                                                              .all(
////                                                                        Radius
////                                                                            .circular(
////                                                                                8.0),
////                                                                      ),
////                                                                    ),
////                                                                    child: Padding(
////                                                                      padding:
////                                                                          const EdgeInsets
////                                                                                  .all(
////                                                                              4.0),
////                                                                      child: Icon(
////                                                                        Icons.add,
////                                                                        color: DesignCourseAppTheme
////                                                                            .nearlyWhite,
////                                                                      ),
////                                                                    ),
////                                                                  ),
////                                                                )
////                                                              ],
////                                                            ),
//                                                        ),
//                                                      ],
//                                                    ),
//                                                  ),
//                                                ),
//                                              ],
//                                            ),
//                                          ),
//                                        )
//                                      ],
//                                    ),
//                                  ),
//                                  Container(
//                                    child: Padding(
//                                      padding: const EdgeInsets.only(
//                                          top: 24, bottom: 24, left: 16),
//                                      child: Row(
//                                        children: <Widget>[
//                                          ClipRRect(
//                                            borderRadius:
//                                                const BorderRadius.all(
//                                              Radius.circular(16.0),
//                                            ),
//                                            child: AspectRatio(
//                                              aspectRatio: 1.0,
//                                              child: Image.network(
//                                                snapshot.data.institutes[index]
//                                                    .profileImageUrl,
//                                                fit: BoxFit.fill,
//                                              ),
//                                            ),
//                                          )
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          ),
//                        ),
//                      );
//                    },
//                  );
//                },
//              );
              }
            },
          ),
        ),
      ),
    );
  }
}

//class CategoryView extends StatelessWidget {
//  const CategoryView(
//      {Key key,
//      this.category,
//      this.animationController,
//      this.animation,
//      this.callback})
//      : super(key: key);
//
//  final VoidCallback callback;
//  final Category category;
//  final AnimationController animationController;
//  final Animation<dynamic> animation;
//
//  @override
//  Widget build(BuildContext context) {
//    return AnimatedBuilder(
//      animation: animationController,
//      builder: (BuildContext context, Widget child) {
//        return FadeTransition(
//          opacity: animation,
//          child: Transform(
//            transform: Matrix4.translationValues(
//                100 * (1.0 - animation.value), 0.0, 0.0),
//            child: InkWell(
//              splashColor: Colors.transparent,
//              onTap: () {
//                callback();
//              },
//              child: SizedBox(
//                width: 280,
//                child: Stack(
//                  children: <Widget>[
//                    Container(
//                      child: Row(
//                        children: <Widget>[
//                          const SizedBox(
//                            width: 48,
//                          ),
//                          Expanded(
//                            child: Container(
//                              decoration: BoxDecoration(
//                                color: HexColor('#F8FAFB'),
//                                borderRadius: const BorderRadius.all(
//                                    Radius.circular(16.0)),
//                              ),
//                              child: Row(
//                                children: <Widget>[
//                                  const SizedBox(
//                                    width: 48 + 24.0,
//                                  ),
//                                  Expanded(
//                                    child: Container(
//                                      child: Column(
//                                        children: <Widget>[
//                                          Padding(
//                                            padding:
//                                                const EdgeInsets.only(top: 16),
//                                            child: Text(
//                                              category.title,
//                                              textAlign: TextAlign.left,
//                                              style: TextStyle(
//                                                fontWeight: FontWeight.w600,
//                                                fontSize: 16,
//                                                letterSpacing: 0.27,
//                                                color: DesignCourseAppTheme
//                                                    .darkerText,
//                                              ),
//                                            ),
//                                          ),
//                                          const Expanded(
//                                            child: SizedBox(),
//                                          ),
//                                          Padding(
//                                            padding: const EdgeInsets.only(
//                                                right: 16, bottom: 8),
//                                            child: Row(
//                                              mainAxisAlignment:
//                                                  MainAxisAlignment
//                                                      .spaceBetween,
//                                              crossAxisAlignment:
//                                                  CrossAxisAlignment.center,
//                                              children: <Widget>[
//                                                Text(
//                                                  '${category.lessonCount} lesson',
//                                                  textAlign: TextAlign.left,
//                                                  style: TextStyle(
//                                                    fontWeight: FontWeight.w200,
//                                                    fontSize: 12,
//                                                    letterSpacing: 0.27,
//                                                    color: DesignCourseAppTheme
//                                                        .grey,
//                                                  ),
//                                                ),
//                                                Container(
//                                                  child: Row(
//                                                    children: <Widget>[
//                                                      Text(
//                                                        '${category.rating}',
//                                                        textAlign:
//                                                            TextAlign.left,
//                                                        style: TextStyle(
//                                                          fontWeight:
//                                                              FontWeight.w200,
//                                                          fontSize: 18,
//                                                          letterSpacing: 0.27,
//                                                          color:
//                                                              DesignCourseAppTheme
//                                                                  .grey,
//                                                        ),
//                                                      ),
//                                                      Icon(
//                                                        Icons.star,
//                                                        color:
//                                                            DesignCourseAppTheme
//                                                                .nearlyBlue,
//                                                        size: 20,
//                                                      ),
//                                                    ],
//                                                  ),
//                                                )
//                                              ],
//                                            ),
//                                          ),
//                                          Padding(
//                                            padding: const EdgeInsets.only(
//                                                bottom: 16, right: 16),
//                                            child: Row(
//                                              mainAxisAlignment:
//                                                  MainAxisAlignment
//                                                      .spaceBetween,
//                                              crossAxisAlignment:
//                                                  CrossAxisAlignment.start,
//                                              children: <Widget>[
//                                                Text(
//                                                  '\₹${category.money}',
//                                                  textAlign: TextAlign.left,
//                                                  style: TextStyle(
//                                                    fontWeight: FontWeight.w600,
//                                                    fontSize: 18,
//                                                    letterSpacing: 0.27,
//                                                    color: DesignCourseAppTheme
//                                                        .nearlyBlue,
//                                                  ),
//                                                ),
//                                                Container(
//                                                  decoration: BoxDecoration(
//                                                    color: DesignCourseAppTheme
//                                                        .nearlyBlue,
//                                                    borderRadius:
//                                                        const BorderRadius.all(
//                                                            Radius.circular(
//                                                                8.0)),
//                                                  ),
//                                                  child: Padding(
//                                                    padding:
//                                                        const EdgeInsets.all(
//                                                            4.0),
//                                                    child: Icon(
//                                                      Icons.add,
//                                                      color:
//                                                          DesignCourseAppTheme
//                                                              .nearlyWhite,
//                                                    ),
//                                                  ),
//                                                )
//                                              ],
//                                            ),
//                                          ),
//                                        ],
//                                      ),
//                                    ),
//                                  ),
//                                ],
//                              ),
//                            ),
//                          )
//                        ],
//                      ),
//                    ),
//                    Container(
//                      child: Padding(
//                        padding: const EdgeInsets.only(
//                            top: 24, bottom: 24, left: 16),
//                        child: Row(
//                          children: <Widget>[
//                            ClipRRect(
//                              borderRadius:
//                                  const BorderRadius.all(Radius.circular(16.0)),
//                              child: AspectRatio(
//                                  aspectRatio: 1.0,
//                                  child: Image.asset(category.imagePath)),
//                            )
//                          ],
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          ),
//        );
//      },
//    );
//  }
//}
