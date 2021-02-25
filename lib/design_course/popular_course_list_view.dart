import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_dukan/design_course/models/material_list.dart';
import 'package:virtual_dukan/screens/login.dart';
import 'package:virtual_dukan/screens/material_details_info.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:ribbon/ribbon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'design_course_app_theme.dart';
import 'models/category.dart';

class PopularCourseListView extends StatefulWidget {
  @override
  _PopularCourseListViewState createState() => _PopularCourseListViewState();
}

class _PopularCourseListViewState extends State<PopularCourseListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<MaterialList> _listMaterial;
  Future<List<MaterialList>> _future;

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

//  @override
//  void dispose() {
//    animationController.dispose();
//    super.dispose();
//  }

  Future<List<MaterialList>> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kGetMaterialListMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
    print('response from MaterialList ${response.body}');
    var data = jsonDecode(response.body);
    var material = data['courses'] as List;
    if (response.statusCode == 200) {
      _listMaterial = material
          .map<MaterialList>((json) => MaterialList.fromJson(json))
          .toList();
      print('material list $_listMaterial');
      return _listMaterial;
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
        child: FutureBuilder<List<MaterialList>>(
          future: _future,
          builder: (BuildContext context,
              AsyncSnapshot<List<MaterialList>> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: _listMaterial.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      _listMaterial.length > 10 ? 10 : _listMaterial.length;
                  double different =
                      double.parse(_listMaterial[index].mrpPrice) -
                          double.parse(_listMaterial[index].salePrice);
                  different = different *
                      100 /
                      double.parse(_listMaterial[index].mrpPrice);

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
                                  builder: (context) => MaterialDetailsInfo(
                                      id: _listMaterial[index].id,
                                      discount: different,
                                      type:
                                          _listMaterial[index].typeOfCourse)));

//                              callback();
                            },
                            child: Ribbon(
                              nearLength: nearLength,
                              farLength: farLength,
                              title:
                                  (_listMaterial[index].typeOfCourse == 'free')
                                      ? 'Free'
                                      : (_listMaterial[index].typeOfCourse ==
                                              'paid')
                                          ? 'Paid'
                                          : 'Purchase',
                              titleStyle: TextStyle(
                                  color: UtilsData.kWhite,
                                  fontWeight: FontWeight.w500),
                              color:
                                  (_listMaterial[index].typeOfCourse == 'free')
                                      ? Colors.blue
                                      : (_listMaterial[index].typeOfCourse ==
                                              'paid')
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
                                                                _listMaterial[
                                                                index]
                                                                    .title,
                                                                maxLines: 3,
                                                                overflow:
                                                                TextOverflow
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
                                                                  'Std. ${_listMaterial[index].standardName} ',
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
                                                                Visibility(
                                                                  visible:
                                                                      false,
                                                                  child: Row(
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        _listMaterial[index].typeOfCourse ==
                                                                                'free'
                                                                            ? ''
                                                                            : '\₹${_listMaterial[index].mrpPrice}',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w200,
                                                                          fontSize:
                                                                              12,
                                                                          letterSpacing:
                                                                              0.27,
                                                                          color:
                                                                              DesignCourseAppTheme.grey,
                                                                          decoration:
                                                                              TextDecoration.lineThrough,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              5),
                                                                      Text(
                                                                        _listMaterial[index].typeOfCourse ==
                                                                                'free'
                                                                            ? ''
                                                                            : '\₹${_listMaterial[index].salePrice}',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style:
                                                                            TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.w200,
                                                                          fontSize:
                                                                              12,
                                                                          letterSpacing:
                                                                              0.27,
                                                                          color:
                                                                              DesignCourseAppTheme.nearlyBlue,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
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
                                                                  '${_listMaterial[index].boardName}',
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
                                                                  '${_listMaterial[index].mediumName}',
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
                                                            '${_listMaterial[index].streamName}',
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
                                                  _listMaterial[index]
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
              /*GridView(
                padding: const EdgeInsets.all(8),
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                children: List<Widget>.generate(
                  _listMaterial.length,
                  (int index) {
                    final int count = _listMaterial.length;
                    double different =
                        double.parse(_listMaterial[index].mrpPrice) -
                            double.parse(_listMaterial[index].salePrice);
                    different = different *
                        100 /
                        double.parse(_listMaterial[index].mrpPrice);
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animationController,
                        curve: Interval((1 / count) * index, 1.0,
                            curve: Curves.fastOutSlowIn),
                      ),
                    );
                    animationController.forward();
                    return AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget child) {
                        return FadeTransition(
                          opacity: animation,
                          child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 50 * (1.0 - animation.value), 0.0),
                            child: GestureDetector(
                              onTap: () {
                                print('click on item $index');
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => MaterialDetailsInfo(
                                            id: _listMaterial[index].id,
                                            discount: different,
                                            type:
                                                _listMaterial[index].typeOfCourse,
                                          )),
                                );

//                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>CourseInfoScreen()),);

//                  callback();
                              },
                              child: Ribbon(
                                nearLength: nearLength,
                                farLength: farLength,
                                title: _listMaterial[index].typeOfCourse == 'free'
                                    ? 'Free'
                                    : 'Paid',
                                titleStyle: TextStyle(
                                    color: UtilsData.kWhite,
                                    fontWeight: FontWeight.w500),
                                color: _listMaterial[index].typeOfCourse == 'free'
                                    ? Colors.blue
                                    : Colors.redAccent,
                                location: location,
                                child: SizedBox(
                                  height: 280,
                                  child: Stack(
                                    alignment: AlignmentDirectional.bottomCenter,
                                    children: <Widget>[
                                      Container(
                                        child: Column(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: HexColor('#F8FAFB'),
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                          Radius.circular(16.0)),
                                                  // border: new Border.all(
                                                  //     color: DesignCourseAppTheme.notWhite),
                                                ),
                                                child: Column(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          children: <Widget>[
                                                            Container(
                                                              child: Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topLeft,
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          top: 10,
                                                                          left:
                                                                              16,
                                                                          right:
                                                                              16),
                                                                  child: Text(
                                                                    _listMaterial[
                                                                            index]
                                                                        .title,
                                                                    maxLines: 3,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
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
                                                                ),
                                                              ),
                                                              height: 60,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 16,
                                                                      right: 16,
                                                                      bottom: 2),
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
                                                                    'Std. ${_listMaterial[index].standardName} ',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    maxLines: 3,
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
                                                                  Container(
                                                                    child: Row(
                                                                      children: <
                                                                          Widget>[
                                                                        Text(
                                                                          _listMaterial[index].typeOfCourse ==
                                                                                  'free'
                                                                              ? ''
                                                                              : '\₹${_listMaterial[index].mrpPrice}',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w200,
                                                                            fontSize:
                                                                                12,
                                                                            letterSpacing:
                                                                                0.27,
                                                                            color:
                                                                                DesignCourseAppTheme.grey,
                                                                            decoration:
                                                                                TextDecoration.lineThrough,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                5),
                                                                        Text(
                                                                          _listMaterial[index].typeOfCourse ==
                                                                                  'free'
                                                                              ? ''
                                                                              : '\₹${_listMaterial[index].salePrice}',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style:
                                                                              TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w200,
                                                                            fontSize:
                                                                                12,
                                                                            letterSpacing:
                                                                                0.27,
                                                                            color:
                                                                                DesignCourseAppTheme.nearlyBlue,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 16,
                                                                      right: 16,
                                                                      bottom: 8),
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
                                                                    '${_listMaterial[index].boardName}',
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
                                                                    '${_listMaterial[index].mediumName}',
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
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 48,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 48,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 24, right: 16, left: 16),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16.0)),
                                              boxShadow: <BoxShadow>[
                                                BoxShadow(
                                                    color: DesignCourseAppTheme
                                                        .grey
                                                        .withOpacity(0.2),
                                                    offset:
                                                        const Offset(0.0, 0.0),
                                                    blurRadius: 6.0),
                                              ],
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(16.0)),
                                              child: AspectRatio(
                                                  aspectRatio: 1.28,
                                                  child: Image.network(
                                                    _listMaterial[index]
                                                        .thumbnailUrl,
                                                    fit: BoxFit.fill,
                                                  )),
                                            ),
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
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 32.0,
                  crossAxisSpacing: 32.0,
                  childAspectRatio: 0.8,
                ),
              );*/
            }
          },
        ),
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView({Key key,
    this.category,
    this.animationController,
    this.animation,
    this.callback})
      : super(key: key);

  final VoidCallback callback;
  final Category category;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 50 * (1.0 - animation.value), 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                callback();
              },
              child: SizedBox(
                height: 280,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    Container(
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: HexColor('#F8FAFB'),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                                // border: new Border.all(
                                //     color: DesignCourseAppTheme.notWhite),
                              ),
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16, left: 16, right: 16),
                                            child: Text(
                                              category.title,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: DesignCourseAppTheme
                                                    .darkerText,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8,
                                                left: 16,
                                                right: 16,
                                                bottom: 8),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
//                                                  '${category.lessonCount} lesson',
                                                  '10',
                                                  textAlign: TextAlign.left,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w200,
                                                    fontSize: 12,
                                                    letterSpacing: 0.27,
                                                    color: DesignCourseAppTheme
                                                        .grey,
                                                  ),
                                                ),
                                                Container(
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text(
//                                                        '${category.rating}',
                                                        '4.0',
                                                        textAlign:
                                                        TextAlign.left,
                                                        style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.w200,
                                                          fontSize: 18,
                                                          letterSpacing: 0.27,
                                                          color:
                                                          DesignCourseAppTheme
                                                              .grey,
                                                        ),
                                                      ),
                                                      Icon(
                                                        Icons.star,
                                                        color:
                                                        DesignCourseAppTheme
                                                            .nearlyBlue,
                                                        size: 20,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 48,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding:
                        const EdgeInsets.only(top: 24, right: 16, left: 16),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: DesignCourseAppTheme.grey
                                      .withOpacity(0.2),
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 6.0),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                            child: AspectRatio(
                                aspectRatio: 1.28,
                                child: /*Image.asset(category.imagePath)),*/ Text(
                                    'hs')),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
