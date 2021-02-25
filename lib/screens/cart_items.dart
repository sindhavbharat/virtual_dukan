import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_payumoney_plugin/flutter_payumoney_plugin.dart';
import 'package:http/http.dart' as http;
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:virtual_dukan/design_course/design_course_app_theme.dart';
import 'package:virtual_dukan/design_course/models/cart_list_model.dart';
import 'package:virtual_dukan/screens/my_order.dart';
import 'package:virtual_dukan/screens/navigation_home_screen.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'course_details_info.dart';

class CartItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
      },
      child: Scaffold(
        backgroundColor: UtilsData.kWhite,
        body: CartDetails(),
      ),
    );
  }
}

class CartDetails extends StatefulWidget {
  @override
  _CartDetailsState createState() => _CartDetailsState();
}

class _CartDetailsState extends State<CartDetails> {
  ProgressDialog progressDialog;
  double _subTotal;
  double _charges;
  List<String> _pinCodeList=List();
  String name = '';
  String _selectedPinCode='';
  double amount;
  double _discount;
  String _hash = '';
  String _txnId = '';
  String _platformVersion = 'Unknown';
  String paymentID = "";
  bool isCartDisplay;
  String mobileNo = '';
  String username = '';
  int shoppingCartCount;
  bool typeOfCart;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _controllerAddress;
  TextEditingController _controllerAddress1;
  TextEditingController _controllerCity;
  TextEditingController _controllerMobile;
  TextEditingController _controllerPinCode;
  FocusNode _focusNodeAddress;
  FocusNode _focusNodeAddress1;
  FocusNode _focusNodeCity;
  FocusNode _focusNodeMobile;
  FocusNode _focusNodePinCode;
  List<DropdownMenuItem> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isCartDisplay = false;
    _controllerAddress = TextEditingController();
    _controllerAddress1 = TextEditingController();
    _controllerCity = TextEditingController();
    _controllerMobile = TextEditingController();
    _controllerPinCode = TextEditingController();
    _focusNodeAddress = FocusNode();
    _focusNodeAddress1 = FocusNode();
    _focusNodeCity = FocusNode();
    _focusNodeMobile = FocusNode();
    _focusNodePinCode = FocusNode();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    mobileNo = _preferences.getString(UtilsData.kPrefMobileKey);
    username = _preferences.getString(UtilsData.kPrefNameKey);
//    print('mobile and username ${mobileNo+' '+username }');
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterPayumoneyPlugin.platformVersion;
      print('platform version $platformVersion');
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      print('platform s $platformVersion');
    });

      getCharges();

  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage(UtilsData.kLoadingMsg);
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery
          .of(context)
          .padding
          .top),
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
                      margin: EdgeInsets.only(bottom: 250),
                      child: buildShoppingCartItem(context),),
