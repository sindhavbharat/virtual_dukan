import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:virtual_dukan/screens/login.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController iconAnimationController;
  final DrawerIndex screenIndex;
  final Function(DrawerIndex) callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  String _greetingMsg;
  DateFormat _dateFormat = DateFormat('HH');
  List<DrawerList> drawerList;
  ProgressDialog progressDialog;
  SharedPreferences _sharedPreferences;
  String _name = '';
  String _profile = '';
  String _email = '';

  Future<Null> getSharedPrefs() async {
    try {
      _sharedPreferences = await SharedPreferences.getInstance();
      setState(() {
        _name = _sharedPreferences.getString(UtilsData.kPrefNameKey);
        _profile = _sharedPreferences.getString(UtilsData.kPrefProfileKey);
        _email = _sharedPreferences.getString(UtilsData.kPrefEmailKey);
        print('name $_profile');
      });
    } catch (exception) {
      print('shared preference exception $exception');
    }
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    int currentHour = int.parse(_dateFormat.format(now));
    print('current hour $currentHour');
    if (currentHour <= 12) {
      _greetingMsg = 'Good Morning';
    } else if ((currentHour > 12) && (currentHour <= 16)) {
      _greetingMsg = 'Good Afternoon';
    } else if ((currentHour > 16) && (currentHour <= 20)) {
      _greetingMsg = 'Good Evening';
    } else {
      _greetingMsg = 'Good Night';
    }

    print('greeting  $_greetingMsg');
    getSharedPrefs();

    setdDrawerListArray();
    super.initState();
  }

  void setdDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: 'Help',
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: 'FeedBack',
        icon: Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: 'Invite Friend',
        icon: Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.Rate,
        labelName: 'Rate the app',
        icon: Icon(Icons.share),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'About Us',
        icon: Icon(Icons.info),
      ),
      DrawerList(
        index: DrawerIndex.Privacy,
        labelName: 'Privacy Policy',
        icon: Icon(Icons.screen_lock_portrait),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.iconAnimationController,
                    builder: (BuildContext context, Widget child) {
                      return ScaleTransition(
                        scale: AlwaysStoppedAnimation<double>(
                            1.0 - (widget.iconAnimationController.value) * 0.2),
                        child: RotationTransition(
                          turns: AlwaysStoppedAnimation<double>(Tween<double>(
                              begin: 0.0, end: 24.0)
                              .animate(CurvedAnimation(
                              parent: widget.iconAnimationController,
                              curve: Curves.fastOutSlowIn))
                              .value /
                              360),
                          child: Container(
                              height: 120,
                              width: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: AppTheme.grey.withOpacity(0.6),
                                      offset: const Offset(2.0, 4.0),
                                      blurRadius: 8),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(60.0)),
                                child: _profile == 'empty'
                                    ? Image.asset(UtilsData.kLogo)
                                    : _profile.isEmpty ? Image.asset(
                                    UtilsData.kLogo) : Image.network(_profile),
                              )
//                              child: ClipRRect(
//                                borderRadius: const BorderRadius.all(Radius.circular(60.0)),
//                                child: Image.asset(UtilsData.kImageDir+'/app_icon.png'),
//                              )
                          ),
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 4),
                    child: Text(
                      _greetingMsg + '\n' + _name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList[index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  UtilsData.kSignOut,
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.WARNING,
                    animType: AnimType.BOTTOMSLIDE,
                    title: UtilsData.kSignOut,
                    desc: UtilsData.kSignOutMsg,
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      progressDialog.setMessage(UtilsData.kLogoutLoadingMsg);
                      progressDialog.show();
                      _clearSharedPreference();
                      if (currentUser != null) {
                        googleSignIn.disconnect();
                      }
                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => Login()));
//                      Future.delayed(Duration(seconds: 1),(){
//                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Login()));
//                      });
                      });
                    },
                  )..show();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                    width: 24,
                    height: 24,
                    child: Image.asset(listData.imageName,
                        color: widget.screenIndex == listData.index
                            ? Colors.blue
                            : AppTheme.nearlyBlack),
                  )
                      : Icon(listData.icon.icon,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
              animation: widget.iconAnimationController,
              builder: (BuildContext context, Widget child) {
                return Transform(
                  transform: Matrix4.translationValues(
                      (MediaQuery
                          .of(context)
                          .size
                          .width * 0.75 - 64) *
                          (1.0 -
                              widget.iconAnimationController.value -
                              1.0),
                      0.0,
                      0.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      width:
                      MediaQuery
                          .of(context)
                          .size
                          .width * 0.75 - 64,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.2),
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(28),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex(indexScreen);
  }

  void _clearSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    print('after signout token${preferences.getString((UtilsData.kToken))}');
  }
}

enum DrawerIndex {
  HOME,
  FeedBack,
  Help,
  Share,
  About,
  Rate,
  Privacy,
  Invite,
  Testing,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex index;
}
