import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UtilsData.kWhite,
      body: ResetPassword(),
    );
  }
}

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool _isOtpShow;
  ProgressDialog _progressDialog;
  TextEditingController _controllerEmail;
  TextEditingController _controllerPassword;
  FocusNode _focusNodePassword;
  FocusNode _focusNodeConfirmPassword;
  bool _isPasswordVisible;
  bool _isConfirmPasswordVisible;

  @override
  void initState() {
    super.initState();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
    _isOtpShow = false;
    _isPasswordVisible = true;
    _isConfirmPasswordVisible = true;
    _focusNodePassword = FocusNode();
    _focusNodeConfirmPassword = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          UtilsData.kAppBar(context: context, title: UtilsData.kForPassword),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _controllerEmail,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.text,
                          decoration: UtilsData.kTextDecoration(
                              filedName: UtilsData.kEmail),
                          validator: (value) {
                            if (value.isEmpty)
                              return UtilsData.kValidateEmail;
                            else if (!value.contains('@'))
                              return UtilsData.kValidateEmailAddress;
                            else
                              return null;
                          },
                        ),
                      ),
                      Visibility(
                        visible: _isOtpShow,
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                focusNode: _focusNodePassword,
                                controller: _controllerPassword,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
                                obscureText: _isPasswordVisible,
                                decoration: UtilsData.kTextDecoration(
                                        filedName: UtilsData.kNewPassword)
                                    .copyWith(
                                  suffixIcon: IconButton(
                                    icon: _isPasswordVisible
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                    onPressed: () {
                                      setState(
                                        () {
                                          _isPasswordVisible =
                                              !_isPasswordVisible;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty)
                                    return UtilsData.kValidatePassword;
                                  else
                                    return null;
                                },
                                onFieldSubmitted: (_) {
                                  UtilsData.focusChange(
                                      context: context,
                                      currentFocus: _focusNodePassword,
                                      nextFocus: _focusNodeConfirmPassword);
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                focusNode: _focusNodeConfirmPassword,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.text,
                                obscureText: _isConfirmPasswordVisible,
                                decoration: UtilsData.kTextDecoration(
                                        filedName: UtilsData.kConfirmPassword)
                                    .copyWith(
                                  suffixIcon: IconButton(
                                    icon: _isConfirmPasswordVisible
                                        ? Icon(Icons.visibility)
                                        : Icon(Icons.visibility_off),
                                    onPressed: () {
                                      setState(
                                        () {
                                          _isConfirmPasswordVisible =
                                              !_isConfirmPasswordVisible;
                                        },
                                      );
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return UtilsData.kValidateConfirmPassword;
                                  } else if (value !=
                                      _controllerPassword.text) {
                                    return UtilsData.kValidSamePassword;
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(UtilsData.kEnterOtp),
                            PinEntryTextField(
                              onSubmit: (String otp) {
                                print('on submit call$otp');
                                setState(
                                  () {
                                    try {
                                      if (_formKey.currentState.validate()) {
                                        _formKey.currentState.save();
                                        print('on submit call$otp');
                                        _progressDialog.setMessage(
                                            UtilsData.kVerifyingOtp);
                                        _progressDialog.show();
                                        _finalRequest(
                                            otp: otp,
                                            password: _controllerPassword.text);
                                      }
                                    } catch (exception) {
                                      print('exception $exception');
                                    }
                                  },
                                );
                              },
                              isTextObscure: true,
                              fields: 6,
                              showFieldAsBox: false,
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: _isOtpShow ? false : true,
                        child: InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            width: ScreenUtil.getInstance().setWidth(330),
                            height: ScreenUtil.getInstance().setHeight(100),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF17ead9),
                                  Color(0xFF6078ea)
                                ]),
                                borderRadius: BorderRadius.circular(6.0),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0xFF6078ea).withOpacity(.3),
                                      offset: Offset(0.0, 8.0),
                                      blurRadius: 8.0)
                                ]),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    _progressDialog
                                        .setMessage(UtilsData.kLoadingMsg);
                                    _progressDialog.show();
                                    _forgotPassword(context: context);
                                  }
                                },
                                child: Center(
                                  child: Text(UtilsData.kRegister,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily:
                                              UtilsData.kPoppinsBoldFonts,
                                          fontSize: 18,
                                          letterSpacing: 1.0)),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _finalRequest({String otp, String password}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('final called');
    final http.Response response = await http.post(
      UtilsData.kBaseUrl + UtilsData.kResetPasswordMethod,
      headers: <String, String>{UtilsData.kHeaderType: UtilsData.kHeaderValue},
      body: jsonEncode(
        <String, String>{
          'email': _controllerEmail.text,
          'otp': otp,
          'password': password,
        },
      ),
    );

    Navigator.of(context).pop();
    var _responseData = jsonDecode(response.body);
    print('response otp $_responseData');
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
          Navigator.of(context, rootNavigator: true).pop();
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
      UtilsData.kErrorDialog(
          context: context,
          errorMsg: _responseData[UtilsData.kResponseErrorMessage]);
    }
  }

  Future<void> _forgotPassword({BuildContext context}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
        UtilsData.kBaseUrl + UtilsData.kForgotPasswordMethod,
        headers: <String, String>{
          UtilsData.kHeaderType: UtilsData.kHeaderValue
        },
        body: jsonEncode(<String, String>{
          'email': _controllerEmail.text,
        }));

    Navigator.of(context).pop();

    var _responseData = jsonDecode(response.body);
    print('response from service $_responseData');
    print('response code${response.statusCode}');

    if (response.statusCode == 200) {
      UtilsData.kSuccessDialog(
          context: context,
          successMsg: _responseData[UtilsData.kResponseErrorMessage]);
      setState(() {
        _isOtpShow = !_isOtpShow;
      });
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
      UtilsData.kErrorDialog(
          context: context,
          errorMsg: _responseData[UtilsData.kResponseErrorMessage]);
    }
  }
}
