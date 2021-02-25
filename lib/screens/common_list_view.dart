import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_dukan/design_course/design_course_app_theme.dart';
import 'package:virtual_dukan/design_course/models/common_list_model.dart';
import 'package:virtual_dukan/design_course/models/material_list.dart';
import 'package:virtual_dukan/design_course/models/gseb_list_model.dart';
import 'package:virtual_dukan/screens/login.dart';
import 'package:virtual_dukan/screens/product_details_info.dart';
import 'package:virtual_dukan/screens/stationary_details_info.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:ribbon/ribbon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CommonListView extends StatefulWidget {
  @override
  _CommonListViewState createState() => _CommonListViewState();
}

class _CommonListViewState extends State<CommonListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  Future<CommonListModel> _future;

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

  Future<CommonListModel> getData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kGetCommonListMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
    print('response from stationary data ${response.body}');
    if (response.statusCode == 200) {
      return CommonListModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.WARNING,
        animType: AnimType.BOTTOMSLIDE,
        title: UtilsData.kOops,
        desc: UtilsData.kMultiLoginMsg,
        dismissOnBackKeyPress: false,
        dismissOnTouchOutside: false,
        btnCancel: null,
//        btnCancelOnPress: () {},
        btnOkOnPress: () {
          preferences.clear();
          exit(0);
        },
      )..show();
    } else {
      throw Exception('Failed to load stationary list');
    }
  }

  @override
  Widget build(BuildContext context) {
    double nearLength = 30;
    double farLength = 50;
    RibbonLocation location = RibbonLocation.topEnd;
    RibbonLocation locationLeft = RibbonLocation.topStart;
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: 185,
        width: double.infinity,
        child: FutureBuilder<CommonListModel>(
          future: _future,
          builder: (BuildContext context,
              AsyncSnapshot<CommonListModel> snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: snapshot.data.products.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count = snapshot.data.products.length > 10
                      ? 10
                      : snapshot.data.products.length;
                  double different =
                      double.parse(snapshot.data.products[index].mrpPrice) -
                          double.parse(snapshot.data.products[index].sellPrice);
                  different = different *
                      100 /
                      double.parse(snapshot.data.products[index].mrpPrice);

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
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailsInfo(
                                        id: snapshot.data.products[index].id,
                                        different: different,
                                      )));

//                              callback();
                            },
                            child: Column(
                              children: <Widget>[
                                Ribbon(
                                  nearLength: nearLength,
                                  farLength: farLength,
                                  title: different.toStringAsFixed(0) + '%Off',
                                  titleStyle: TextStyle(
                                      color: UtilsData.kWhite,
                                      fontWeight: FontWeight.w500),
                                  color: Colors.redAccent,
                                  location: location,
                                  child: Container(
                                    margin: EdgeInsets.all(10.0),
                                    width: 170,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16.0),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          snapshot.data.products[index]
                                              .thumbnailUrl,
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      snapshot.data.products[index].name,
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
                                SizedBox(
                                  height: 5,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            '\₹${snapshot.data.products[index]
                                                .mrpPrice}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 14,
                                              letterSpacing: 0.27,
                                              color: DesignCourseAppTheme.grey,
                                              decoration:
                                              TextDecoration.lineThrough,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
//                                            '\₹${snapshot.data.products[index].sellPrice}(${different.toStringAsFixed(2)}%)',
                                            '\₹${snapshot.data.products[index]
                                                .sellPrice}',
                                            textAlign: TextAlign.left,
                                            style: TextStyle(
                                              fontWeight: FontWeight.w200,
                                              fontSize: 14,
                                              letterSpacing: 0.27,
                                              color: DesignCourseAppTheme
                                                  .nearlyBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
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
            }
          },
        ),
      ),
    );
  }
}
