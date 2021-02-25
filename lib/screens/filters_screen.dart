import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';
import 'package:virtual_dukan/design_course/design_course_app_theme.dart';
import 'package:virtual_dukan/design_course/models/standard_model.dart';
import 'package:virtual_dukan/screens/course_details_info.dart';
import 'package:virtual_dukan/screens/login.dart';
import 'package:virtual_dukan/screens/product_details_info.dart';
import 'package:virtual_dukan/screens/product_search.dart';
import 'package:virtual_dukan/screens/search.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:ribbon/ribbon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FiltersScreen extends StatefulWidget {
  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
//  List<PopularFilterListData> popularFilterListData =
//      PopularFilterListData.popularFList;
//  List<PopularFilterListData> accomodationListData =
//      PopularFilterListData.accomodationList;

  RangeValues _values = const RangeValues(100, 600);
  double distValue = 50.0;
  String _typeOfCourse;
  List<String> listTypeOfCourse = List();
  List<String> selectedTypeOfCourse = [];
  List<int> selectedTypeOfCourseId = [];
  List<int> listStandardId = List();
  List<String> listStandardName = List();
  List<dynamic> listStandard = List();
  List<String> selectedStandardList = [];
  List<int> selectedStandardIdList = [];


  List<int> listPublisherId = List();
  List<String> listPublisherName = List();
  List<dynamic> listPublisher = List();
  List<String> selectedPublisherName = [];
  List<int> selectedPublisherId = [];

  List<int> selectedMediumIdList = [];
  String boardChip;
  String standardChip;

  List<String> listSearchingItem = List();
  List<String> listSelectSearchingItem = List();

  List<int> listBoardId = List();
  List<String> listBoardName = List();
  List<dynamic> listBoard = List();
  List<String> selectedBoardList = [];
  List<int> selectedBoardIdList = [];

  List<int> listMediumId = List();
  List<String> listMediumName = List();
  List<dynamic> listMedium = List();
  List<String> selectedMediumList = [];

  List<int> listStreamId = List();
  List<String> listStreamName = List();
  List<dynamic> listStream = List();
  List<String> selectedStreamList = [];
  List<int> selectedStreamIdList = [];
  ProgressDialog _progressDialog;
  bool isLoadingData;
  List<Map<String, dynamic>> listData = List();
  double nearLength = 30;
  RibbonLocation location = RibbonLocation.topEnd;
  double farLength = 60;
  bool isListViewShow;
  bool standardSelected;
  bool boardSelected;
  bool mediumSelected;
  bool streamSelected;
  bool typeOfCourseSelected;
  bool typeOfPublisherSelected;

  @override
  Widget build(BuildContext context) {
    _progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
    _progressDialog.setMessage(UtilsData.kLoadingMsg);
    return Container(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            Wrap(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: ChoiceChip(
                      selected: standardSelected,
                      label: Text(standardChip),
                      labelStyle: TextStyle(
                          color: standardSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0),
                      shadowColor: Colors.grey,
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      backgroundColor: Colors.white,
                      selectedColor: Colors.blue,
                      onSelected: (bool selected) {
                        setState(() {
                          standardSelected = !standardSelected;
                        });
                        if (selectedStandardList.isEmpty) {
                          _openStandardFilterList();
                        } else {
                          setState(() {
                            selectedStandardList.clear();
                            selectedStandardIdList.clear();
                          });
                          if (standardSelected ||
                              boardSelected ||
                              mediumSelected ||
                              streamSelected) {
                            _progressDialog.show();
                            getFilterData();
                          } else {
                            setState(() {
                              listData.clear();
                            });
                          }
                        }
                      }),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: ChoiceChip(
                      selected: boardSelected,
                      label: Text(boardChip),
                      labelStyle: TextStyle(
                        color: boardSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.0,
                      ),
                      shadowColor: Colors.grey,
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      backgroundColor: Colors.white,
                      selectedColor: Colors.blue,
                      onSelected: (bool selected) {
                        setState(() {
                          boardSelected = !boardSelected;
                        });
                        if (selectedBoardList.isEmpty) {
                          _openBoardFilterList();
                        } else {
                          setState(() {
                            selectedBoardList.clear();
                            selectedBoardIdList.clear();
                          });
                          if (standardSelected || boardSelected ||
                              mediumSelected || streamSelected) {
                            _progressDialog.show();
                            getFilterData();
                          } else {
                            setState(() {
                              listData.clear();
                            });
                          }
                        }
                      }),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: ChoiceChip(
                    selected: mediumSelected,
                    label: Text('MEDIUM WISE'),
                    labelStyle: TextStyle(
                        color: mediumSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.0),
                    shadowColor: Colors.grey,
                    elevation: 10,
                    clipBehavior: Clip.antiAlias,
                    backgroundColor: Colors.white,
                    selectedColor: Colors.blue,
                    onSelected: (bool selected) {
                      setState(() {
                        mediumSelected = !mediumSelected;
                      });
                      if (selectedMediumList.isEmpty) {
                        _openMediumFilterList();
                      } else {
                        setState(() {
                          selectedMediumList.clear();
                          selectedMediumIdList.clear();
                        });
                        if (standardSelected || boardSelected ||
                            mediumSelected || streamSelected) {
                          _progressDialog.show();
                          getFilterData();
                        } else {
                          setState(() {
                            listData.clear();
                          });
                        }
                      }
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: ChoiceChip(
                      selected: streamSelected,
                      label: Text('STREAM WISE'),
                      labelStyle: TextStyle(
                          color: streamSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0),
                      shadowColor: Colors.grey,
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      backgroundColor: Colors.white,
                      selectedColor: Colors.blue,
                      onSelected: (bool selected) {
                        setState(() {
                          streamSelected = !streamSelected;
                        });
                        if (selectedStreamList.isEmpty) {
                          _openStreamFilterList();
                        } else {
                          setState(() {
                            selectedStreamList.clear();
                            selectedStreamIdList.clear();
                          });
                          if (standardSelected || boardSelected ||
                              mediumSelected || streamSelected) {
                            _progressDialog.show();
                            getFilterData();
                          } else {
                            setState(() {
                              listData.clear();
                            });
                          }
                        }
                      }),
                ),
                Container(
                  margin: EdgeInsets.all(10.0),
                  child: ChoiceChip(
                      selected: typeOfPublisherSelected,
                      label: Text('Search by publisher'),
                      labelStyle: TextStyle(
                          color: typeOfPublisherSelected
                              ? Colors.white
                              : Colors.black,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2.0),
                      shadowColor: Colors.grey,
                      elevation: 10,
                      clipBehavior: Clip.antiAlias,
                      backgroundColor: Colors.white,
                      selectedColor: Colors.blue,
                      onSelected: (bool selected) {
                        setState(() {
                          typeOfPublisherSelected = !typeOfPublisherSelected;
                        });
                        if (selectedPublisherName.isEmpty) {
                          _openTypeOfCourseFilterList();
                        } else {
                          setState(() {
                            selectedPublisherName.clear();
                            selectedPublisherId.clear();
                          });
                          if (standardSelected || boardSelected ||
                              mediumSelected || streamSelected) {
                            _progressDialog.show();
                            getFilterData();
                          } else {
                            setState(() {
                              listData.clear();
                            });
                          }
                        }
                      }),
                ),
                // Container(
                //   margin: EdgeInsets.all(10.0),
                //   child: ChoiceChip(
                //       selected: typeOfCourseSelected,
                //       label: Text('SUBJECT WISE'),
                //       labelStyle: TextStyle(
                //           color: typeOfCourseSelected
                //               ? Colors.white
                //               : Colors.black,
                //           fontWeight: FontWeight.w500,
                //           letterSpacing: 2.0),
                //       shadowColor: Colors.grey,
                //       elevation: 10,
                //       clipBehavior: Clip.antiAlias,
                //       backgroundColor: Colors.white,
                //       selectedColor: Colors.blue,
                //       onSelected: (bool selected) {
                //         setState(() {
                //           typeOfCourseSelected = !typeOfCourseSelected;
                //         });
                //         if (selectedTypeOfCourse.isEmpty) {
                //           _openTypeOfCourseFilterList();
                //         } else {
                //           setState(() {
                //             selectedTypeOfCourse.clear();
                //             selectedTypeOfCourseId.clear();
                //           });
                //           if (standardSelected || boardSelected ||
                //               mediumSelected || streamSelected) {
                //             _progressDialog.show();
                //             getFilterData();
                //           } else {
                //             setState(() {
                //               listData.clear();
                //             });
                //           }
                //         }
                //       }),
                // ),
              ],
            ),
            Center(
                child: Text(
                  '----------OR----------',
                  style: TextStyle(
                      color: UtilsData.kBlue,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0),
                )),
            // Container(
            //   margin: EdgeInsets.all(10.0),
            //   child: ChoiceChip(
            //       selected: false,
            //       label: Text('Search By Expert Name'),
            //       labelStyle: TextStyle(
            //           color: Colors.black,
            //           fontWeight: FontWeight.w500,
            //           letterSpacing: 2.0),
            //       shadowColor: Colors.grey,
            //       elevation: 10,
            //       clipBehavior: Clip.antiAlias,
            //       backgroundColor: Colors.white,
            //       selectedColor: Colors.blue,
            //       onSelected: (bool selected) {
            //         Navigator.of(context).push(
            //             MaterialPageRoute(builder: (context) => Search()));
            //       }),
            // ),
            Container(
              child: ChoiceChip(
                  selected: false,
                  label: Text('Search Product By Keyword'),
                  labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2.0),
                  shadowColor: Colors.grey,
                  elevation: 10,
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Colors.white,
                  selectedColor: Colors.blue,
                  onSelected: (bool selected) {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ProductSearch(),),);
                  }),
            ),
