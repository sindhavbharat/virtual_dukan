import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_dukan/screens/forgot_password.dart';
import 'package:virtual_dukan/screens/register.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:virtual_dukan/widgets/social_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../customIcons.dart';
import 'navigation_home_screen.dart';

GoogleSignIn googleSignIn = GoogleSignIn(scopes: [
  'profile',
  'email',
]);

GoogleSignInAccount currentUser;
final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
Map userProfile;
bool _isLoggedIn = false;
final facebookLogin = FacebookLogin();

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return LoginScreen();
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ProgressDialog progressDialog;
  bool _isPasswordVisibility;
  FocusNode _username;
  FocusNode _password;
  bool _isSelected = false;
  bool isLoggedIn;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _userNameValue;
  TextEditingController _passwordValue;
  VoidCallback onBackPressed;
  SharedPreferences preferences;

  void initState() {
    // TODO: implement initState
    super.initState();
    _userNameValue = TextEditingController();
    _passwordValue = TextEditingController();
    _isPasswordVisibility = true;
    isLoggedIn = false;
    _username = FocusNode();
    _password = FocusNode();
    SharedPreferences.getInstance().then((SharedPreferences pref) {
      preferences = pref;
    });
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account != null) {
        progressDialog.show();
        setState(() {
          currentUser = account;
          print('current user information $currentUser');
          print('email ${currentUser.email}');
          print('display name ${currentUser.displayName}');
          _socialLogin(
              context: context,
              provider: UtilsData.kSocialGoogleProvide,
              email: currentUser.email,
              name: currentUser.displayName);
        });
      }
    });
    googleSignIn.signInSilently();

    getPreferenceDetails();
  }

  void _radio() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    print('radio select $_isSelected');
    if (!_isSelected) {
      await _preferences.setString(UtilsData.kEmail, _userNameValue.text);
      print('password ${_passwordValue.text}');
      await _preferences.setString(UtilsData.kPassword, _passwordValue.text);
    }
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  Widget radioButton(bool isSelected) => Container(
        width: 16.0,
        height: 16.0,
        padding: EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2.0, color: Colors.black)),
        child: isSelected
            ? Container(
                width: double.infinity,
                height: double.infinity,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.black),
              )
            : Container(),
      );

  Widget horizontalLine() => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
          width: ScreenUtil.getInstance().setWidth(120),
          height: 1.0,
          color: Colors.black26.withOpacity(.2),
        ),
      );

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true);
    progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
    progressDialog.setMessage(UtilsData.kLoginLoadingMsg);
    return WillPopScope(
      onWillPop: () => _onBackPressed(),
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomPadding: true,
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Image.asset(
                    UtilsData.kImageOne,
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Expanded(
                    child: Image.asset(
                  UtilsData.kImageTwo,
                ))
              ],
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Align(
                        child: Image.asset(
                          UtilsData.kPlayStore,
                          width: ScreenUtil.getInstance().setWidth(110),
                          height: ScreenUtil.getInstance().setHeight(110),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(180),
                    ),
//                  FormCard(),
                    formCard(),
                    SizedBox(height: ScreenUtil.getInstance().setHeight(40)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: 12.0,
                            ),
                            GestureDetector(
                              onTap: _radio,
                              child: radioButton(_isSelected),
                            ),
                            SizedBox(
                              width: 8.0,
                            ),
                            Text(UtilsData.kRememberMe,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: UtilsData.kPoppinsMediumFonts))
                          ],
                        ),
                        InkWell(
                          child: Container(
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
                                    print(
                                        'user name ${_userNameValue.text} password is ${_passwordValue.text}');
                                    progressDialog.show();
                                    _loginRequest(context: context);
                                  }
                                },
                                child: Center(
                                  child: Text(UtilsData.kSignIn,
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
                        )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        horizontalLine(),
                        Text(UtilsData.kSocialLogin,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontFamily: UtilsData.kPoppinsMediumFonts)),
                        horizontalLine()
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(40),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SocialIcon(
                          colors: [
                            Color(0xFF102397),
                            Color(0xFF187adf),
                            Color(0xFF00eaf8),
                          ],
                          iconData: CustomIcons.facebook,
                          onPressed: () {
                            print('facebook clicked');
//                          _handleSignIn();
                            initiateFacebookLogin();
                          },
                        ),
                        SocialIcon(
                          colors: [
                            Color(0xFFff4f38),
                            Color(0xFFff355d),
                          ],
                          iconData: CustomIcons.googlePlus,
                          onPressed: () {
                            print('google login clicked');
                            _handleSignIn();
                          },
                        ),
