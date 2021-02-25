import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:division/division.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_dukan/design_course/category_list_view.dart';
import 'package:virtual_dukan/design_course/design_course_app_theme.dart';
import 'package:virtual_dukan/design_course/models/advertisments_list.dart';
import 'package:virtual_dukan/design_course/popular_course_list_view.dart';
import 'package:virtual_dukan/screens/change_password.dart';
import 'package:virtual_dukan/screens/common_list_view.dart';
import 'package:virtual_dukan/screens/english_medium_list_view.dart';
import 'package:virtual_dukan/screens/filters_screen.dart';
import 'package:virtual_dukan/screens/gujarati_medium_list_view.dart';
import 'package:virtual_dukan/screens/join_screen.dart';
import 'package:virtual_dukan/screens/meeting_list.dart';
import 'package:virtual_dukan/screens/my_order.dart';
import 'package:virtual_dukan/screens/search.dart';
import 'package:virtual_dukan/screens/start_meeting_screen.dart';
import 'package:virtual_dukan/screens/gseb_list_view.dart';
import 'package:virtual_dukan/screens/update_profile.dart';
import 'package:virtual_dukan/screens/video_lectures_list_view.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:virtual_dukan/utils_data/fintness_app_theme.dart';
import 'package:virtual_dukan/utils_data/tabIcon_data.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_items.dart';
import 'cbse_list_view.dart';
import 'institutes_list_view.dart';
import 'meeting_widget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
//  List<HomeList> homeList = HomeList.homeList;
  CategoryType categoryType = CategoryType.ui;
  AnimationController animationController;
  bool multiple = true;
  GlobalKey bottomNavigationKey = GlobalKey();
  int currentPage;
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;
  static List<String> imgList = [
    UtilsData.kAdv1,
    UtilsData.kAdv2,
    UtilsData.kAdv3,
  ];
  bool isListViewVisible;
  Widget tabBody = Container(
    color: FintnessAppTheme.background,
  );

  SharedPreferences sharedPreferences;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) => sharedPreferences=value);
    currentPage = 0;
    isListViewVisible = true;
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;

    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
