import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_dukan/design_course/design_course_app_theme.dart';
import 'package:virtual_dukan/design_course/models/StationaryDetailsModel.dart';
import 'package:virtual_dukan/design_course/models/product_details_list_model.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_items.dart';

class ProductDetailsInfo extends StatefulWidget {
  final int id;
  final double different;

  const ProductDetailsInfo({this.id, this.different});

  @override
  _ProductDetailsInfoState createState() => _ProductDetailsInfoState();
}

class _ProductDetailsInfoState extends State<ProductDetailsInfo>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  ProgressDialog progressDialog;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  Future<ProductDetailsListModel> _future;
  int _availableQuantity;


  @override
  void initState() {
    _availableQuantity=0;
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    _future = getData();
    setData();
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
    progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage(UtilsData.kLoadingMsg);
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: FutureBuilder(
          future: _future,
          builder: (BuildContext context,
              AsyncSnapshot<ProductDetailsListModel> snapshot) {
            if (!snapshot.hasData) {
              return SizedBox(
                child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      backgroundColor: Colors.blue,
                    ),),
              );
            } else {
              _availableQuantity=int.parse(snapshot.data.product.quantity);
              print('available quantity $_availableQuantity');
              return Scaffold(
                backgroundColor: Colors.transparent,
                body: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1.2,
                          child: Image.network(
                              snapshot.data.product.thumbnailUrl),
                        ),
                      ],
                    ),
                    SafeArea(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          margin: EdgeInsets.all(20),
                          width: 50,
                          height: 50,
                          child: Center(
                            child: Text(
                              widget.different.toStringAsFixed(0) + '%\noff',
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
                              shape: BoxShape.circle, color: Colors.redAccent),
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: DesignCourseAppTheme.nearlyWhite,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(32.0),
                              topRight: Radius.circular(32.0)),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: DesignCourseAppTheme.grey.withOpacity(
                                    0.2),
                                offset: const Offset(1.1, 1.1),
                                blurRadius: 10.0),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DefaultTabController(
                              length: 3,
                              initialIndex: 1,
                              child: Scaffold(
                                  backgroundColor: Colors.white,
                                  bottomNavigationBar: InkWell(
                                    onTap: () {
                                      progressDialog.show();
                                      _addToCartItem(
                                          id: snapshot.data.product.id,
                                          context: context);
                                    },
                                    child: _availableQuantity>=1?Container(
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: UtilsData.kDarkBlue,
                                        borderRadius: const BorderRadius.all(
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
                                    ):Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text('Out Of Stock',textAlign: TextAlign.center,style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.red,fontWeight: FontWeight.w900,fontSize: 19,),),
                                    ),
                                  ),
                                  body: Column(
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: SingleChildScrollView(
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 8),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: 32.0,
                                                      left: 18,
                                                      right: 16),
                                                  child: Text(
                                                    snapshot.data.product.name,
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      fontSize: 22,
                                                      letterSpacing: 0.27,
                                                      color: DesignCourseAppTheme
                                                          .darkerText,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
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
                                                    CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          Text(
                                                            '\₹${snapshot.data
                                                                .product
                                                                .mrpPrice}',
                                                            textAlign: TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w200,
                                                              fontSize: 16,
                                                              letterSpacing: 0.27,
                                                              color:
                                                              DesignCourseAppTheme
                                                                  .grey,
                                                              decoration: TextDecoration
                                                                  .lineThrough,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
//                                                          '\₹${snapshot.data.product.sellPrice}(${widget.different.toStringAsFixed(2)}%)',
                                                            '\₹${snapshot.data
                                                                .product
                                                                .sellPrice}',
                                                            textAlign: TextAlign
                                                                .left,
                                                            style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.w200,
                                                              fontSize: 22,
                                                              letterSpacing: 0.27,
                                                              color:
                                                              DesignCourseAppTheme
                                                                  .nearlyBlue,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: <Widget>[
                                                            Text(
                                                              '4.3',
                                                              textAlign: TextAlign
                                                                  .left,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.w200,
                                                                fontSize: 22,
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
                                                              size: 24,
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                AnimatedOpacity(
                                                  duration: const Duration(
                                                    milliseconds: 500,
                                                  ),
                                                  opacity: opacity1,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .all(
                                                      8,
                                                    ),
                                                    child: Wrap(
                                                      children: <Widget>[
                                                        Visibility(
                                                          visible: snapshot.data.product
                                                              .commonProduct==1?false:true,
                                                          child: getTimeBoxUI(
                                                            snapshot.data.product
                                                                .subjectName,
                                                            '',
                                                          ),
                                                        ),
//                                                      getTimeBoxUI(
//                                                        snapshot.data.product.stationaryInfo.name,
//                                                        'Stationary Name',
//                                                      ),
                                                        getTimeBoxUI(
                                                          snapshot.data.product
                                                              .keywords,
                                                          '',
                                                        ),
                                                        getTimeBoxUI(
                                                          'Set Of',
                                                          snapshot.data.product
                                                              .setOf,

                                                        ),
                                                        getTimeBoxUI(
                                                          snapshot.data.product
                                                              .quantity,
                                                          'In Stock',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                AnimatedOpacity(
                                                  duration: const Duration(
                                                    milliseconds: 500,
                                                  ),
                                                  opacity: opacity2,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .only(
                                                      left: 16,
                                                      right: 16,
                                                      top: 8,
                                                      bottom: 8,
                                                    ),
                                                    child: Column(
                                                      children: <Widget>[
                                                        Html(
                                                          data: snapshot.data
                                                              .product
                                                              .description,
                                                          shrinkWrap: true,
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                        ),
                                                        Container(
                                                          height: 100,
                                                          color: Colors.white,
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery
                                                      .of(context)
                                                      .padding
                                                      .bottom,
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery
                          .of(context)
                          .padding
                          .top),
                      child: SizedBox(
                        width: AppBar().preferredSize.height,
                        height: AppBar().preferredSize.height,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius:
                            BorderRadius.circular(
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
                ),
              );
            }
          }
      ),
    );
  }

  Future<void> _addToCartItem({int id, BuildContext context}) async {
    print('id $id');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    print(
        'request ${UtilsData.kBaseUrl + UtilsData.kAddCartMethod + id.toString()}');
    final http.Response response = await http
        .post(UtilsData.kBaseUrl + UtilsData.kAddCartMethod + id.toString(),
            headers: <String, String>{
              UtilsData.kHeaderType: UtilsData.kHeaderValue,
              UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
            },
            body: jsonEncode(<String, String>{
              'type': 'product',
            }))
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
        )..show();
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
        )..show();
      }
    } else {
      return UtilsData.kErrorDialog(
          context: context,
          errorMsg: _responseData[UtilsData.kResponseErrorMessage]);
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

  Future<ProductDetailsListModel> getData() async {
//    _progressDialog.setMessage(UtilsData.kLoadingMsg);
//    _progressDialog.show();
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      print('token ${preferences.getString(UtilsData.kToken)}');
      final response = await http.get(
        UtilsData.kBaseUrl + UtilsData.kProductDetailsMethod +
            '/${widget.id}',
        headers: <String, String>{
          UtilsData.kHeaderType: UtilsData.kHeaderValue,
          UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
        },
      ).timeout(Duration(hours: 1));
      print('product details ${jsonDecode(response.body)}');
//      _progressDialog.hide();
      if (response.statusCode == 200) {
        return ProductDetailsListModel.fromJson(jsonDecode(response.body));
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
        throw Exception('Failed to load course list');
      }
    } catch (exception) {
      print('exception $exception');
    }
  }

}
