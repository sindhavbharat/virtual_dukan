import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UtilsData.kWhite,
      body: UserRegistration(),
    );
  }
}

class UserRegistration extends StatefulWidget {
  @override
  _UserRegistrationState createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final _formKey = GlobalKey<FormState>();
  File _image;
  final picker = ImagePicker();
  bool _isOtpShow;
  bool _isPasswordVisible;
  bool _isConfirmPasswordVisible;
  TextEditingController _controllerName;
  TextEditingController _controllerEmail;
  TextEditingController _controllerPassword;
  ProgressDialog _progressDialog;
  FocusNode _focusNodeName;
  FocusNode _focusNodeEmail;
  FocusNode _focusNodePassword;
  FocusNode _focusNodeConfirmPassword;

  @override
  void initState() {
    super.initState();
    _isPasswordVisible = true;
    _isConfirmPasswordVisible = true;
    _controllerName = TextEditingController();
    _controllerEmail = TextEditingController();
    _controllerPassword = TextEditingController();
    _focusNodeName = FocusNode();
    _focusNodeEmail = FocusNode();
    _focusNodePassword = FocusNode();
    _focusNodeConfirmPassword = FocusNode();
    _isOtpShow = false;
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
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
          _appBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
//                      Center(
//                        child: InkWell(
//                          onTap: () => getImage(),
//                          child: Container(
//                            height: 150,
//                            width: 150,
//                            decoration: BoxDecoration(
//                              shape: BoxShape.circle,
//                              image: _image == null
//                                  ? DecorationImage(
//                                      image: AssetImage(
//                                          '${UtilsData.kImageDir}/select_image.png'),
//                                    )
//                                  : DecorationImage(
//                                      image: FileImage(_image),
//                                      fit: BoxFit.cover),
//                              boxShadow: <BoxShadow>[
//                                BoxShadow(
//                                    color: AppTheme.grey.withOpacity(0.6),
//                                    offset: const Offset(2.0, 2.0),
//                                    blurRadius: 5),
//                              ],
//                            ),
//                          ),
//                        ),
//                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          focusNode: _focusNodeName,
                          controller: _controllerName,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration:
                              textDecoration(filedName: UtilsData.kName),
                          validator: (value) {
                            if (value.isEmpty)
                              return UtilsData.kValidateName;
                            else
                              return null;
                          },
                          onFieldSubmitted: (_) {
                            UtilsData.focusChange(
                                context: context,
                                currentFocus: _focusNodeName,
                                nextFocus: _focusNodeEmail);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          focusNode: _focusNodeEmail,
                          controller: _controllerEmail,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration:
                              textDecoration(filedName: UtilsData.kEmail),
                          validator: (value) {
                            if (value.isEmpty)
                              return UtilsData.kValidateEmail;
                            else if (!value.contains('@'))
                              return UtilsData.kValidateEmailAddress;
                            else
                              return null;
                          },
                          onFieldSubmitted: (_) {
                            UtilsData.focusChange(
                                context: context,
                                currentFocus: _focusNodeEmail,
                                nextFocus: _focusNodePassword);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          focusNode: _focusNodePassword,
                          controller: _controllerPassword,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          obscureText: _isPasswordVisible,
                          decoration:
                              textDecoration(filedName: UtilsData.kPassword)
                                  .copyWith(
                            suffixIcon: IconButton(
                              icon: _isPasswordVisible
                                  ? Icon(Icons.visibility)
                                  : Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(
                                  () {
                                    _isPasswordVisible = !_isPasswordVisible;
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
                          decoration: textDecoration(
                              filedName: UtilsData.kConfirmPassword).copyWith(
                              suffixIcon: IconButton(
                                icon: _isConfirmPasswordVisible
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(
                                        () {
                                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                    },
                                  );
                                },
                              ),
                          ),
                          validator: (value) {
                            if (value.isEmpty)
                              return UtilsData.kValidateConfirmPassword;
                            else if (value != _controllerPassword.text)
                              return UtilsData.kValidSamePassword;
                            else
                              return null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Visibility(
                        visible: _isOtpShow,
                        child: Column(
                          children: <Widget>[
                            Text(UtilsData.kEnterOtp),
                            PinEntryTextField(
                              onSubmit: (String otp) {
                                _progressDialog
                                    .setMessage(UtilsData.kVerifyingOtp);
                                _progressDialog.show();
                                _finalRequest(otp: otp);
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
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    _progressDialog
                                        .setMessage(UtilsData.kLoadingMsg);
                                    _progressDialog.show();
                                    _registrationProcess(context: context);
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

  Future<void> _registrationProcess({BuildContext context}) async {
    final http.Response response = await http.post(
        UtilsData.kBaseUrl + UtilsData.kRegisterMethod,
        headers: <String, String>{
          UtilsData.kHeaderType: UtilsData.kHeaderValue
        },
        body: jsonEncode(<String, String>{
          'name': _controllerName.text,
          'email': _controllerEmail.text,
          'password': _controllerName.text,
        }));

    Navigator.of(context).pop();

    var _responseData = jsonDecode(response.body);
    print('response from service $_responseData');
    print('response code${response.statusCode}');

    if (response.statusCode == 200) {
      print('result ok');
      UtilsData.kSuccessDialog(
          context: context, successMsg: UtilsData.kOtpSentMsg);

      setState(() {
        _isOtpShow = !_isOtpShow;
      });
    } else {
      UtilsData.kErrorDialog(
          context: context,
          errorMsg: _responseData[UtilsData.kResponseErrorMessage]);
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
                    Icons.arrow_back,
                    color: AppTheme.darkText,
                  ),
                  onPressed: () => Navigator.of(context).pop()),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  UtilsData.kUserRegistration,
                  style: TextStyle(
                    fontSize: 22,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w700,
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

  Future<void> _finalRequest({String otp}) async {
    final http.Response response = await http.post(
        UtilsData.kBaseUrl + UtilsData.kRegisterOtpConfirmationMethod,
        headers: <String, String>{
          UtilsData.kHeaderType: UtilsData.kHeaderValue
        },
        body: jsonEncode(<String, String>{
          'email': _controllerEmail.text,
          'otp': otp,
        }));

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
        desc: UtilsData.kSuccessRegistration,
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          Navigator.of(context,rootNavigator: true).pop();
        },
      )..show();
    } else {
      UtilsData.kErrorDialog(
          context: context,
          errorMsg: _responseData[UtilsData.kResponseErrorMessage]);
    }
  }
}