//                      SocialIcon(
//                        colors: [
//                          Color(0xFF17ead9),
//                          Color(0xFF6078ea),
//                        ],
//                        iconData: CustomIcons.twitter,
//                        onPressed: () {},
//                      ),
//                      SocialIcon(
//                        colors: [
//                          Color(0xFF00c6fb),
//                          Color(0xFF005bea),
//                        ],
//                        iconData: CustomIcons.linkedin,
//                        onPressed: () {},
//                      )
                      ],
                    ),
                    SizedBox(
                      height: ScreenUtil.getInstance().setHeight(30),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          UtilsData.kNewUser,
                          style: TextStyle(
                              fontFamily: UtilsData.kPoppinsMediumFonts),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Register()));
                          },
                          child: Text(UtilsData.kSignUp,
                              style: TextStyle(
                                  color: Color(0xFF5d74e3),
                                  fontFamily: UtilsData.kPoppinsBoldFonts)),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _userNameValue.clear();
    _passwordValue.clear();
    super.dispose();
  }

  void initiateFacebookLogin() async {
    if (facebookLogin != null) {
      facebookLogin.logOut();
    }
    final result = await facebookLogin.logInWithReadPermissions(['email']);
    print('result of status ${result.errorMessage}');

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,picture,email&access_token=${token}');
        final profile = jsonDecode(graphResponse.body);
        print(profile);
        setState(() {
          userProfile = profile;
          print('user profile from facebook $userProfile');
          _isLoggedIn = true;
          progressDialog.show();
          _socialLogin(
              context: context,
              name: userProfile["name"],
              email: userProfile["email"],
              provider: UtilsData.kSocialFacebookProvide,
              profile: userProfile["picture"]["data"]["url"]);
        });
        break;

      case FacebookLoginStatus.cancelledByUser:
        setState(() => _isLoggedIn = false);
        break;
      case FacebookLoginStatus.error:
        setState(() => _isLoggedIn = false);
        break;
    }
  }

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      print('profile data $profileData');
    });
  }

  Widget formCard() {
    return new Container(
      width: double.infinity,
//      height: ScreenUtil.getInstance().setHeight(500),
      padding: EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
          color: UtilsData.kWhite,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
                color: UtilsData.kBlack12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: UtilsData.kBlack12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0),
          ]),
      child: Padding(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(UtilsData.kLogin,
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(45),
                      fontFamily: UtilsData.kPoppinsBoldFonts,
                      letterSpacing: .6)),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(UtilsData.kEmail,
                  style: TextStyle(
                      fontFamily: UtilsData.kPoppinsMediumFonts,
                      fontSize: ScreenUtil.getInstance().setSp(26))),
              TextFormField(
                controller: _userNameValue,
                focusNode: _username,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: UtilsData.kUserNameHint,
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0)),
                validator: (username) {
                  if (username.isEmpty) {
                    return UtilsData.kUserNameErrorMsg;
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (_) {
                  _username.unfocus();
                  FocusScope.of(context).requestFocus(_password);
                },
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(30),
              ),
              Text(
                UtilsData.kPassword,
                style: TextStyle(
                  fontFamily: UtilsData.kPoppinsMediumFonts,
                  fontSize: ScreenUtil.getInstance().setSp(26),
                ),
              ),
              TextFormField(
                controller: _passwordValue,
                focusNode: _password,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                obscureText: _isPasswordVisibility,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: _isPasswordVisibility == true
                          ? Icon(Icons.visibility)
                          : Icon(Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisibility = !_isPasswordVisibility;
                        });
                      }),
                  hintText: UtilsData.kPasswordHint,
                  hintStyle: TextStyle(color: UtilsData.kGrey, fontSize: 12.0),
                ),
                validator: (password) {
                  if (password.isEmpty) {
                    return UtilsData.kPasswordErrorMsg;
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: ScreenUtil.getInstance().setHeight(35),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  InkWell(
                    child: Text(
                      UtilsData.kForgotPassword,
                      style: TextStyle(
                          color: UtilsData.kBlue,
                          fontFamily: UtilsData.kPoppinsMediumFonts,
                          fontSize: ScreenUtil.getInstance().setSp(28)),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ForgotPassword()));
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _loginRequest({BuildContext context}) async {
    final http.Response response = await http.post(
        UtilsData.kBaseUrl + UtilsData.kLoginMethod,
        headers: <String, String>{
          UtilsData.kHeaderType: UtilsData.kHeaderValue
        },
        body: jsonEncode(<String, String>{
          'email': _userNameValue.text,
          'password': _passwordValue.text,
        }));

    Navigator.of(context).pop();

    var _responseData = jsonDecode(response.body);
    print('response from service $_responseData');

    if (response.statusCode == 200) {
      var _usersData = _responseData['user'];
      print('use data ${_usersData.toString()}');
      await preferences.setString(
          UtilsData.kPrefProfileKey, _usersData[UtilsData.kPrefProfileKey]);
      await preferences.setString(
          UtilsData.kPrefNameKey, _usersData[UtilsData.kPrefNameKey]);
      await preferences.setString(UtilsData.kPrefProvider, '0');
      await preferences.setString(
          UtilsData.kPrefEmailKey, _usersData[UtilsData.kPrefEmailKey]);
      await preferences.setString(
          UtilsData.kToken, _responseData[UtilsData.kToken]);
      await preferences.setString(
          UtilsData.kPrefMobileKey, _usersData['mobile_no']);
      print('mobile no ${preferences.getString(UtilsData.kPrefMobileKey)}');
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
    } else {
      return UtilsData.kErrorDialog(
          context: context,
          errorMsg: _responseData[UtilsData.kResponseErrorMessage]);
    }
  }

  void getPreferenceDetails() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    if (_preferences != null)
      setState(() {
        _userNameValue.text = _preferences.getString(UtilsData.kEmail) ?? '';
        _passwordValue.text = _preferences.getString(UtilsData.kPassword) ?? '';
      });
  }

  Future<void> _socialLogin({BuildContext context,
    String provider,
    String email,
    String name, profile}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final http.Response response = await http.post(
      UtilsData.kBaseUrl + UtilsData.kSocialLoginMethod,
      headers: <String, String>{UtilsData.kHeaderType: UtilsData.kHeaderValue},
      body: jsonEncode(
        <String, String>{
          'provider': provider,
          'email': email,
          'name': name,
        },
      ),
    );

    Navigator.of(context).pop();

    var _responseData = jsonDecode(response.body);
    print('response social login $_responseData');
    print('response code${response.statusCode}');

    if (response.statusCode == 200) {
      var _usersData = _responseData['user'];
      await preferences.setString(UtilsData.kPrefProfileKey,
          _usersData[UtilsData.kPrefProfileKey]);
      await preferences.setString(UtilsData.kPrefProvider, '1');
      await preferences.setString(
          UtilsData.kPrefNameKey, _usersData[UtilsData.kPrefNameKey]);
      await preferences.setString(
          UtilsData.kPrefEmailKey, _usersData[UtilsData.kPrefEmailKey]);
      await preferences.setString(
          UtilsData.kToken, _responseData[UtilsData.kToken]);
      await preferences.setString(
          UtilsData.kPrefMobileKey, _usersData['mobile_no']);
      print('mobile no ${preferences.getString(UtilsData.kPrefMobileKey)}');
      if (provider == UtilsData.kSocialGoogleProvide) {
        googleSignIn.signOut();
      } else {
        facebookLogin.logOut();
      }

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
//      AwesomeDialog(
//        context: context,
//        dialogType: DialogType.SUCCES,
//        animType: AnimType.BOTTOMSLIDE,
//        title: UtilsData.kSuccess,
//        desc: UtilsData.kSuccessRegistration,
//        btnCancelOnPress: () {
//        },
//        btnOkOnPress: () {
//          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
//        },
//      )..show();
    } else {
      UtilsData.kErrorDialog(
          context: context,
          errorMsg: _responseData[UtilsData.kResponseErrorMessage]);
    }
  }

  Future<bool> _onBackPressed() async {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.WARNING,
      animType: AnimType.BOTTOMSLIDE,
      title: UtilsData.kExit,
      desc: UtilsData.kExitMsg,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        Future.delayed(Duration(seconds: 1), () {
          exit(0);
        });
      },
    ).show() ?? false;
  }
}