//    tabBody = MyDiaryScreen(animationController: animationController);

    getAdvertisementsList();
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    return (AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          animType: AnimType.BOTTOMSLIDE,
          title: 'Are you sure?',
          desc: 'Do you want exit an App',
          btnCancelOnPress: () {},
          btnOkOnPress: () {
            exit(0);
          },
        )..show()) ??
        false;
  }

  List<Widget> imageSliders = imgList
      .map((item) => Container(
            child: Container(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      5.0,
                    ),
                  ),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        item,
                        fit: BoxFit.fill,
                        width: 1000.0,
                        height: 300,
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(0, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
//                          padding: EdgeInsets.symmetric(
//                              vertical: 5.0, horizontal: 10.0),
//                  child: Text(
//                    'No. ${imgList.indexOf(item)} image',
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 20.0,
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
                        ),
                      ),
                    ],
                  )),
            ),
          ))
      .toList();

  @override
  Widget build(BuildContext context) {
    double verticalMargin = 0;
    return WillPopScope(
      onWillPop: () {
        return _onWillPop();
      },
      child: RefreshIndicator(
        onRefresh: _getRefreshData,
        child: Scaffold(
          backgroundColor: AppTheme.white,
          bottomNavigationBar: FancyBottomNavigation(
            inactiveIconColor: Color(0xff00008b),
            circleColor: Color(0xff00008b),
            tabs: [
              TabData(
                iconData: Icons.home,
                title: "Home",
              ),
              TabData(
                iconData: Icons.shopping_cart,
                title: "Basket",
              ),
              TabData(
                iconData: Icons.account_circle,
                title: "Profile",
              ),
            ],
            initialSelection: currentPage,
            key: bottomNavigationKey,
            onTabChangedListener: (position) {
              setState(() {
                currentPage = position;
                print('current page $currentPage');
                if (currentPage == 1) {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CartItems()));
                } else if (currentPage == 2) {
                  setState(() {
                    isListViewVisible = !isListViewVisible;
                  });
                } else {
                  setState(() {
                    isListViewVisible = !isListViewVisible;
                  });
                }
              });
            },
          ),
          body: FutureBuilder<bool>(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                return Padding(
                  padding:
                      EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      appBar(),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Stack(
                            children: <Widget>[
                              tabBody,
                              Visibility(
                                visible: isListViewVisible,
                                child: _getAllView(),
                              ),
                              Visibility(
                                visible: !isListViewVisible,
                                child: SingleChildScrollView(
                                  child: Division(
                                    style: StyleClass()
                                      ..margin(
                                          vertical: verticalMargin,
                                          horizontal: 20)
                                      ..minHeight(
                                          MediaQuery.of(context).size.height -
                                              (2 * verticalMargin)),
                                    child: Column(
                                      children: <Widget>[
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 16.0),
                                          child: Settings(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              bottomBar(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Future<void> _getRefreshData() async {
    setState(() {
      this._getAllView();
    });
  }

  ListView _getAllView() {
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<AdvertisementsModel>(
            future: getAdvertisementsList(),
            builder: (BuildContext context,
                AsyncSnapshot<AdvertisementsModel> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              } else {
                return CarouselSlider.builder(
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  itemCount: snapshot.data.sliderAdvertisements.length,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return Container(
                      child: Container(
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            child: Stack(
                              children: <Widget>[
                                Image.network(
                                  snapshot.data.sliderAdvertisements[itemIndex]
                                      .fileName,
                                  fit: BoxFit.fill,
                                  width: 1000.0,
                                  height: 300,
                                ),
                                Positioned(
                                  bottom: 0.0,
                                  left: 0.0,
                                  right: 0.0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(0, 0, 0, 0),
                                          Color.fromARGB(0, 0, 0, 0)
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                    ),
//                          padding: EdgeInsets.symmetric(
//                              vertical: 5.0, horizontal: 10.0),
//                  child: Text(
//                    'No. ${imgList.indexOf(item)} image',
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 20.0,
//                      fontWeight: FontWeight.bold,
//                    ),
//                  ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
        SizedBox(
          height: 5,
        ),
        getInstitutedUI(),
        getStationaryUI(),
        getCategoryUI(),
        getVideoLectureUI(),
        getPopularCourseUI(),
        getGujaratiMediumUI(),
      ],
//                              child: Container(
//                                height: MediaQuery.of(context).size.height,
//                                child: Column(
//                                  children: <Widget>[
////                          getSearchBarUI(),
//                                    getInstitutedUI(),
//                                    getCategoryUI(),
//                                    getVideoLectureUI(),
//                                    getPopularCourseUI(),
//
////                                  Flexible(
////                                    child: getPopularCourseUI(),
////                                  ),
//                                  ],
//                                ),
//                              ),
    );
  }

  Widget getStationaryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            /*UtilsData.kStationary*/'CBSE Books',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
              fontFamily: UtilsData.kProximaFontName,
            ),
          ),
        ),
        CBSEListView(),
      ],
    );
  }

  Widget getGujaratiMediumUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Gujarati Medium Books',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
              fontFamily: UtilsData.kProximaFontName,
            ),
          ),
        ),
//        const SizedBox(
//          height: 16,
//        ),
//        Padding(
//          padding: const EdgeInsets.only(left: 16, right: 16),
//          child: Row(
//            children: <Widget>[
//              getButtonUI(CategoryType.ui, categoryType == CategoryType.ui),
//              const SizedBox(
//                width: 16,
//              ),
//              getButtonUI(
//                  CategoryType.coding, categoryType == CategoryType.coding),
//              const SizedBox(
//                width: 16,
//              ),
//              getButtonUI(
//                  CategoryType.basic, categoryType == CategoryType.basic),
//            ],
//          ),
//        ),
//        const SizedBox(
//          height: 5,
//        ),
        GujaratiMediumListView(),
      ],
    );
  }


  Widget getPopularCourseUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'English Medium Books',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
              fontFamily: UtilsData.kProximaFontName,
            ),
          ),
        ),
//        const SizedBox(
//          height: 16,
//        ),
//        Padding(
//          padding: const EdgeInsets.only(left: 16, right: 16),
//          child: Row(
//            children: <Widget>[
//              getButtonUI(CategoryType.ui, categoryType == CategoryType.ui),
//              const SizedBox(
//                width: 16,
//              ),
//              getButtonUI(
//                  CategoryType.coding, categoryType == CategoryType.coding),
//              const SizedBox(
//                width: 16,
//              ),
//              getButtonUI(
//                  CategoryType.basic, categoryType == CategoryType.basic),
//            ],
//          ),
//        ),
//        const SizedBox(
//          height: 5,
//        ),
        EnglishMediumListView(),
      ],
    );
  }

  void moveTo() {
//    Navigator.push<dynamic>(
//      context,
//      MaterialPageRoute<dynamic>(
//        builder: (BuildContext context) => CourseInfoScreen(),
//      ),
//    );
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
//        BottomBarView(
//          tabIconsList: tabIconsList,
//          addClick: () {},
//          changeIndex: (int index) {
//            if (index == 0 || index == 2) {
//              animationController.reverse().then<dynamic>((data) {
//                if (!mounted) {
//                  return;
//                }
////                setState(() {
////                  tabBody =
//////                      MyDiaryScreen(animationController: animationController);
////                });
//              });
//            } else if (index == 1 || index == 3) {
//              animationController.reverse().then<dynamic>((data) {
//                if (!mounted) {
//                  return;
//                }
////                setState(() {
////                  tabBody =
//////                      TrainingScreen(animationController: animationController);
////                });
//              });
//            }
//          },
//        ),
      ],
    );
  }

  Widget getCategoryUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 16.0, left: 18, right: 16),
          child: Text(
            'GSEB Books',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
              fontFamily: UtilsData.kProximaFontName,
            ),
          ),
        ),