//            Container(
//              margin: EdgeInsets.all(10.0),
//              child: ChipsChoice<String>.multiple(
//                value: listSelectSearchingItem,
//                isWrapped: true,
//                options: ChipsChoiceOption.listFrom<String, String>(
//                  source: listSearchingItem,
//                  value: (i, v) => v,
//                  label: (i, v) => v,
//                ),
//                onChanged: (val) {
//                  print('selected item $val');
//                  setState(
//                    () {
//                      return listSelectSearchingItem = val;
//                    },
//                  );
//
//                  if(!(listSelectSearchingItem.length==0)){
//                    int length = listSelectSearchingItem.length;
//                    String lastItem =
//                    listSelectSearchingItem.elementAt(length - 1);
//                    if (lastItem == 'STANDARD') {
//                      if (selectedStandardList.isEmpty) {
//                        int length = listSelectSearchingItem.length;
//                        String lastItem =
//                        listSelectSearchingItem.elementAt(length - 1);
//                        print('last item $lastItem');
//                        if (lastItem == 'STANDARD') {
//                          _openStandardFilterList();
//                        }
//                      } else {
//                        setState(() {
//                          selectedStandardList.clear();
//                          selectedStandardIdList.clear();
//                          _progressDialog.show();
//                          getFilterData();
//                        });
//                      }
//                    } else if (lastItem == 'BOARD') {
//                      if (selectedBoardList.isEmpty) {
//                        int length = listSelectSearchingItem.length;
//                        String lastItem =
//                        listSelectSearchingItem.elementAt(length - 1);
//                        print('last item $lastItem');
//                        if (lastItem == 'BOARD') {
//                          _openBoardFilterList();
//                        }
//                      } else {
//                        setState(() {
//                          selectedBoardList.clear();
//                          selectedBoardIdList.clear();
//                          _progressDialog.show();
//                          getFilterData();
//                        });
//                      }
//                    }
//
//                  }else{
//                    setState(() {
//                      selectedBoardIdList.clear();
//                      selectedBoardList.clear();
//                      selectedStandardList.clear();
//                      selectedStandardIdList.clear();
//                    });
//
//                    _progressDialog.show();
//                    getFilterData();
//                  }
//
//
////                 else if (lastItem == 'BOARD') {
////                    _openBoardFilterList();
////                  } else if (lastItem == 'MEDIUM') {
////                    _openMediumFilterList();
////                  } else if (lastItem == 'STREAM') {
////                    _openStreamFilterList();
////                  } else if (lastItem == 'TYPE OF COURSE') {
////                    _openTypeOfCourseFilterList();
////                  }
//                },
//              ),
//            ),
            Visibility(
              visible: isLoadingData,
              child: CircularProgressIndicator(),
            ),
            popularFilter(),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    boardChip = 'BOARD WISE';
    standardSelected = false;
    boardSelected = false;
    mediumSelected = false;
    streamSelected = false;
    typeOfCourseSelected = false;
    typeOfPublisherSelected=false;
    standardChip = 'STANDARD WISE';
    isListViewShow = false;
    listSearchingItem.insert(0, 'STANDARD');
    listSearchingItem.insert(1, 'BOARD');
    listSearchingItem.insert(2, 'MEDIUM');
    listSearchingItem.insert(3, 'STREAM');
    listSearchingItem.insert(4, 'TYPE OF COURSE');
    isLoadingData = true;
    listBoard.clear();
    listBoardId.clear();
    listBoardName.clear();
    selectedBoardList.clear();
    selectedBoardIdList.clear();
    listTypeOfCourse.clear();
    selectedTypeOfCourse.clear();
    selectedTypeOfCourseId.clear();
    listTypeOfCourse.insert(0, 'free');
    listTypeOfCourse.insert(1, 'paid');
    getStandardData();
  }

  Future getBoardData() async {
//    _progressDialog.show();
    listBoard.clear();
    listBoardId.clear();
    listBoardName.clear();
    selectedBoardList.clear();
    selectedBoardIdList.clear();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kGetBoardDataMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
//    Navigator.of(context).pop();
    var data = jsonDecode(response.body);
    print("strandard response $data");
    if (response.statusCode == 200) {
      listBoard = data['boards'];
      for (int i = 0; i < listBoard.length; i++) {
        var facultyData = {
          'id': listBoard[i]['id'],
          'name': listBoard[i]['name'],
        };
        listBoardName.add(listBoard[i]['name']);
        print('board name $listBoardName');
        listBoardId.add(listBoard[i]['id']);
        print('board index ${listBoardId.elementAt(0)}');
      }
      getMediumData();
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
      throw Exception('Failed to load course list');
    }
  }

  Future getStreamData() async {
//    _progressDialog.show();
    listStream.clear();
    listStreamId.clear();
    listStreamName.clear();
    selectedStreamList.clear();
    selectedStreamIdList.clear();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kGetStreamDataMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
//    Navigator.of(context).pop();
    var data = jsonDecode(response.body);
    print("stream response $data");
    if (response.statusCode == 200) {
      listStream = data['streams'];
      for (int i = 0; i < listStream.length; i++) {
        var facultyData = {
          'id': listStream[i]['id'],
          'name': listStream[i]['name'],
        };
        listStreamName.add(listStream[i]['name']);
        listStreamId.add(listStream[i]['id']);
      }
      setState(() {
        isLoadingData = false;
      });

//      _progressDialog.show();
    getPublisherData();
//      getFilterData();
//      _open StandardFilterList();
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
      throw Exception('Failed to load course list');
    }
  }

  Future getMediumData() async {
//    _progressDialog.show();
    listMedium.clear();
    listMediumId.clear();
    listMediumName.clear();
    selectedMediumList.clear();
    selectedMediumIdList.clear();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kGetMediumMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
//    Navigator.of(context).pop();
    var data = jsonDecode(response.body);
    print("medium response $data");
    if (response.statusCode == 200) {
      listMedium = data['mediums'];
      for (int i = 0; i < listMedium.length; i++) {
        var facultyData = {
          'id': listMedium[i]['id'],
          'name': listMedium[i]['name'],
        };
        listMediumName.add(listMedium[i]['name']);
        listMediumId.add(listMedium[i]['id']);
      }
      getStreamData();
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
      throw Exception('Failed to load course list');
    }
  }

  Future getStandardData() async {
    listStandard.clear();
    listStandardId.clear();
    selectedStandardList.clear();
    selectedStandardIdList.clear();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kGetStandardDataMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
//    Navigator.of(context).pop();
    var data = jsonDecode(response.body);
    print("strandard response $data");
    if (response.statusCode == 200) {
      listStandard = data['standards'];
      for (int i = 0; i < listStandard.length; i++) {
        var facultyData = {
          'id': listStandard[i]['id'],
          'name': listStandard[i]['name'],
        };
        listStandardName.add(listStandard[i]['name']);
        listStandardId.add(listStandard[i]['id']);
//      return StandardListModel.fromJson(data);
//      getStreamData();
      }
      getBoardData();
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
      throw Exception('Failed to load course list');
    }
  }

  Widget allAccommodationUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Type of Accommodation',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
