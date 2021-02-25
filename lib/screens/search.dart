import 'dart:convert';
import 'dart:io';

import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:virtual_dukan/screens/filters_screen.dart';
import 'package:virtual_dukan/screens/login.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'institutes_details_info.dart';

class Search extends StatefulWidget {
  Search({Key key}) : super(key: key);

  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String searchValue;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();
  List<Map<String, dynamic>> listString = List();
  List<dynamic> listInstitutes = List();
  TextEditingController _nameTextController;
  List<String> listName = List();
  List<Map<String, dynamic>> searchingList = List();
  bool isSearch;
  bool isLoading;
  String currentText = 'Search For Expert..';

  void myFunction(String text) {
    print(text);
    searchValue = text;
    print('select text');
  }

  InputDecoration textDecoration({String filedName}) {
    return InputDecoration(
        labelText: filedName,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 45.0,
          left: 24.0,
          right: 24.0,
        ),
        child: Column(
          children: <Widget>[
            Form(
              key: _formKey,
              child: SimpleAutoCompleteTextField(
                decoration: InputDecoration(
                  hintText: 'Search For Expert',
                  hintStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Color(0xFFEEEEEE),
                  prefixIcon: Icon(
                    Icons.mic,
                    color: Colors.blueGrey[200],
                  ),
//                  suffixIcon: IconButton(
//                    icon: Icon(
//                      Icons.sort,
////                      color: Colors.black54,
//                      color: HexColor('#54D3C2'),
//                      size: 28,
//                    ),
//                    onPressed: () {
//                      FocusScope.of(context).unfocus();
//                      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>FiltersScreen(),fullscreenDialog: true));
////                      print('search text $searchValue');
////                      searchingWord(text: searchValue);
//
//                    },
//                  ),
                ),
                key: key,
                suggestions: listName,
                textChanged: (text) {
                  currentText = text;
                  print('current text');
                },
                clearOnSubmit: true,
                textSubmitted: (text) => setState(() {
                  if (text != "") {
                    searchingWord(text: text);
                  }
                }),
              ),
//              child: SimpleAutoCompleteTextField(
//                key: key,
//                decoration: textDecoration(filedName: 'Search For Expert').copyWith(hintText: 'Search For Expert'),
//                controller: TextEditingController(text: searchValue??''),
//                suggestions: listName,
//                textChanged: (text) => currentText = text,
//                clearOnSubmit: true,
//                textSubmitted: (text) => setState(() {
//                  if (text != "") {
//                    setState(() {
//                      searchValue=text;
//                    });
//                    print('bharat value $searchValue');
//                  }
//                }),
//              ),

//              child: TextField(
//                textAlign: TextAlign.center,
//                keyboardType: TextInputType.text,
//                onChanged: (value) {
//                  searchValue = value;
//
//                },
//                decoration: InputDecoration(
//                  hintText: 'Search For Expert',
//                  hintStyle: TextStyle(fontSize: 16),
//                  border: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(32),
//                    borderSide: BorderSide(
//                      width: 0,
//                      style: BorderStyle.none,
//                    ),
//                  ),
//                  filled: true,
//                  contentPadding: EdgeInsets.all(16),
//                  fillColor: Color(0xFFEEEEEE),
//                  prefixIcon: Icon(
//                    Icons.mic,
//                    color: Colors.blueGrey[200],
//                  ),
//                  suffixIcon: IconButton(
//                    icon: Icon(
//                      Icons.search,
//                      color: Colors.black54,
//                      size: 28,
//                    ),
//                    onPressed: () {
//                      print('search text $searchValue');
//                      searchingWord(text: searchValue);
//                    },
//                  ),
//                ),
//              ),
            ),
            Expanded(
                child: isLoading == true
                    ? Center(child: const CircularProgressIndicator())
                    : isSearch
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: searchingList.length,
                            itemBuilder: (context, pos) {
                              return GestureDetector(
                                onTap: () {
                                  print(
                                      'id of institutes ${searchingList[pos]['id']}');
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          InstitutesDetailsInfo(
                                            id: searchingList[pos]['id'],
                                            profileImage: searchingList[pos]
                                                ['profile_image_url'],
                                          )));
                                },
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 16.0),
                                    height: 148,
                                    child: new ClipRRect(
                                      borderRadius:
                                          new BorderRadius.circular(8.0),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              image: DecorationImage(
                                                fit: BoxFit.fill,
                                                image: NetworkImage(
                                                  searchingList[pos]
                                                      ['profile_image_url'],
                                                ),
                                              ),
                                            ),
                                            height: 350.0,
                                          ),
                                          Container(
                                            height: 350.0,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                gradient: LinearGradient(
                                                    begin: FractionalOffset
                                                        .topCenter,
                                                    end: FractionalOffset
                                                        .bottomCenter,
                                                    colors: [
                                                      Colors.black26,
                                                      Colors.black26,
                                                    ],
                                                    stops: [
                                                      0.0,
                                                      1.0
                                                    ])),
                                          ),
                                          Center(
                                            child: Visibility(
                                              visible: false,
                                              child: Text(
                                                searchingList[pos]['name'],
                                                style: TextStyle(
                                                    fontSize: 26,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )),
                              );
                            },
                          )
                        : SizedBox() /*ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: listString.length,
                itemBuilder: (context, pos) {
                  return GestureDetector(
                    onTap: () {
                      print(
                          'id of institutes ${listString[pos]['id']}');
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              InstitutesDetailsInfo(
                                id: listString[pos]['id'],
                                profileImage: listString[pos]['profile_image_url'],
                              )));
                    },
                    child: Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        height: 148,
                        child: new ClipRRect(
                          borderRadius:
                          new BorderRadius.circular(8.0),
                          child: Stack(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                      listString[pos]['profile_image_url'],
                                    ),
                                  ),
                                ),
                                height: 350.0,
                              ),
                              Container(
                                height: 350.0,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    gradient: LinearGradient(
                                        begin: FractionalOffset
                                            .topCenter,
                                        end: FractionalOffset
                                            .bottomCenter,
                                        colors: [
                                          Colors.black26,
                                          Colors.black26,
                                        ],
                                        stops: [
                                          0.0,
                                          1.0
                                        ])),
                              ),
                              Center(
                                child: Visibility(
                                  visible: false,
                                  child: Text(
                                    listString[pos]['name'],
                                    style: TextStyle(
                                        fontSize: 26,
                                        color: Colors.white,
                                        fontWeight:
                                        FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )),
                  );
                },
              )
*/
                )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _nameTextController = TextEditingController();
    isLoading = true;
    isSearch = false;
    getData();
  }

  searchingWord({String text}) {
    searchingList.clear();
    for (int i = 0; i < listString.length; i++) {
      var map = listString[i];
      print('map data $map');
      if (map['name'] == text) {
        searchingList.add(map);
      }
    }
    setState(() {
      isSearch = true;
    });
    print('search data $searchingList');
  }

  Future<Null> getData() async {
    listString.clear();
    listInstitutes.clear();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kGetInstitutesListMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      listInstitutes = data['institutes'];
      print('data of institutes :$listInstitutes');
      for (int i = 0; i < listInstitutes.length; i++) {
        var facultyData = {
          'id': listInstitutes[i]['id'],
          'name': listInstitutes[i]['name'],
          'email': listInstitutes[i]['email'],
          'mobile_no': listInstitutes[i]['mobile_no'],
          'profile_image_url': listInstitutes[i]['profile_image_url'],
        };
        listName.add(listInstitutes[i]['name']);
        listString.add(facultyData);
        print('faculty data :$listString');
        setState(() {
          isLoading = false;
          print('is loading $isLoading');
        });
      }
      print('faculty name :$listName');
//      return InstitutesModel.fromJson(jsonDecode(response.body));
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