//                  SingleChildScrollView(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.stretch,
//                      children: <Widget>[
//
//
//                      ],
//                    ),
//                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20,),
                    child: Visibility(
                      visible: _subTotal == 0 ? false : true,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Expanded(
                                child: SizedBox(),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 8.0, left: 8.0, right: 8.0,),
                                height: 200,
                                child: Card(
                                  elevation: 10.0,
                                  shadowColor: Colors.grey,
                                  child: Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'Subtotal',
                                            ),
                                            Text('\₹$_subTotal',),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('Discount'),
                                            Text(
                                              ('\₹$_discount'),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text('Fix Shipping Charges'),
                                            Text(
                                              ('\₹$_charges'),
                                              style: TextStyle(fontSize: 14),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Text(
                                                  "Total",
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  ('\₹$amount'),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('Estimate Delivery will be done in 24 hours of your order placed. For more info please call 8980808118',textAlign:TextAlign.center,style: Theme.of(context).textTheme.bodyText1.copyWith(color: Colors.red,fontSize: 12,fontWeight: FontWeight.w700,),),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 8.0,
                                    left: 8.0,
                                    right: 8.0,
                                    bottom: 3.0),
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
//                              color: Colors.blueGrey,
                                  onPressed: () {
                                    {
                                      print(('called'));
//                                    FlutterPayumoneyPlugin.payUMoneyPayment(
//                                            environmentMode: 2,
//                                            email:
//                                                "sindhavbharat2195@gmaill.com",
//                                            amount: "1",
//                                            formName: "virtual abhyas",
//                                            mobile: "9558915152",
//                                            UserName: "Bharat Sindhav",
//                                            gNumber: 'ujstoEekBB')
//                                        .then((value) {
//                                      print('PAYMENT ID: $value');
//                                    });
                                      if (typeOfCart ==
                                          true & _controllerAddress.text
                                              .isEmpty) {
                                        showDialog(
                                            context: context, builder: (context) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(20.0)),
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  children: <Widget>[
                                                    Text("Delivery Address",
                                                      style: AppTheme.body1
                                                          .copyWith(
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          letterSpacing: 2.0),),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .fromLTRB(
                                                          16.0, 16.0, 16.0, 8.0),
                                                      child: Form(
                                                        key: _formKey,
                                                        child: Column(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .all(8.0),
                                                              child: TextFormField(
                                                                focusNode: _focusNodeAddress,
                                                                controller: _controllerAddress,
                                                                textInputAction: TextInputAction
                                                                    .next,
                                                                keyboardType: TextInputType
                                                                    .multiline,
                                                                maxLines: 3,
                                                                decoration:
                                                                textDecoration(
                                                                    filedName: UtilsData
                                                                        .kHomeAddress),
                                                                validator: (
                                                                    value) {
                                                                  if (value
                                                                      .isEmpty)
                                                                    return UtilsData
                                                                        .kValidateAddress;
                                                                  else
                                                                    return null;
                                                                },
                                                                onFieldSubmitted: (
                                                                    _) {
                                                                  _focusNodeAddress
                                                                      .unfocus();
                                                                  FocusScope.of(
                                                                      context)
                                                                      .requestFocus(
                                                                      _focusNodeAddress1);
                                                                },
                                                              ),
                                                            ),
                                                            Visibility(
                                                              visible: false,
                                                              child: Padding(
                                                                padding: const EdgeInsets
                                                                    .all(8.0),
                                                                child: TextFormField(
                                                                  focusNode: _focusNodeAddress1,
                                                                  controller: _controllerAddress1,
                                                                  textInputAction: TextInputAction
                                                                      .next,
                                                                  keyboardType: TextInputType
                                                                      .text,
                                                                  decoration:
                                                                  textDecoration(
                                                                      filedName: UtilsData
                                                                          .kAddress2),
                                                                  // validator: (
                                                                  //     value) {
                                                                  //   if (value
                                                                  //       .isEmpty)
                                                                  //     return UtilsData
                                                                  //         .kValidateAddress1;
                                                                  //   else
                                                                  //     return null;
                                                                  // },
                                                                  onFieldSubmitted: (
                                                                      _) {
                                                                    _focusNodeAddress1
                                                                        .unfocus();
                                                                    FocusScope.of(
                                                                        context)
                                                                        .requestFocus(
                                                                        _focusNodeCity);
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .all(8.0),
                                                              child: TextFormField(
                                                                focusNode: _focusNodeCity,
                                                                controller: _controllerCity,
                                                                textInputAction: TextInputAction
                                                                    .next,
                                                                keyboardType: TextInputType
                                                                    .text,
                                                                decoration:
                                                                textDecoration(
                                                                    filedName: UtilsData
                                                                        .kCity),
                                                                validator: (
                                                                    value) {
                                                                  if (value
                                                                      .isEmpty)
                                                                    return UtilsData
                                                                        .kValidateCity;
                                                                  else
                                                                    return null;
                                                                },
                                                                onFieldSubmitted: (
                                                                    _) {
                                                                  UtilsData
                                                                      .focusChange(
                                                                      context: context,
                                                                      currentFocus: _focusNodeCity,
                                                                      nextFocus: _focusNodeMobile);
                                                                },
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .all(8.0),
                                                              child: TextFormField(
                                                                focusNode: _focusNodeMobile,
                                                                controller: _controllerMobile,
                                                                textInputAction: TextInputAction
                                                                    .next,
                                                                keyboardType: TextInputType
                                                                    .number,
                                                                maxLength: 10,
                                                                decoration:
                                                                textDecoration(
                                                                    filedName: UtilsData
                                                                        .kMobile)
                                                                    .copyWith(
                                                                ),
                                                                validator: (
                                                                    value) {
                                                                  if (value
                                                                      .isEmpty)
                                                                    return UtilsData
                                                                        .kValidateMobile;
                                                                  else
                                                                    return null;
                                                                },
                                                                onFieldSubmitted: (
                                                                    _) {
                                                                  _focusNodeMobile
                                                                      .unfocus();
                                                                  FocusScope.of(
                                                                      context)
                                                                      .requestFocus(
                                                                      _focusNodePinCode);
                                                                },
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                  .all(8.0),
                                                              child:  SearchableDropdown.single(
                                                                items: items,
                                                                value: _selectedPinCode,
                                                                hint: "Select Pincode",
                                                                searchHint: "Select one",
                                                                onChanged: (value) {
                                                                  setState(() {
                                                                    _selectedPinCode = value;
                                                                  });
                                                                },
                                                                isExpanded: true,
                                                              ),
                                                              /*TextFormField(
                                                                focusNode: _focusNodePinCode,
                                                                controller: _controllerPinCode,
                                                                textInputAction: TextInputAction
                                                                    .done,
                                                                keyboardType: TextInputType
                                                                    .number,
                                                                maxLength: 6,
                                                                decoration:
                                                                textDecoration(
                                                                    filedName: UtilsData
                                                                        .kPinCode)
                                                                    .copyWith(
                                                                ),
                                                                validator: (
                                                                    value) {
                                                                  if (value
                                                                      .isEmpty)
                                                                    return UtilsData
                                                                        .kValidatePinCode;
                                                                  else
                                                                    return null;
                                                                },
                                                              )*/
                                                            ),
                                                            // Padding(
                                                            //   padding: const EdgeInsets
                                                            //       .all(8.0),
                                                            //   child: DropdownSearch<String>(
                                                            //     validator: (v) => v == null ? "required field" : null,
                                                            //     hint: 'Pin Code',
                                                            //     mode: Mode.MENU,
                                                            //     showSelectedItem: true,
                                                            //     items: _pinCodeList,
                                                            //     // label: "Menu mode *",
                                                            //     showClearButton: true,
                                                            //     // showSearchBox: true,
                                                            //     onChanged: (value){
                                                            //       _selectedPinCode=value;
                                                            //       print('selected value $_selectedPinCode');
                                                            //     },
                                                            //     // popupItemDisabled: (String s) => s.startsWith('I'),
                                                            //     // selectedItem: _pinCodeList[0],
                                                            //   ),
                                                            //   /*TextFormField(
                                                            //     focusNode: _focusNodePinCode,
                                                            //     controller: _controllerPinCode,
                                                            //     textInputAction: TextInputAction
                                                            //         .done,
                                                            //     keyboardType: TextInputType
                                                            //         .number,
                                                            //     maxLength: 6,
                                                            //     decoration:
                                                            //     textDecoration(
                                                            //         filedName: UtilsData
                                                            //             .kPinCode)
                                                            //         .copyWith(
                                                            //     ),
                                                            //     validator: (
                                                            //         value) {
                                                            //       if (value
                                                            //           .isEmpty)
                                                            //         return UtilsData
                                                            //             .kValidatePinCode;
                                                            //       else
                                                            //         return null;
                                                            //     },
                                                            //   )*/
                                                            // ),
                                                            SizedBox(
                                                              height: 20,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin: EdgeInsets.only(
                                                          top: 24.0),
                                                      child: FlatButton(
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius
                                                              .circular(4.0),
                                                        ),
                                                        color: UtilsData
                                                            .kDarkBlue,
                                                        onPressed: () =>
                                                        {
                                                          if(_formKey.currentState
                                                              .validate()){
                                                            _formKey.currentState
                                                                .save(),
                                                            Navigator.of(context)
                                                                .pop()
                                                          }
                                                        },
                                                        child: Container(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            vertical: 15.0,
                                                            horizontal: 10.0,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
                                                                .center,
                                                            children: <Widget>[
                                                              Expanded(
                                                                child: Text(
                                                                  "Confirm",
                                                                  textAlign: TextAlign
                                                                      .center,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight: FontWeight
                                                                          .bold),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      } else {
                                        _checkOut();
                                      }
                                    }
                                  },
                                  child: Container(
                                    height: 48,
                                    decoration: BoxDecoration(
//                                    color: DesignCourseAppTheme.nearlyBlue,
                                      color: Color(0xff00008b),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(
                                          16.0,
                                        ),
                                      ),
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          color: DesignCourseAppTheme.nearlyBlue
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
                                        'Checkout',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                          letterSpacing: 0.0,
                                          color: DesignCourseAppTheme.nearlyWhite,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
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
    );
  }

  Widget buildShoppingCartItem(BuildContext context) {
    return FutureBuilder(
        future: _getCartData(),
        builder: (BuildContext context, AsyncSnapshot<CartListModel> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ),
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else {
            if (_subTotal == 0) {
              return Center(
                child: Image.asset(
                  UtilsData.kEmptyImageDir,
                  fit: BoxFit.fill,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(bottom: 0,),
                child: ListView.builder(
                  itemCount: snapshot.data.items.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics() ,
                  itemBuilder: (BuildContext context, int index) {
                    double different =
                        double.parse(snapshot.data.items[index].mrpPrice) -
                            double.parse(snapshot.data.items[index].salePrice);
                    different = different *
                        100 /
                        double.parse(snapshot.data.items[index].mrpPrice);
                    return Container(
                      padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                      height: 200,
                      child: Card(
                        elevation: 5,
                        shadowColor: Colors.black,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Container(
                              width: (MediaQuery
                                  .of(context)
                                  .size
                                  .width) / 3,
                              child: Column(
                                children: <Widget>[
                                  Image.network(
                                    snapshot.data.items[index].thumbnail,
                                    fit: BoxFit.fill,
                                    height: 120,
                                  ),
                                  snapshot.data.items[index].type == 'product'
                                      ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: <Widget>[
                                        Visibility(
                                          visible:snapshot.data.items[index]
                                        .quantity>1?true:false,
                                          child: IconButton(
                                            icon: Icon(Icons.remove_circle_outline),
                                            onPressed: () {
                                              if (snapshot.data.items[index]
                                                  .quantity > 1) {
                                                progressDialog.show();
                                                deIncrementItem(
                                                    productId: snapshot.data
                                                        .items[index].courseId);
                                              }
                                            },
                                          ),
                                        ),
                                        Text(
                                          '${snapshot.data.items[index]
                                              .quantity}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.add_circle_outline),
                                          onPressed: () {
                                            print('pressed item');
                                            if(snapshot.data.items[index].quantity>=snapshot.data.items[index].productQuantity){
                                              AwesomeDialog(
                                                context: context,
                                                dialogType: DialogType.WARNING,
                                                animType: AnimType.BOTTOMSLIDE,
                                                title: 'Out Of Stock',
                                                desc:
                                                'Out Of Stock Quantity ',
                                                btnCancelOnPress: () {},
                                                btnOkOnPress: () {},
                                              )
                                                ..show();
                                            }else{
                                              progressDialog.show();
                                              incrementItem(productId: snapshot.data
                                                  .items[index].courseId);
                                            }

                                          },
                                        ),
                                      ],
                                    ),
                                  )
                                      : SizedBox()

                                ],
                              ),
                            ),
                            Container(
                              width:
                              (MediaQuery
                                  .of(context)
                                  .size
                                  .width - 37) / 1.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(left: 12.0),
                                        width: 150,
                                        child: Text(
                                          snapshot.data.items[index].title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            letterSpacing: 0.27,
                                            color:
                                            DesignCourseAppTheme.darkerText,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        splashColor: Colors.grey,
                                        onTap: () {
                                          AwesomeDialog(
                                            context: context,
                                            dialogType: DialogType.WARNING,
                                            animType: AnimType.BOTTOMSLIDE,
                                            title: 'Remove Item',
                                            desc:
                                            'Do you want remove item from cart',
                                            btnCancelOnPress: () {},
                                            btnOkOnPress: () {
                                              progressDialog.show();
                                              _removeToCart(snapshot
                                                  .data.items[index].courseId);
                                            },
                                          )
                                            ..show();
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(20),
                                          width: 30,
                                          height: 30,
                                          child: Center(
                                            child: Image.asset(
                                              UtilsData.kDeleteCart,
                                            ),
                                          ),
                                        ),
                                      ),
//                                  IconButton(
//                                    icon: Icon(
//                                      Icons.close,
//                                      size: 26,
//                                    ),
//                                    onPressed: () {
//                                      AwesomeDialog(
//                                        context: context,
//                                        dialogType: DialogType.WARNING,
//                                        animType: AnimType.BOTTOMSLIDE,
//                                        title: 'Remove Item',
//                                        desc: 'Do you want remove item from cart',
//                                        btnCancelOnPress: () {},
//                                        btnOkOnPress: () {},
//                                      )
//                                        ..show();
//                                    },
//                                  ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(12.0),
//                                        child: Text(
//                                          '\₹' +
//                                              snapshot
//                                                  .data.items[index].salePrice,
//                                          style: TextStyle(
//                                              fontSize: 16,
//                                              fontWeight: FontWeight.bold),
//                                        ),
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                '\₹${snapshot.data.items[index]
                                                    .mrpPrice}',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w200,
                                                  fontSize: 16,
                                                  letterSpacing: 0.27,
                                                  color:
                                                  DesignCourseAppTheme.grey,
                                                  decoration:
                                                  TextDecoration.lineThrough,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                '\₹${snapshot.data.items[index]
                                                    .salePrice}(${different
                                                    .toStringAsFixed(2)}%)',
                                                textAlign: TextAlign.left,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  letterSpacing: 0.27,
//                                                color: DesignCourseAppTheme
//                                                    .nearlyBlue,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: true,
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
//                                              "Show Details",
                                              ' ',
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  decoration:
                                                  TextDecoration.underline),
                                            ),
                                          ),
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
                  onPressed: () =>
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NavigationHomeScreen()))),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  UtilsData.kCartTitleName,
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

  Future<CartListModel> _getCartData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kGetCartItemMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
    var responseData = jsonDecode(response.body);
    print('response of cart $responseData');
    print('response of cart ${response.statusCode}');
    if (response.statusCode == 200) {
      try {
        setState(() {
          _subTotal = double.parse(responseData['mrp_total'].toString());
          // _subTotal=_subTotal;
          // double different = double.parse(responseData['mrp_total']) - double.parse(responseData['sale_total']);
          // _discount = different * (100.00 /
          //     double.parse(responseData['mrp_total']).toDouble());
          double _disc = responseData['mrp_total'].toDouble()-responseData['sale_total'].toDouble();
          print('disc $_disc');
          // _discount=_disc*100/responseData['mrp_total'].toDouble();
          _discount=_disc;
          print('subtotal $_subTotal');
          amount = responseData['sale_total']+.00;
          amount=amount+_charges;
          print('amount $amount');
          isCartDisplay = true;
          name = responseData['items'][0]['title'];
          typeOfCart = responseData['product'];
          print('name $name');
        });
        _hash = responseData['hash'];
        _txnId = responseData['txn_id'];
      } catch (exception) {
        setState(() {
          _subTotal = 0;
        });

        print('exception $exception');
      }

      return CartListModel.fromJson(jsonDecode(response.body));
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
      setState(() {
        _subTotal = 0;
      });
      return CartListModel.fromJson(jsonDecode(response.body));
    }
  }

  InputDecoration textDecoration({String filedName}) {
    return InputDecoration(
        labelText: filedName,
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ));
  }


  Future<void> _removeToCart(int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kRemoveCartItemMethod + id.toString(),
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
    print('response from cart remove ${jsonDecode(response.body)}');
    Navigator.of(context).pop();
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Remove Item',
        desc: responseData[UtilsData.kResponseErrorMessage],
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          _getCartData();
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
      throw Exception('Failed to load course list');
    }
  }

//    print('hash data $hashData');
//
//
//    Digest digest = sha512.convert(utf8.encode(hashData));
//    print('digest :$digest');

  Future<void> _checkOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    print('mobile number $mobileNo');
    print('username $username');
    print('type of cart $typeOfCart');

    try {
      FlutterPayumoneyPlugin.payUMoneyPayment(
        environmentMode: 1,
        email: preferences.getString(UtilsData.kPrefEmailKey),
        amount: amount.toString(),
//        amount: '1',
        formName: 'Virtual Abhyas Course',
        mobile: typeOfCart == true ? _controllerMobile.text : mobileNo ??
            '8980094009',
        UserName: username,
        gNumber: "",
      ).then((value) {
        print('PAYMENT ID: $value');
        Future.delayed(Duration(seconds: 1), () {
          if (value == null) {
            print('value is null $value');
            AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.BOTTOMSLIDE,
              title: 'Transaction Failed!',
              desc: 'Transaction was not done',
              btnCancelOnPress: () {},
              btnOkOnPress: () {},
            )..show();
          } else {
            print('value is not null  $value');
            progressDialog.show();
            placeOrder(paymentId: value);
          }
        });
      });
    } catch (exception) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: 'Error!',
        desc: exception.toString(),
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      )
        ..show();
      print('exception payment $exception');
    }
  }

  Future<void> placeOrder({String paymentId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Map reqData = {};
    if (typeOfCart == true) {
      reqData = {
        'txn_id': paymentId,
        'address': _controllerAddress.text,
        'city': _controllerCity.text,
        'pincode': _selectedPinCode,
        'shipping_charges':_charges.toString(),

      };
    } else {
      reqData = {
        'txn_id': paymentId,
      };
    }
    print('reqdata $reqData');

    final http.Response response =
    await http.post(UtilsData.kBaseUrl + UtilsData.kPlaceOrderMethod,
        headers: <String, String>{
          UtilsData.kHeaderType: UtilsData.kHeaderValue,
          UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
        },
        body: jsonEncode(reqData));

    Navigator.of(context).pop();

    var _responseData = jsonDecode(response.body);
    print('response from service $_responseData');
    print('response code${response.statusCode}');

    if (response.statusCode == 200) {
      print('result ok');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: UtilsData.kSuccess,
        desc: _responseData[UtilsData.kResponseErrorMessage],
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MyOrder()));
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
        dialogType: DialogType.ERROR,
        animType: AnimType.BOTTOMSLIDE,
        title: UtilsData.kError,
        desc: _responseData[UtilsData.kResponseErrorMessage],
        btnCancelOnPress: () {},
        btnOkOnPress: () {},
      )
        ..show();
//      UtilsData.kErrorDialog(
//          context: context,
//          errorMsg: _responseData[UtilsData.kResponseErrorMessage]);
    }
  }

  Future<void> deIncrementItem({int productId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.post(
        UtilsData.kBaseUrl + UtilsData.kDeIncrementMethod,
        headers: <String, String>{
          UtilsData.kHeaderType: UtilsData.kHeaderValue,
          UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
        },
        body: jsonEncode(<String, int>{
          'product_id': productId,
        })
    );
    print('response from increment ${jsonDecode(response.body)}');
    Navigator.of(context).pop();
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _getCartData();
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
  }


  Future<void> incrementItem({int productId}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.post(
        UtilsData.kBaseUrl + UtilsData.kIncrementMethod,
        headers: <String, String>{
          UtilsData.kHeaderType: UtilsData.kHeaderValue,
          UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
        },
        body: jsonEncode(<String, int>{
          'product_id': productId,
        })
    );
    print('response from increment ${jsonDecode(response.body)}');
    Navigator.of(context).pop();
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      _getCartData();
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
  }

  Future<void> getCharges() async{

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kGetChargesMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
    print('response from charges and pincode  ${jsonDecode(response.body)}');
    // Navigator.of(context).pop();
    var responseData = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _charges=double.tryParse(responseData['shipping_charges']);
        print('without charges amount $amount');
      });

      print('charges $_charges and amount $amount');
      _pinCodeList=responseData['pincodes'].cast<String>();
      for(int i=0; i < _pinCodeList.length; i++) {
        items.add(new DropdownMenuItem(
          child: new Text(
            _pinCodeList[i],
          ),
          value: _pinCodeList[i],
        )
        );
      }
      print('pincode list $_pinCodeList');
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

  }

//  Future<void> _checkOut() async {
//    dynamic result;
//
//    Map payu_info={
//      'environment':"production",
//      'amount':'1.00',
//      'txnid':'12369874',
//      'phone':'9558915152',
//      'merchant_key':'nOOPiuYR',
//      'merchant_id':'6536519',
//      'productinfo':'Course1',
//      'firstname':'Bharat Sindhav',
//      'email':'sindhavbharat2195@gmail.com',
//      'surl':'https://www.payumoney.com/mobileapp/payumoney/success.php',
//      'furl':'https://www.payumoney.com/mobileapp/payumoney/failure.php',
//      'hash':'e5d32188787f7c2824f29fa5f4dc8d55dc2e4591c9e46fa38927571e9d8db7ef5688020643df78fdc108300f495001611c5b1d69a3c1570e4b3c1260c8adfdda',
//      'udf1':'',
//      'udf2':'',
//      'udf3':'',
//      'udf4':'',
//      'udf5':'',
//      'udf6':'',
//      'udf7':'',
//      'udf8':'',
//      'udf9':'',
//      'udf10':'',
//
//
//
//
//    };
//    try {
//      result = await PayumoneyPlugin.openPayUMoney(payu_info);
//      print("plaform result $result");
//      if (result != null) {
//        Map<String, dynamic> paymentResponse = new Map<String, dynamic>.from(
//            Platform.isAndroid ? json.decode(result) : result);
//        String status = paymentResponse['result']['status'];
//        print(status);
//        if (status == 'success') {
//          print("completed");
//        } else {
//          print("Failed");
//        }
//
//      } else {}
//    } on PlatformException catch (e) {
//      print(e.toString());
//    }
//
//  }
}