//            children: getAccomodationListUI(),
            children: <Widget>[
              Container(
                height: 100,
                color: Colors.transparent,
              )
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget distanceViewUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
          const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Distance from city center',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
//        SliderView(
//          distValue: distValue,
//          onChangedistValue: (double value) {
//            distValue = value;
//          },
//        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget popularFilter() {
    return isListViewShow == true
        ? Expanded(
      child: ListView.builder(
          padding: EdgeInsets.all(8.0),
          itemCount: listData.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 10.0,
              shadowColor: AppTheme.notWhite,
              margin: EdgeInsets.all(10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                    listData[index]['thumbnail_url'],
                  ),
                ),
                title: Text(
                  listData[index]['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  ),
                ), //
//                          subtitle: Text(
//                            listData[index]['description'],
//                            style: TextStyle(
//                              letterSpacing:
//                              0.27,
//                            ),
//                          ),
                onTap: () {
                  double different =
                      double.parse(listData[index]['mrp_price']) -
                          double.parse(listData[index]['sell_price']);
                  different = different *
                      100 /
                      double.parse(listData[index]['mrp_price']);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductDetailsInfo(
                        id: listData[index]['id'],
                        // type: listData[index]['type_of_course'],
                        different: different,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
    )
        : SizedBox();
  }

//  List<Widget> getPList() {
//    final List<Widget> noList = <Widget>[];
//    int count = 0;
//    const int columnCount = 2;
//    for (int i = 0; i < popularFilterListData.length / columnCount; i++) {
//      final List<Widget> listUI = <Widget>[];
//      for (int i = 0; i < columnCount; i++) {
//        try {
//          final PopularFilterListData date = popularFilterListData[count];
//          listUI.add(Expanded(
//            child: Row(
//              children: <Widget>[
//                Material(
//                  color: Colors.transparent,
//                  child: InkWell(
//                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
//                    onTap: () {
//                      setState(() {
//                        date.isSelected = !date.isSelected;
//                      });
//                    },
//                    child: Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Row(
//                        children: <Widget>[
//                          Icon(
//                            date.isSelected
//                                ? Icons.check_box
//                                : Icons.check_box_outline_blank,
//                            color: date.isSelected
//                                ? HotelAppTheme.buildLightTheme().primaryColor
//                                : Colors.grey.withOpacity(0.6),
//                          ),
//                          const SizedBox(
//                            width: 4,
//                          ),
//                          Text(
//                            date.titleTxt,
//                          ),
//                        ],
//                      ),
//                    ),
//                  ),
//                ),
//              ],
//            ),
//          ));
//          count += 1;
//        } catch (e) {
//          print(e);
//        }
//      }
//      noList.add(Row(
//        mainAxisAlignment: MainAxisAlignment.center,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        mainAxisSize: MainAxisSize.min,
//        children: listUI,
//      ));
//    }
//    return noList;
//  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: GestureDetector(
            onTap: () {
              _openStandardFilterList();
            },
            child: Text(
              'Select Standard',
              textAlign: TextAlign.left,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                  fontWeight: FontWeight.normal),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Material Search',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }

  void _openTypeOfCourseFilterList() async {

    var list= await FilterListDialog.display(
        context,
        allTextList: listPublisherName,
        height: 450,
        borderRadius: 20,
        headlineText: "Select Publisher",
        searchFieldHintText: "Search Here",
        selectedTextList: selectedPublisherName,
    );

    // var list = await FilterList.showFilterList(
    //   context,
    //   allTextList: listTypeOfCourse,
    //   height: 450,
    //   borderRadius: 20,
    //   headlineText: "Select Type Of Course",
    //   searchFieldHintText: "Search Here",
    //   selectedTextList: selectedTypeOfCourse,
    // );

    if (list != null) {
      setState(() {
        selectedPublisherName = List.from(list);
        print('selected Type of course list $selectedPublisherName');
      });
    }
    _progressDialog.show();
    getFilterData();
  }

  void _openStreamFilterList() async {
    var list = await FilterListDialog.display(
      context,
      allTextList: listStreamName,
      height: 450,
      borderRadius: 20,
      headlineText: "Select Stream",
      searchFieldHintText: "Search Here",
      selectedTextList: selectedStreamList,
    );

    if (list != null) {
      setState(() {
        selectedStreamList = List.from(list);
        print('selected Stream list $selectedStreamList');
        for (int i = 0; i < selectedStreamList.length; i++) {
          try {
            print(
                'bharat ${listStreamId.elementAt(listStreamName.indexOf(selectedStreamList[i]))}');
          } catch (exception) {
            print('exception ${exception.toString()}');
          }

          selectedStreamIdList.insert(
              i,
              listStreamId
                  .elementAt(listStreamName.indexOf(selectedStreamList[i])));
        }
      });
      _progressDialog.show();
      getFilterData();
//      _openTypeOfCourseFilterList();
    }
  }

  void _openMediumFilterList() async {
    var list = await FilterListDialog.display(
      context,
      allTextList: listMediumName,
      height: 450,
      borderRadius: 20,
      headlineText: "Select Medium",
      searchFieldHintText: "Search Here",
      selectedTextList: selectedMediumList,
    );

    if (list != null) {
      setState(() {
        selectedMediumList = List.from(list);
        print('selected medium list $selectedMediumList');
        for (int i = 0; i < selectedMediumList.length; i++) {
          try {
            print(
                'bharat ${listMediumId.elementAt(listMediumName.indexOf(selectedMediumList[i]))}');
          } catch (exception) {
            print('exception ${exception.toString()}');
          }

          selectedMediumIdList.insert(
              i,
              listMediumId
                  .elementAt(listMediumName.indexOf(selectedMediumList[i])));
        }
      });
      _progressDialog.show();
      getFilterData();
//      _openStreamFilterList();
    }
  }

  void _openBoardFilterList() async {
    selectedBoardList.clear();
    selectedBoardIdList.clear();
    var list = await FilterListDialog.display(
      context,
      allTextList: listBoardName,
      height: 450,
      borderRadius: 20,
      headlineText: "Select Board",
      searchFieldHintText: "Search Here",
      selectedTextList: selectedBoardList,
    );

    if (list != null) {
      setState(() {
        selectedBoardList = List.from(list);
        print('selected board list $selectedBoardList');
        for (int i = 0; i < selectedBoardList.length; i++) {
          try {
            print(
                'bharat ${listBoardId.elementAt(listBoardName.indexOf(selectedBoardList[i]))}');
          } catch (exception) {
            print('exception ${exception.toString()}');
          }

          selectedBoardIdList.insert(
              i,
              listBoardId
                  .elementAt(listBoardName.indexOf(selectedBoardList[i])));
        }

        print('selected board list id $selectedBoardIdList');
      });
      _progressDialog.show();
      getFilterData();
//      _openMediumFilterList();
    }
  }

  void _openStandardFilterList() async {
    selectedStandardIdList.clear();
    selectedStandardIdList.clear();
    var list = await FilterListDialog.display(
      context,
      allTextList: listStandardName,
      height: 450,
      borderRadius: 20,
      headlineText: "Select Standard",
      searchFieldHintText: "Search Here",
      selectedTextList: selectedStandardList,
    );

    if (list != null) {
      setState(() {
        selectedStandardList = List.from(list);
        print('selected standard list $selectedStandardList');
        for (int i = 0; i < selectedStandardList.length; i++) {
          try {
            print(
                'bharat ${listStandardId.elementAt(listStandardName.indexOf(selectedStandardList[i]))}');
          } catch (exception) {
            print('exception ${exception.toString()}');
          }

          selectedStandardIdList.insert(
              i,
              listStandardId.elementAt(
                  listStandardName.indexOf(selectedStandardList[i])));
        }
      });
      _progressDialog.show();
      getFilterData();
//      _openBoardFilterList();
    }
  }

  Future<void> getFilterData() async {
    listData.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('type of course $_typeOfCourse');
    print('type of board $selectedBoardList');
    print('type of standard $selectedStandardIdList');
    print('type of medium $selectedMediumList');
    print('type of stream $selectedStreamList');
    final http.Response response = await http.post(
      UtilsData.kBaseUrl + UtilsData.kFilterDataMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
      body: jsonEncode(
        <String, List>{
          'board_id': selectedBoardIdList,
          'standard_id': selectedStandardIdList,
          'medium_id': selectedMediumIdList,
          'stream_id': selectedStreamIdList,
          // 'type_of_course': selectedTypeOfCourse,
          'publisher_id':selectedTypeOfCourse,
        },
      ),
    );

    print('request data ${jsonEncode(
      <String, List>{
        'board_id': selectedBoardIdList,
        'standard_id': selectedStandardIdList,
        'medium_id': selectedMediumIdList,
        'stream_id': selectedStreamIdList,
        'type_of_course': selectedTypeOfCourse,
      },
    )}');
    Navigator.of(context).pop();

    var _responseData = jsonDecode(response.body);
    print('response from service $_responseData');
    print('response code${response.statusCode}');

    if (response.statusCode == 200) {
      print('result ok');
      List<dynamic> listCourses = [];
      listCourses = _responseData['courses'];
      for (int i = 0; i < listCourses.length; i++) {
        var coursesData = {
          'id': listCourses[i]['id'],
          'name': listCourses[i]['name'],
          'description': listCourses[i]['description'],
          // 'type_of_course': listCourses[i]['type_of_course'],
          'mrp_price': listCourses[i]['mrp_price'],
          'sell_price': listCourses[i]['sell_price'],
          'thumbnail_url': listCourses[i]['thumbnail_url'],
        };
        listData.add(coursesData);
      }
      setState(() {
        isListViewShow = true;
        print('is loading $isListViewShow');
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
      )..show();
    } else {
      UtilsData.kErrorDialog(
          context: context,
          errorMsg: _responseData[UtilsData.kResponseErrorMessage]);
    }
  }

  Future<void> getPublisherData() async{
    listPublisher.clear();
    listPublisherId.clear();
    listPublisherName.clear();
    selectedPublisherName.clear();
    selectedPublisherId.clear();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kPublisherMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
//    Navigator.of(context).pop();
    var data = jsonDecode(response.body);
    print("stream response $data");
    if (response.statusCode == 200) {
      listPublisher = data['publishers'];
      for (int i = 0; i < listPublisher.length; i++) {
        var facultyData = {
          'id': listPublisher[i]['id'],
          'name': listPublisher[i]['name'],
        };
        listPublisherName.add(listPublisher[i]['name']);
        listPublisherId.add(listPublisher[i]['id']);
      }
      setState(() {
        isLoadingData = false;
      });

//      _progressDialog.show();
//       getPublisherData();
//      getFilterData();
//      _openStandardFilterList();
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
      throw Exception('Failed to load course list');
    }
  }
}
