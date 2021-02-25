import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:virtual_dukan/design_course/design_course_app_theme.dart';
import 'package:virtual_dukan/design_course/models/my_order_list.dart';
import 'package:virtual_dukan/screens/navigation_home_screen.dart';
import 'package:virtual_dukan/screens/product_details_info.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:ribbon/ribbon.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'course_details_info.dart';

class MyOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UtilsData.kWhite,
      body: OrderDetails(),
    );
  }
}

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  ProgressDialog progressDialog;
  String _subTotal = '';
  int amount;
  String _discount = '';
  String _hash = '';
  String _txnId = '';
  String _platformVersion = 'Unknown';
  String paymentID = "";
  bool isCartDisplay;
  final DateFormat formatter = DateFormat('dd-MMM-yyyy');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isCartDisplay = false;
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage(UtilsData.kLoadingMsg);
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _appBar(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(bottom: 200),
                      child: buildShoppingCartItem(context)),
//                  SingleChildScrollView(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//
//
//                      ],
//                    ),
//                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildShoppingCartItem(BuildContext context) {
    RibbonLocation location = RibbonLocation.topEnd;
    double nearLength = 50;
    double farLength = 70;
    return FutureBuilder<MyOrderListModel>(
        future: _getMyOrderData(),
        builder:
            (BuildContext context, AsyncSnapshot<MyOrderListModel> snapshot) {
          print('snapshot data ${snapshot.data}');
          if (!snapshot.hasData) {
            return const SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(
                  8.0,
                ),
                child: Center(child: CircularProgressIndicator()),
              ),
            );
          } else {
            if (snapshot.data.orders == null) {
              print('null call');
              return Image.asset(
                UtilsData.kEmptyImageDir,
                fit: BoxFit.fill,
              );
            } else {
              print('not null call');
              return Align(
                alignment: Alignment.topLeft,
                child: ListView.builder(
                  itemCount: snapshot.data.orders.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    print('index $index');
                    double different = double.parse(
                            snapshot.data.orders[index].items.mrpPrice) -
                        double.parse(
                            snapshot.data.orders[index].items.salePrice);
                    different = different *
                        100 /
                        double.parse(
                            snapshot.data.orders[index].items.mrpPrice);
                    return Ribbon(
                      nearLength: nearLength,
                      farLength: farLength,
                      title: '${different.toStringAsFixed(0) + '%off'}',
                      titleStyle: TextStyle(
                          color: UtilsData.kWhite, fontWeight: FontWeight.w500),
                      color: Colors.blue,
                      location: location,
                      child: Container(
                        padding:
                            EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                        height: 170,
                        child: Card(
                          elevation: 5,
                          shadowColor: Colors.black,
                          child: ListTile(
                            leading: Image.network(
                              snapshot.data.orders[index].items.thumbnail,
                            ),
                            title: Text(
                              snapshot.data.orders[index].items.productTitle,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontFamily: UtilsData.kProximaFontName),
                            ),
                            trailing: IconButton(
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsInfo(
                                        id: snapshot
                                            .data.orders[index].items.productId,
                                        different: different,
                                      ),
                                    ),
                                  );
                                }),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 5.00,
                                ),
                                Text(
                                  'Transaction Id : ${snapshot.data.orders[index].txnId}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: UtilsData.kProximaFontName),
                                ),
                                SizedBox(
                                  height: 5.00,
                                ),
                                Row(
                                  children: <Widget>[
                                    // Text(
                                    //   '\₹${snapshot.data.orders[index].items.mrpPrice}',
                                    //   textAlign: TextAlign.left,
                                    //   style: TextStyle(
                                    //     fontWeight: FontWeight.w200,
                                    //     letterSpacing: 0.27,
                                    //     color: DesignCourseAppTheme.grey,
                                    //     decoration: TextDecoration.lineThrough,
                                    //   ),
                                    // ),
                                    // SizedBox(
                                    //   width: 5,
                                    // ),
                                    Expanded(
                                      child: Text(
                                        // '\₹${snapshot.data.orders[index].items.salePrice}(${different.toStringAsFixed(2)}%)',
                                        'My Purchase Amount \₹${snapshot.data.orders[index].items.salePrice}',

                                        textAlign: TextAlign.left,
                                       overflow: TextOverflow.visible,
                                        softWrap: true,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.27,
                                          fontSize: 13,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Order on ${formatter.format(
                                    DateTime.parse(
                                        snapshot.data.orders[index].createdAt),
                                  )}',
                                  style: TextStyle(
                                      fontFamily: UtilsData.kProximaFontName),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }
        });
  }

  Widget _appBar() {
    return SizedBox(
      height: AppBar().preferredSize.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppTheme.darkText,
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()))),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'My Orders',
                  style: TextStyle(
                    fontSize: 22,
                    fontFamily: UtilsData.kProximaFontName,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, right: 8),
            child: Container(
              width: AppBar().preferredSize.height - 8,
              height: AppBar().preferredSize.height - 8,
              color: Colors.white,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius:
                      BorderRadius.circular(AppBar().preferredSize.height),
                  child: Icon(
                    Icons.dashboard,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<MyOrderListModel> _getMyOrderData() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      print('token value ${preferences.getString(UtilsData.kToken)}');
      final response = await http.get(
        UtilsData.kBaseUrl + UtilsData.kMyOrderMethod,
        headers: <String, String>{
          UtilsData.kHeaderType: UtilsData.kHeaderValue,
          UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
        },
      );
      var responseData = jsonDecode(response.body);
      print(
          'response of my order $responseData and status code ${response.statusCode}');
      if (response.statusCode == 200) {
        return MyOrderListModel.fromJson(jsonDecode(response.body));
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
          dialogType: DialogType.ERROR,
          animType: AnimType.BOTTOMSLIDE,
          title: 'No Data',
          desc: responseData[UtilsData.kResponseErrorMessage],
          btnCancelOnPress: () {
            Navigator.of(context).pop();
          },
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
        )..show();
      }
    } catch (exception) {
      return throw Exception(exception.toString());
    }
  }
}