//        const SizedBox(
//          height: 16,
//        ),
//        Padding(
//          padding: const EdgeInsets.only(left: 16, right: 16),
//          child: Row(
//            children: <Widget>[
//              getButtonUI(CategoryType.ui, categoryType == CategoryType.ui),
//              const SizedBox(
//                width: 16,
//              ),
//              getButtonUI(
//                  CategoryType.coding, categoryType == CategoryType.coding),
//              const SizedBox(
//                width: 16,
//              ),
//              getButtonUI(
//                  CategoryType.basic, categoryType == CategoryType.basic),
//            ],
//          ),
//        ),
//        const SizedBox(
//          height: 5,
//        ),
          GSEBListView(),
      ],
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.ui == categoryTypeData) {
      txt = 'Account';
    } else if (CategoryType.coding == categoryTypeData) {
      txt = 'Math';
    } else if (CategoryType.basic == categoryTypeData) {
      txt = 'BA';
    }
    return Expanded(
      child: Container(
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
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
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
      ),
    );
  }

  Widget getInstitutedUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Publishers',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.darkerText,
                  fontFamily: UtilsData.kProximaFontName,
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => MeetingList()));
              //   },
              //   child: Image.asset(
              //     UtilsData.kImageLiveClass,
              //     width: 200,
              //     height: 80,
              //   ),
              // ),
            ],
          ),
        ),
        InstitutesListView(),
      ],
    );
  }

  Widget appBar() {
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
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  'Shop for ${sharedPreferences.getString(UtilsData.kPrefNameKey)}',
                  style: TextStyle(
                    fontSize: 20,
                    color: AppTheme.darkText,
                    fontWeight: FontWeight.w900,
                    fontFamily: UtilsData.kProximaFontName,
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
                  child: Icon(Feather.getIconData('search'),
                      color: Colors.black.withOpacity(0.6)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FiltersScreen()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getVideoLectureUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Common Useful Stationary',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
              fontFamily: UtilsData.kProximaFontName,
            ),
          ),
        ),
//        const SizedBox(
//          height: 16,
//        ),
//        Padding(
//          padding: const EdgeInsets.only(left: 16, right: 16),
//          child: Row(
//            children: <Widget>[
//              getButtonUI(CategoryType.ui, categoryType == CategoryType.ui),
//              const SizedBox(
//                width: 16,
//              ),
//              getButtonUI(
//                  CategoryType.coding, categoryType == CategoryType.coding),
//              const SizedBox(
//                width: 16,
//              ),
//              getButtonUI(
//                  CategoryType.basic, categoryType == CategoryType.basic),
//            ],
//          ),
//        ),
//        const SizedBox(
//          height: 5,
//        ),
        CommonListView(),
      ],
    );
  }

  Future<AdvertisementsModel> getAdvertisementsList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kAdvertisementMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
//    print('response from courslit $response');
    var data = jsonDecode(response.body);
