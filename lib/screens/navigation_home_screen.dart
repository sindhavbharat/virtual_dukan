
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:virtual_dukan/custom_drawer/drawer_user_controller.dart';
import 'package:virtual_dukan/custom_drawer/home_drawer.dart';
import 'package:virtual_dukan/screens/about_us.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:social_share/social_share.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';

class NavigationHomeScreen extends StatefulWidget {
  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool _updateAvailable = false;
  AppUpdateInfo _updateInfo;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = const MyHomePage();
    checkForUpdate();
    super.initState();
  }

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
      _updateInfo?.updateAvailable == true
          ? () {
              InAppUpdate.performImmediateUpdate()
                  .catchError((e) => print('error $e'));
            }
          : null;
    }).catchError((e) => print(e));
  }

  // void _showError(dynamic exception) {
  //   _scaffoldKey.currentState
  //       .showSnackBar(SnackBar(content: Text(exception.toString())));
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress)
          return false;
        else
          return true;
      },
      child: Container(
        color: AppTheme.nearlyWhite,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: AppTheme.nearlyWhite,
            body: DrawerUserController(
              screenIndex: drawerIndex,
              drawerWidth: MediaQuery.of(context).size.width * 0.75,
              onDrawerCall: (DrawerIndex drawerIndexdata) {
                changeIndex(drawerIndexdata);
                //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
              },
              screenView: screenView,
              //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
            ),
          ),
        ),
      ),
    );
  }

  Future<void> changeIndex(DrawerIndex drawerIndexdata) async {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      print('drawer index $drawerIndex');
      if (drawerIndex == DrawerIndex.HOME) {
        setState(() {
          screenView = MyHomePage();
        });
      } else if (drawerIndex == DrawerIndex.Help) {
        if (await canLaunch('http://www.virtualabhyas.com/contactduakn.php')) {
          await launch('http://www.virtualabhyas.com/contactdukan.php');
        }
//        setState(() {
////          screenView = HelpScreen();
//
//        });
      } else if (drawerIndex == DrawerIndex.FeedBack) {
        if (await canLaunch('http://www.virtualabhyas.com/contact.php')) {
          await launch('http://www.virtualabhyas.com/contact.php');
        }
      } else if (drawerIndex == DrawerIndex.Rate) {
        if (await canLaunch(
            'https://play.google.com/store/apps/details?id=com.virtualabhyas.progress_report')) {
          await launch(
              'https://play.google.com/store/apps/details?id=com.virtualabhyas.progress_report');
        }
      } else if (drawerIndex == DrawerIndex.Privacy) {
        if (await canLaunch(
            'http://www.virtualabhyas.com/privacy_policy.html')) {
          await launch('http://www.virtualabhyas.com/privacy_policy.html');
        }
      } else if (drawerIndex == DrawerIndex.Invite) {
        //without an image
        SocialShare.shareOptions(
            "https://play.google.com/store/apps/details?id=com.n2c.virtual_dukan");
      } else if (drawerIndex == DrawerIndex.About) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => AboutUs()));
//        setState(() {
//          screenView = ContactInfo();
//        });
        //do in your way......
      }
    }
  }
}
