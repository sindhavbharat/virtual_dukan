import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_dukan/design_course/models/course_list.dart';
import 'package:virtual_dukan/screens/course_details_info.dart';
import 'package:virtual_dukan/screens/login.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:ribbon/ribbon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'design_course_app_theme.dart';

class CategoryListView extends StatefulWidget {
  const CategoryListView({Key key, this.callBack}) : super(key: key);

  final Function callBack;

  @override
  _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<CourseList> _listCourse;
  bool _enabled = false;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<List<CourseList>> _getTopicWiseData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kGetCourseListMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
    print('response from topic wise $response');
    var data = jsonDecode(response.body);
    var courses = data['courses'] as List;
    if (response.statusCode == 200) {
      _listCourse =
          courses.map<CourseList>((json) => CourseList.fromJson(json)).toList();
      print('courselist $_listCourse');
      return _listCourse;
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

  @override
  Widget build(BuildContext context) {
    double nearLength = 30;
    double farLength = 50;
    RibbonLocation location = RibbonLocation.topEnd;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 140,
        width: double.infinity,
        child: ModalRoute.of(context).isCurrent
            ? FutureBuilder<List<CourseList>>(
                future: _getTopicWiseData(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<CourseList>> snapshot) {
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 0, right: 16, left: 16),
                      itemCount: _listCourse.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                  final int count =
                      _listCourse.length > 10 ? 10 : _listCourse.length;
                  double different = double.parse(_listCourse[index].mrpPrice) -
                      double.parse(_listCourse[index].salePrice);
                  different = different *
                      100 /
                      double.parse(_listCourse[index].mrpPrice);

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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CourseDetailsInfo(
                                      id: _listCourse[index].id,
                                      discount: different,
                                      type: _listCourse[index].typeOfCourse)));

//                              callback();
                            },
                            child: Ribbon(
                              nearLength: nearLength,
                              farLength: farLength,
                              title: (_listCourse[index].typeOfCourse == 'free')
                                  ? 'Free'
                                  : (_listCourse[index].typeOfCourse == 'paid')
                                      ? 'Paid'
                                      : 'Purchase',
                              titleStyle: TextStyle(
                                  color: UtilsData.kWhite,
                                  fontWeight: FontWeight.w500),
                              color: (_listCourse[index].typeOfCourse == 'free')
                                  ? Colors.blue
                                  : (_listCourse[index].typeOfCourse == 'paid')
                                      ? Colors.redAccent
                                      : Colors.green,
                              location: location,
                              child: SizedBox(
                                width: 280,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      child: Row(
                                        children: <Widget>[
                                          const SizedBox(
                                            width: 48,
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: HexColor('#F8FAFB'),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(16.0)),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  const SizedBox(
                                                    width: 48 + 24.0,
                                                  ),
                                                  Expanded(
                                                    child: Container(
                                                      child: Column(
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 16),
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .topLeft,
                                                              child: Text(
                                                                _listCourse[
                                                                index]
                                                                    .title,
                                                                maxLines: 3,
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                textAlign:
                                                                TextAlign
                                                                    .left,
                                                                style:
                                                                TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                                  fontSize: 14,
                                                                  letterSpacing:
                                                                      0.27,
                                                                  color: DesignCourseAppTheme
                                                                      .darkerText,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          const Expanded(
                                                            child: SizedBox(),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 16,
                                                                    bottom: 8),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  'Std. ${_listCourse[index].standardName} ',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w200,
                                                                    fontSize:
                                                                        12,
                                                                    letterSpacing:
                                                                        0.27,
                                                                    color:
                                                                        DesignCourseAppTheme
                                                                            .grey,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      _listCourse[index].typeOfCourse ==
                                                                              'free'
                                                                          ? ''
                                                                          : '\₹${_listCourse[index].mrpPrice}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w200,
                                                                        fontSize:
                                                                            12,
                                                                        letterSpacing:
                                                                            0.27,
                                                                        color: DesignCourseAppTheme
                                                                            .grey,
                                                                        decoration:
                                                                            TextDecoration.lineThrough,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            5),
                                                                    Text(
                                                                      _listCourse[index].typeOfCourse ==
                                                                              'free'
                                                                          ? ''
                                                                          : '\₹${_listCourse[index].salePrice}',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight.w200,
                                                                        fontSize:
                                                                            12,
                                                                        letterSpacing:
                                                                            0.27,
                                                                        color: DesignCourseAppTheme
                                                                            .nearlyBlue,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 2,
                                                                    right: 16),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  '${_listCourse[index].boardName}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        12,
                                                                    letterSpacing:
                                                                        0.27,
                                                                    color: DesignCourseAppTheme
                                                                        .nearlyBlue,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  '${_listCourse[index].mediumName}',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .left,
                                                                  style:
                                                                      TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        12,
                                                                    letterSpacing:
                                                                        0.27,
                                                                    color: DesignCourseAppTheme
                                                                        .darkerText,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Text(
                                                            '${_listCourse[index].streamName}',
                                                            textAlign:
                                                                TextAlign.left,
                                                            softWrap: true,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  0.27,
                                                              color:
                                                                  DesignCourseAppTheme
                                                                      .darkerText,
                                                            ),
                                                          ),
//                                                          Padding(
//                                                            padding:
//                                                                const EdgeInsets
//                                                                        .only(
//                                                                    right: 16,
//                                                                    bottom: 8),
//                                                            child: Align(
//                                                              alignment: Alignment.topLeft,
//                                                              child: Text(
//                                                                '${_listCourse[index].description}',
//                                                                overflow: TextOverflow.ellipsis,
//                                                                textAlign:
//                                                                    TextAlign
//                                                                        .left,
//                                                                style: TextStyle(
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
//                                                            )
//                                                            /*Row(
//                                                              mainAxisAlignment:
//                                                                  MainAxisAlignment
//                                                                      .spaceBetween,
//                                                              crossAxisAlignment:
//                                                                  CrossAxisAlignment
//                                                                      .center,
//                                                              children: <Widget>[
//                                                                Text(
//                                                                  '${_listCourse[index].description}',
//                                                                  textAlign:
//                                                                      TextAlign
//                                                                          .left,
//                                                                  style:
//                                                                      TextStyle(
//                                                                    fontWeight:
//                                                                        FontWeight
//                                                                            .w200,
//                                                                    fontSize: 12,
//                                                                    letterSpacing:
//                                                                        0.27,
//                                                                    color:
//                                                                        DesignCourseAppTheme
//                                                                            .grey,
//                                                                  ),
//                                                                ),
////                                                              Container(
////                                                                child: Row(
////                                                                  children: <Widget>[
////                                                                    Text(
////                                                                      '${category.rating}',
////                                                                      textAlign:
////                                                                      TextAlign.left,
////                                                                      style: TextStyle(
////                                                                        fontWeight:
////                                                                        FontWeight.w200,
////                                                                        fontSize: 18,
////                                                                        letterSpacing: 0.27,
////                                                                        color:
////                                                                        DesignCourseAppTheme
////                                                                            .grey,
////                                                                      ),
////                                                                    ),
////                                                                    Icon(
////                                                                      Icons.star,
////                                                                      color:
////                                                                      DesignCourseAppTheme
////                                                                          .nearlyBlue,
////                                                                      size: 20,
////                                                                    ),
////                                                                  ],
////                                                                ),
////                                                              )
//                                                              ],
//                                                            )*/
//                                                            ,
//                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom: 16,
                                                                    right: 16),
//                                                            child: Row(
//                                                              mainAxisAlignment:
//                                                                  MainAxisAlignment
//                                                                      .spaceBetween,
//                                                              crossAxisAlignment:
//                                                                  CrossAxisAlignment
//                                                                      .start,
//                                                              children: <Widget>[
//                                                                Text(
//                                                                  '${_listCourse[index].typeOfCourse}',
//                                                                  textAlign:
//                                                                      TextAlign
//                                                                          .left,
//                                                                  style:
//                                                                      TextStyle(
//                                                                    fontWeight:
//                                                                        FontWeight
//                                                                            .w600,
//                                                                    fontSize: 18,
//                                                                    letterSpacing:
//                                                                        0.27,
//                                                                    color: DesignCourseAppTheme
//                                                                        .nearlyBlue,
//                                                                  ),
//                                                                ),
//                                                                Visibility(
//                                                                  visible: false,
//                                                                  child: Container(
//                                                                    decoration:
//                                                                        BoxDecoration(
//                                                                      color: DesignCourseAppTheme
//                                                                          .nearlyBlue,
//                                                                      borderRadius:
//                                                                          const BorderRadius
//                                                                              .all(
//                                                                        Radius
//                                                                            .circular(
//                                                                                8.0),
//                                                                      ),
//                                                                    ),
//                                                                    child: Padding(
//                                                                      padding:
//                                                                          const EdgeInsets
//                                                                                  .all(
//                                                                              4.0),
//                                                                      child: Icon(
//                                                                        Icons.add,
//                                                                        color: DesignCourseAppTheme
//                                                                            .nearlyWhite,
//                                                                      ),
//                                                                    ),
//                                                                  ),
//                                                                )
//                                                              ],
//                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 24, bottom: 24, left: 16),
                                        child: Row(
                                          children: <Widget>[
                                            ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(16.0),
                                              ),
                                              child: AspectRatio(
                                                aspectRatio: 1.0,
                                                child: Image.network(
                                                  _listCourse[index]
                                                      .thumbnailUrl,
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
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
        ) : SizedBox(),
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