//    var courses = data['courses'] as List;
    if (response.statusCode == 200) {
      print('preference bharat ${preferences.getString('popUp')}');
      if (preferences.getString('popUp') == 'true') {
        print('call bharat ');
        preferences.setString('popUp', 'false');
        showDialog(
          context: context,
          barrierDismissible: true,
          // ignore: deprecated_member_use
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(16.0))),
            child: Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    image: DecorationImage(
                      image: NetworkImage(
                          data['popup_advertisement']['file_name']),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Visibility(
                  visible: false,
                  child: Positioned(
                    right: 10,
                    child: IconButton(
                      icon: Icon(
                        Icons.cancel,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      } else {
        print('value of popup${preferences.getString('popUp')}');
      }

      return AdvertisementsModel.fromJson(jsonDecode(response.body));
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
}

//class HomeListView extends StatelessWidget {
//  const HomeListView(
//      {Key key,
//      this.listData,
//      this.callBack,
//      this.animationController,
//      this.animation})
//      : super(key: key);
//
//  final HomeList listData;
//  final VoidCallback callBack;
//  final AnimationController animationController;
//  final Animation<dynamic> animation;
//
//  @override
//  Widget build(BuildContext context) {
//    return AnimatedBuilder(
//      animation: animationController,
//      builder: (BuildContext context, Widget child) {
//        return FadeTransition(
//          opacity: animation,
//          child: Transform(
//            transform: Matrix4.translationValues(
//                0.0, 50 * (1.0 - animation.value), 0.0),
//            child: AspectRatio(
//              aspectRatio: 1.5,
//              child: ClipRRect(
//                borderRadius: const BorderRadius.all(Radius.circular(4.0)),
//                child: Stack(
//                  alignment: AlignmentDirectional.center,
//                  children: <Widget>[
//                    Image.asset(
//                      listData.imagePath,
//                      fit: BoxFit.cover,
//                    ),
//                    Material(
//                      color: Colors.transparent,
//                      child: InkWell(
//                        splashColor: Colors.grey.withOpacity(0.2),
//                        borderRadius:
//                            const BorderRadius.all(Radius.circular(4.0)),
//                        onTap: () {
//                          callBack();
//                        },
//                      ),
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          ),
//        );
//      },
//    );
//  }
//}
enum CategoryType {
  ui,
  coding,
  basic,
}

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Division(
      style: settingsStyle,
      child: Column(
        children: <Widget>[
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyOrder()));
              },
              leading: CircleAvatar(
                  backgroundColor: Color(0xff9F6083),
                  child: Icon(
                    Feather.getIconData("briefcase"),
                    color: Colors.white,
                  )),
              title: Text(
                'Orders',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                'All your orders are listed.',
                style: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UpdateProfile()));
              },
              leading: CircleAvatar(
                  backgroundColor: Color(0xffFDB78B),
                  child: Icon(
                    Feather.getIconData("settings"),
                    color: Colors.white,
                  )),
              title: Text(
                'Account Settings',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                'edit profile',
                style: TextStyle(
                    color: Colors.black26,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ),
          ),
          // Card(
          //   color: Colors.white,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(16.0),
          //   ),
          //   child: ListTile(
          //     onTap: () async {
          //       SharedPreferences preferences =
          //       await SharedPreferences.getInstance();
          //       Navigator.push(
          //           context,
          //           // MaterialPageRoute(builder: (context) => MeetingWidget(meetingId: '83907319890',userId:preferences.getString(UtilsData.kPrefNameKey))));
          //           MaterialPageRoute(builder: (context) => MeetingList()));
          //     },
          //     leading: CircleAvatar(
          //         backgroundColor: Color(0xffFDB78B),
          //         child: Icon(
          //           Feather.getIconData("settings"),
          //           color: Colors.white,
          //         )),
          //     title: Text(
          //       'Live Class',
          //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //     ),
          //     subtitle: Text(
          //       'Live Lectures',
          //       style: TextStyle(
          //           color: Colors.black26,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 12),
          //     ),
          //   ),
          // ),
          // Card(
          //   color: Colors.white,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(16.0),
          //   ),
          //   child: ListTile(
          //     onTap: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => JoinWidget()));
          //     },
          //     leading: CircleAvatar(
          //         backgroundColor: Color(0xffFDB78B),
          //         child: Icon(
          //           Feather.getIconData("settings"),
          //           color: Colors.white,
          //         )),
          //     title: Text(
          //       'Join Screen',
          //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //     ),
          //     subtitle: Text(
          //       'edit profile',
          //       style: TextStyle(
          //           color: Colors.black26,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 12),
          //     ),
          //   ),
          // ),
          // Card(
          //   color: Colors.white,
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(16.0),
          //   ),
          //   child: ListTile(
          //     onTap: () {
          //       Navigator.push(context,
          //           MaterialPageRoute(builder: (context) => StartMeetingWidget(meetingId: '2586727230')));
          //     },
          //     leading: CircleAvatar(
          //         backgroundColor: Color(0xffFDB78B),
          //         child: Icon(
          //           Feather.getIconData("settings"),
          //           color: Colors.white,
          //         )),
          //     title: Text(
          //       'Start Meeting Screen',
          //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          //     ),
          //     subtitle: Text(
          //       'edit profile',
          //       style: TextStyle(
          //           color: Colors.black26,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 12),
          //     ),
          //   ),
          // ),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: ListTile(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ChangePassword()));
              },
              leading: CircleAvatar(
                  backgroundColor: Color(0xff57CFE2),
                  child: Icon(
                    Feather.getIconData("lock"),
                    color: Colors.white,
                  )),
              title: Text(
                'Change Password',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(''),
//              subtitle: Text('edit profile',style: TextStyle(
//                  color: Colors.black26, fontWeight: FontWeight.bold, fontSize: 12),),
            ),
          ),
