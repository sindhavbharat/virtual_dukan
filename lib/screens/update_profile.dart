import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:virtual_dukan/design_course/models/board_list_model.dart';
import 'package:virtual_dukan/design_course/models/medium_model.dart';
import 'package:virtual_dukan/design_course/models/standard_model.dart';
import 'package:virtual_dukan/design_course/models/stream_model.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UtilsData.kWhite,
      body: UpdateData(),
    );
  }
}

class UpdateData extends StatefulWidget {
  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  final _formKey = GlobalKey<FormState>();
  File _image;
  TextEditingController _dobController;
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _mobileController;
  TextEditingController _cityController;
  TextEditingController _standardController;
  String boardDropDownValue;
  String standardDropDownValue;
  String streamDropDownValue;
  String mediumDropDownValue;

  final picker = ImagePicker();
  ProgressDialog _progressDialog;
  String _kProfileImage;

  List<int> listStreamId = [];
  List<String> listStreamName = [];

  List<int> listStdId = [];
  List<String> listStdName = [];

  List<int> listBoardId = [];
  List<String> listBoardName = [];

  List<int> listMediumId = [];
  List<String> listMediumName = [];

  @override
  void initState() {
    _dobController = TextEditingController();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _cityController = TextEditingController();
    _standardController = TextEditingController();
    boardDropDownValue = 'CBSE';
    standardDropDownValue = '9';
    streamDropDownValue = 'Commerce';
    mediumDropDownValue = 'Gujarati';
    getData();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

  Future<void> getData() async {
//    _progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
//    _progressDialog.setMessage(UtilsData.kLoadingMsg);
//    _progressDialog.show();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.get(
      UtilsData.kBaseUrl + UtilsData.kGetUserInformationMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
    );
//    Navigator.of(context).pop();
    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      var user = data['user'];
      setState(() {
        _kProfileImage = user['profile_image'];
        _nameController.text = user['name'] ?? '';
        _emailController.text = user['email'] ?? '';
        _mobileController.text = user['mobile_no'] ?? '';
        _cityController.text = user['city'] ?? '';
        _standardController.text = user['standard'].toString() ?? '';
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
      throw Exception('Failed to load course list');
    }
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);

    listStreamId.clear();
    listStreamName.clear();
    listBoardId.clear();
    listBoardName.clear();

    listMediumId.clear();
    listMediumName.clear();

    listStdId.clear();
    listStdName.clear();

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
                      Center(
                        child: InkWell(
                          onTap: () => getImage(),
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: _image == null
                                  ? DecorationImage(
                                image: _kProfileImage == null
                                    ? AssetImage(
                                    '${UtilsData.kImageDir}/select_image.png')
                                    : NetworkImage(
                                  _kProfileImage,
                                ),
                              )
                                  : DecorationImage(
                                  image: FileImage(_image),
                                  fit: BoxFit.cover),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: AppTheme.grey.withOpacity(0.6),
                                    offset: const Offset(2.0, 2.0),
                                    blurRadius: 5),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _nameController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          decoration:
                          textDecoration(filedName: UtilsData.kName),
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter name';
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: TextFormField(
//                          controller: _dobController,
//                          textInputAction: TextInputAction.next,
//                          keyboardType: TextInputType.text,
//                          readOnly: true,
//                          validator: (value){
//                            if(value.isEmpty){
//                              return 'Please select date of birth';
//                            }else{
//                              return null;
//                            }
//                          },
//                          onTap: () => _selectDate(context),
//                          decoration: textDecoration(filedName: UtilsData.kDob),
//                        ),
//                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _cityController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter city name';
                            } else {
                              return null;
                            }
                          },
                          decoration:
                          textDecoration(filedName: UtilsData.kCity),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter email address';
                            } else {
                              return null;
                            }
                          },
                          decoration:
                          textDecoration(filedName: UtilsData.kEmail),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _mobileController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          maxLength: 10,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter mobile number';
                            } else if (value.length < 10) {
                              return 'Please enter valid mobile number';
                            }
                            else {
                              return null;
                            }
                          },
                          decoration:
                          textDecoration(filedName: UtilsData.kMobile),
                        ),
                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: FutureBuilder(
//                          future: getStandardData(),
//                          builder: (BuildContext context,
//                              AsyncSnapshot<StandardListModel> snapshot) {
//                            if (!snapshot.hasData) {
//                              return CircularProgressIndicator();
//                            } else {
//                              print(
//                                  'standrad lengh ${snapshot.data.standards
//                                      .length}');
//                              listStdId.clear();
//                              listStdName.clear();
//                              for (int i = 0;
//                              i < snapshot.data.standards.length;
//                              i++) {
//                                listStdId.insert(
//                                    i, snapshot.data.standards[i].id);
//                                listStdName.insert(
//                                    i, snapshot.data.standards[i].name);
//                              }
//                              print('standrard name $listStdName');
//                              return DropdownButtonFormField(
//                                value: standardDropDownValue,
//                                validator: (String value) {
//                                  if (value.isEmpty) {
//                                    return 'Please Select Standard';
//                                  } else {
//                                    return null;
//                                  }
//                                },
//                                decoration:
//                                textDecoration(filedName: UtilsData.kStandard),
//                                items: listStdName
//                                    .map<DropdownMenuItem<String>>(
//                                        (String value) {
//                                      return DropdownMenuItem<String>(
//                                        value: value,
//                                        child: Text(value),
//                                      );
//                                    }).toList(),
//                                onChanged: (String newValue) {
//                                  FocusScope.of(context)
//                                      .requestFocus(FocusNode());
//                                  setState(() {
//                                    standardDropDownValue = newValue;
//                                  });
//                                },
//                              );
//                            }
//                          },
//                        ),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: FutureBuilder(
//                          future: getBoardData(),
//                          builder: (BuildContext context,
//                              AsyncSnapshot<BoardListModel> snapshot) {
//                            if (!snapshot.hasData) {
//                              return CircularProgressIndicator();
//                            } else {
//                              print(
//                                  'standrad lengh ${snapshot.data.boards
//                                      .length}');
//                              listBoardId.clear();
//                              listBoardName.clear();
//                              for (int i = 0;
//                              i < snapshot.data.boards.length;
//                              i++) {
//                                listBoardId.insert(
//                                    i, snapshot.data.boards[i].id);
//                                listBoardName.insert(
//                                    i, snapshot.data.boards[i].name);
//                              }
//                              print('board name $listStdName');
//                              return DropdownButtonFormField(
//                                value: boardDropDownValue,
//                                validator: (String value) {
//                                  if (value.isEmpty) {
//                                    return 'Please Select Board';
//                                  } else {
//                                    return null;
//                                  }
//                                },
//                                decoration:
//                                textDecoration(filedName: UtilsData.kBoard),
//                                items: listBoardName
//                                    .map<DropdownMenuItem<String>>(
//                                        (String value) {
//                                      return DropdownMenuItem<String>(
//                                        value: value,
//                                        child: Text(value),
//                                      );
//                                    }).toList(),
//                                onChanged: (String newValue) {
//                                  FocusScope.of(context)
//                                      .requestFocus(FocusNode());
//                                  setState(() {
//                                    boardDropDownValue = newValue;
//                                  });
//                                },
//                              );
//                            }
//                          },
//                        ),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: FutureBuilder(
//                          future: getMediumData(),
//                          builder: (BuildContext context,
//                              AsyncSnapshot<MediumListModel> snapshot) {
//                            if (!snapshot.hasData) {
//                              return CircularProgressIndicator();
//                            } else {
//                              print(
//                                  'stream lenght ${snapshot.data.mediums
//                                      .length}');
//                              listMediumId.clear();
//                              listMediumName.clear();
//                              for (int i = 0;
//                              i < snapshot.data.mediums.length;
//                              i++) {
//                                listMediumId.insert(
//                                    i, snapshot.data.mediums[i].id);
//                                listMediumName.insert(
//                                    i, snapshot.data.mediums[i].name);
//                              }
//                              print('medium name $listMediumName');
//                              return DropdownButtonFormField(
//                                value: mediumDropDownValue,
//                                validator: (String value) {
//                                  if (value.isEmpty) {
//                                    return 'Please Select Medium';
//                                  } else {
//                                    return null;
//                                  }
//                                },
//                                decoration:
//                                textDecoration(filedName: UtilsData.kMedium),
//                                items: listMediumName
//                                    .map<DropdownMenuItem<String>>(
//                                        (String value) {
//                                      return DropdownMenuItem<String>(
//                                        value: value,
//                                        child: Text(value),
//                                      );
//                                    }).toList(),
//                                onChanged: (String newValue) {
//                                  FocusScope.of(context)
//                                      .requestFocus(FocusNode());
//                                  setState(() {
//                                    mediumDropDownValue = newValue;
//                                  });
//                                },
//                              );
//                            }
//                          },
//                        ),
//                      ),
//                      Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: FutureBuilder(
//                          future: getStreamData(),
//                          builder: (BuildContext context,
//                              AsyncSnapshot<StreamListModel> snapshot) {
//                            if (!snapshot.hasData) {
//                              return CircularProgressIndicator();
//                            } else {
//                              print(
//                                  'stream lenght ${snapshot.data.streams
//                                      .length}');
//                              listStreamId.clear();
//                              listStreamName.clear();
//                              for (int i = 0;
//                              i < snapshot.data.streams.length;
//                              i++) {
//                                listStreamId.insert(
//                                    i, snapshot.data.streams[i].id);
//                                listStreamName.insert(
//                                    i, snapshot.data.streams[i].name);
//                              }
//                              print('stream name $listStreamName');
//                              return DropdownButtonFormField(
//                                value: streamDropDownValue,
//                                validator: (String value) {
//                                  if (value.isEmpty) {
//                                    return 'Please Select Stream';
//                                  } else {
//                                    return null;
//                                  }
//                                },
//                                decoration:
//                                textDecoration(filedName: UtilsData.kStream),
//                                items: listStreamName
//                                    .map<DropdownMenuItem<String>>(
//                                        (String value) {
//                                      return DropdownMenuItem<String>(
//                                        value: value,
//                                        child: Text(value),
//                                      );
//                                    }).toList(),
//                                onChanged: (String newValue) {
//                                  FocusScope.of(context)
//                                      .requestFocus(FocusNode());
//                                  setState(() {
//                                    streamDropDownValue = newValue;
//                                  });
//                                },
//                              );
//                            }
//                          },
//                        ),
//                      ),
                      SizedBox(
                        height: 10,
                      ),
                      InkWell(
                        child: Container(
                          width: 330,
                          height: 50,
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
                                  _updateDataProcess(context: context);
                                }
                              },
                              child: Center(
                                child: Text(UtilsData.kUpdateProfile,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: UtilsData.kPoppinsBoldFonts,
                                        fontSize: 18,
                                        letterSpacing: 1.0)),
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

  Future<void> _updateDataProcess({BuildContext context}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();


    var request = http.MultipartRequest(
      "POST", Uri.parse(UtilsData.kBaseUrl + UtilsData.kUpdateProfileMethod),);
    request.fields["name"] = _nameController.text;
    request.fields["city"] = _cityController.text;
//    request.fields["standard"] =
//        listStdId[listStdName.indexOf(standardDropDownValue)].toString();
//    request.fields["board"] =
//        listBoardId[listBoardName.indexOf(boardDropDownValue)].toString();
//    request.fields["medium"] =
//        listMediumId[listMediumName.indexOf(mediumDropDownValue)].toString();
    request.fields["mobile_no"] = _mobileController.text;
//    request.fields["streams"] =
//        listStdId[listStreamName.indexOf(streamDropDownValue)].toString();


    Map<String, String> headers = {
      UtilsData.kHeaderType: UtilsData.kHeaderValue,
      UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
    };


    print('image $_image');
    if (_image != null) {
      var pic = await http.MultipartFile.fromPath("profile_image", _image.path);
      //add multipart to request
      request.files.add(pic);
    }

    request.headers.addAll(headers);
    var response = await request.send();
    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var data = jsonDecode(responseString);

    Navigator.of(context).pop();
    print('respons data $responseData');
    print('respons string $data');

    if (response.statusCode == 200) {
      preferences.setString(UtilsData.kPrefMobileKey, _mobileController.text);
      print('result ok');
      AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.BOTTOMSLIDE,
        title: UtilsData.kSuccess,
        desc: data[UtilsData.kResponseErrorMessage],
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          Navigator.of(context).pop();
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
      UtilsData.kErrorDialog(
          context: context,
          errorMsg: data[UtilsData.kResponseErrorMessage]);
    }

//    print('standra id ${listStdId[listStdName.indexOf(standardDropDownValue)].toString()}');
//    final http.Response response = await http.post(
//        UtilsData.kBaseUrl + UtilsData.kUpdateProfileMethod,
//        headers: <String, String>{
//          UtilsData.kHeaderType: UtilsData.kHeaderValue,
//          UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
//        },
//        body: jsonEncode(<String, String>{
//          'name': _nameController.text,
//          'city': _cityController.text,
//          'standard': listStdId[listStdName.indexOf(standardDropDownValue)].toString(),
//          'board': listBoardId[listBoardName.indexOf(boardDropDownValue)].toString(),
//          'medium': listMediumId[listMediumName.indexOf(mediumDropDownValue)].toString(),
//          'mobile_no':_mobileController.text,
//          'streams':listStdId[listStreamName.indexOf(streamDropDownValue)].toString(),
//        }));
//
//    Navigator.of(context).pop();
//
//    var _responseData = jsonDecode(response.body);
//    print('response from service $_responseData');
//    print('response code${response.statusCode}');

//    if (response.statusCode == 200) {
//      print('result ok');
//      AwesomeDialog(
//        context: context,
//        dialogType: DialogType.SUCCES,
//        animType: AnimType.BOTTOMSLIDE,
//        title: UtilsData.kSuccess,
//        desc: _responseData[UtilsData.kResponseErrorMessage],
//        btnCancelOnPress: () {},
//        btnOkOnPress: () {
//          Navigator.of(context).pop();
//        },
//      )..show();
//
//
//    } else {
//      UtilsData.kErrorDialog(
//          context: context,
//          errorMsg: _responseData[UtilsData.kResponseErrorMessage]);
//    }
  }


  Future<void> _selectDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();
    var _dateFormat = DateFormat('yyyy');
    int _lastDate = int.parse(_dateFormat.format(selectedDate));
    print('last date $_lastDate');
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(_lastDate, 12));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _dobController.text = DateFormat('dd-MMM-yyyy').format(selectedDate);
      });
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
                  UtilsData.kUpdateProfile,
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

  Future<MediumListModel> getMediumData() async {
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
    print("stream response $data");
    if (response.statusCode == 200) {
      return MediumListModel.fromJson(data);
//      getStreamData();
    } else {
      throw Exception('Failed to load course list');
    }
  }

  Future<StreamListModel> getStreamData() async {
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
      return StreamListModel.fromJson(data);
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
//      getStreamData();
    } else {
      throw Exception('Failed to load course list');
    }
  }

  Future<BoardListModel> getBoardData() async {
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
      return BoardListModel.fromJson(data);
//      getStreamData();
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

  Future<StandardListModel> getStandardData() async {
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
      return StandardListModel.fromJson(data);
//      getStreamData();
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