//          SettingsItem(Feather.getIconData("briefcase"), '#9F6083',
//              'Orders', 'All your orders are listed.', () {
//                Navigator.push(context,
//                    MaterialPageRoute(builder: (context) => MyOrder()));
//          }),
//          InkWell(
//            splashColor: Colors.grey,
//            child: SettingsItem(Feather.getIconData("settings"), '#FDB78B',
//                'Account Settings', 'edit profile', () {
//              print('click on ');
//              Navigator.push(context,
//                  MaterialPageRoute(builder: (context) => UpdateProfile()));
//            }),
//          ),
//          SettingsItem(
//              Feather.getIconData("lock"), '#57CFE2', 'Change Password', '',
//              () {
////            Navigator.push(
////              context,
////              PageTransition(
////                type: PageTransitionType.fade,
////                child: MyOrder(),
////              ),
////            );
//          }),
//          SettingsItem(Feather.getIconData("message-circle"), '#606B7E',
//              'My Comments', 'Your comments for products', () {
//                Navigator.push(
//                  context,
//                  PageTransition(
//                    type: PageTransitionType.fade,
//                    child: Checkout(),
//                  ),
//                );
//              }),
//          SettingsItem(Feather.getIconData("bell"), '#FB7C7A', 'Notifications',
//              'Notifications in the app', () {
//                Navigator.push(
//                  context,
//                  PageTransition(
//                    type: PageTransitionType.fade,
//                    child: Checkout(),
//                  ),
//                );
//              }),
//          SettingsItem(Feather.getIconData("help-circle"), '#24ACE9', 'Help',
//              'See here for help', () {
//                Navigator.push(
//                  context,
//                  PageTransition(
//                    type: PageTransitionType.fade,
//                    child: Checkout(),
//                  ),
//                );
//              }),
        ],
      ),
    );
  }

  final StyleClass settingsStyle = StyleClass();
}

class SettingsItem extends StatefulWidget {
  final IconData icon;
  final String iconBgColor;
  final String title;
  final String description;
  final Function touchItem;

  SettingsItem(this.icon, this.iconBgColor, this.title, this.description,
      this.touchItem);

  @override
  _SettingsItemState createState() => _SettingsItemState();
}

class _SettingsItemState extends State<SettingsItem> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Division(
        style: settingsItemStyle
          ..elevation(pressed ? 0 : 50, color: Colors.grey)
          ..scale(pressed ? 0.95 : 1.0),
        gesture: GestureClass()
          ..onTap(widget.touchItem)
          ..onTapDown((details) => setState(() => pressed = true))
          ..onTapUp((details) => setState(() => pressed = false))
          ..onTapCancel(() => setState(() => pressed = false)),
        child: Row(
          children: <Widget>[
            Division(
              style: StyleClass()
                ..backgroundColor(widget.iconBgColor)
                ..add(settingsItemIconStyle),
              child: Icon(
                widget.icon,
                color: Colors.white,
                size: 20,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.title,
                  style: itemTitleTextStyle,
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  widget.description,
                  style: itemDescriptionTextStyle,
                ),
              ],
            )
          ],
        ));
  }

  final StyleClass settingsItemStyle = StyleClass()
    ..alignChild('center')
    ..height(70)
    ..margin(vertical: 10)
    ..borderRadius(all: 15)
    ..backgroundColor('#ffffff')
    ..ripple(true)
    ..animate(300, Curves.easeOut);

  final StyleClass settingsItemIconStyle = StyleClass()
    ..margin(left: 15)
    ..padding(all: 12)
    ..borderRadius(all: 30);

  final TextStyle itemTitleTextStyle =
  TextStyle(fontWeight: FontWeight.bold, fontSize: 16);

  final TextStyle itemDescriptionTextStyle = TextStyle(
      color: Colors.black26, fontWeight: FontWeight.bold, fontSize: 12);
}
