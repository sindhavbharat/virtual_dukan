// import 'dart:convert';
// import 'dart:io';
//
// import 'package:awesome_dialog/awesome_dialog.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:http/http.dart' as http;
// import 'package:intl/intl.dart';
// import 'package:virtual_dukan/design_course/design_course_app_theme.dart';
// import 'package:virtual_dukan/design_course/models/meeting_list_model.dart';
// import 'package:virtual_dukan/design_course/models/my_order_list.dart';
// import 'package:virtual_dukan/screens/navigation_home_screen.dart';
// import 'package:virtual_dukan/utils_data/app_theme.dart';
// import 'package:virtual_dukan/utils_data/progressdialog.dart';
// import 'package:virtual_dukan/utils_data/utilsData.dart';
// import 'package:ribbon/ribbon.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'course_details_info.dart';
// import 'meeting_widget.dart';
// import 'package:intl/date_symbol_data_local.dart';
//
//
// class MeetingList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: UtilsData.kWhite,
//       body: MeetingListDetails(),
//     );
//   }
// }
//
// class MeetingListDetails extends StatefulWidget {
//   @override
//   _MeetingListDetailsState createState() => _MeetingListDetailsState();
// }
//
// class _MeetingListDetailsState extends State<MeetingListDetails> {
//   ProgressDialog progressDialog;
//   String _subTotal = '';
//   int amount;
//   String _discount = '';
//   String _hash = '';
//   String _txnId = '';
//   String _platformVersion = 'Unknown';
//   String paymentID = "";
//   bool isCartDisplay;
//   final DateFormat formatter = DateFormat('dd-MMM-yyyy hh:mm aaa');
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     isCartDisplay = false;
//     // initializeDateFormatting('en_IST', null);
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     progressDialog = new ProgressDialog(context, ProgressDialogType.Normal);
//     progressDialog.setMessage(UtilsData.kLoadingMsg);
//     return Padding(
//       padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           _appBar(),
//           Expanded(
//             child: Align(
//               alignment: Alignment.bottomCenter,
//               child: Stack(
//                 children: <Widget>[
//                   Container(child: buildMeetingView(context)),
// //                  SingleChildScrollView(
// //                    child: Column(
// //                      crossAxisAlignment: CrossAxisAlignment.stretch,
// //                      children: <Widget>[
// //
// //
// //                      ],
// //                    ),
// //                  ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget buildMeetingView(BuildContext context) {
//     RibbonLocation location = RibbonLocation.topEnd;
//     double nearLength = 50;
//     double farLength = 70;
//     return FutureBuilder<MeetingListModel>(
//         future: _getMyMeetingData(),
//         builder:
//             (BuildContext context, AsyncSnapshot<MeetingListModel> snapshot) {
//           print('snapshot data ${snapshot.data}');
//           if (!snapshot.hasData) {
//             return const SizedBox(
//               child: Padding(
//                 padding: const EdgeInsets.all(
//                   8.0,
//                 ),
//                 child: Center(child: CircularProgressIndicator()),
//               ),
//             );
//           } else {
//             return Align(
//               alignment: Alignment.topLeft,
//               child: ListView.builder(
//                 itemCount: snapshot.data.data.length,
//                 shrinkWrap: true,
//                 itemBuilder: (BuildContext context, int index) {
//                   print('index $index');
//                   return Container(
//                     padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
//                     height: 260,
//                     child: Card(
//                       elevation: 5,
//                       shadowColor: Colors.black,
//                       child: Container(
//                         padding: EdgeInsets.all(
//                           10.0,
//                         ),
//                         // margin: EdgeInsets.all(
//                         //   10.0,
//                         // ),
//                         height: 180,
//                         child: Column(
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Column(
//                                     children: [
//                                       Text(
//                                         'Duration',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyText1
//                                             .copyWith(
//                                               color: Colors.blueGrey,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 15,
//                                             ),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         snapshot.data.data[index].duration
//                                             .toString(),
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyText1
//                                             .copyWith(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 15,
//                                             ),
//                                       ),
//                                     ],
//                                   ),
//                                   Column(
//                                     children: [
//                                       Text(
//                                         'Start Time',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyText1
//                                             .copyWith(
//                                               color: Colors.blueGrey,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 15,
//                                             ),
//                                       ),
//                                       SizedBox(
//                                         height: 5,
//                                       ),
//                                       Text(
//                                         // DateFormat.yMd('en_IN').add_jm().format(DateTime.parse(snapshot
//                                         //         .data.data[index].startTime)),
//                                         formatter.format(DateTime.parse(snapshot
//                                             .data.data[index].startTime).toLocal()),
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodyText1
//                                             .copyWith(
//                                               color: Colors.black,
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 15,
//                                             ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Column(
//                                 children: [
//                                   Text(
//                                     'Topic',
//                                     softWrap: true,
//                                     maxLines: 3,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyText1
//                                         .copyWith(
//                                           color: Colors.blueGrey,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 15,
//                                         ),
//                                   ),
//                                   SizedBox(
//                                     height: 5,
//                                   ),
//                                   Text(
//                                     snapshot.data.data[index].topic
//                                         .toString(),
//                                     maxLines: 2,
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .bodyText1
//                                         .copyWith(
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: 15,
//                                         ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               margin: EdgeInsets.only(top: 24.0),
//                               child: FlatButton(
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(4.0),
//                                 ),
//                                 color: UtilsData.kDarkBlue,
//                                 onPressed: () async {
//                                   SharedPreferences preferences =
//                                       await SharedPreferences.getInstance();
//                                   print('user id ${preferences.getString(
//                                       UtilsData.kPrefNameKey)}');
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => MeetingWidget(
//                                               meetingId: snapshot
//                                                   .data.data[index].id
//                                                   .toString(),
//                                               meetingPassword: '',
//                                               userId: preferences.getString(
//                                                   UtilsData.kPrefNameKey))));
//                                   // MaterialPageRoute(builder: (context) =>
//                                   //     MeetingList())),
//                                   print('call');
//                                 },
//                                 child: Container(
//                                   padding: EdgeInsets.symmetric(
//                                     vertical: 15.0,
//                                     horizontal: 10.0,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: <Widget>[
//                                       Expanded(
//                                         child: Text(
//                                           'Start Learning',
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                               color: Colors.white,
//                                               fontWeight: FontWeight.bold),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             );
//           }
//         });
//   }
//
//   Widget _appBar() {
//     return SizedBox(
//       height: AppBar().preferredSize.height,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: <Widget>[
//           Padding(
//             padding: const EdgeInsets.only(top: 8, left: 8),
//             child: Container(
//               width: AppBar().preferredSize.height - 8,
//               height: AppBar().preferredSize.height - 8,
//               child: IconButton(
//                   icon: Icon(
//                     Icons.arrow_back_ios,
//                     color: AppTheme.darkText,
//                   ),
//                   onPressed: () => Navigator.of(context).push(MaterialPageRoute(
//                       builder: (context) => NavigationHomeScreen()))),
//             ),
//           ),
//           Expanded(
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 4),
//                 child: Text(
//                   'Live Lectures',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontFamily: UtilsData.kProximaFontName,
//                     color: AppTheme.darkText,
//                     fontWeight: FontWeight.w900,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 8, right: 8),
//             child: Container(
//               width: AppBar().preferredSize.height - 8,
//               height: AppBar().preferredSize.height - 8,
//               color: Colors.white,
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius:
//                       BorderRadius.circular(AppBar().preferredSize.height),
//                   child: Icon(
//                     Icons.dashboard,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<MeetingListModel> _getMyMeetingData() async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//
//       final response = await http.get(
//       UtilsData.kBaseUrl+UtilsData.kGetMeetingListMethod,
//         headers: <String, String>{
//           UtilsData.kHeaderType: UtilsData.kHeaderValue,
//           UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
//         },
//       );
//
//       // final response = await http.get(
//       //   'https://api.zoom.us/v2/users/s.v.jakhaniya@gmail.com/meetings',
//       //   headers: <String, String>{
//       //     'Authorization':
//       //         'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOm51bGwsImlzcyI6InZQR182TjhWUkRhR29xN1NLdUFINUEiLCJleHAiOjE2MTA2NDMyMjYsImlhdCI6MTYxMDAzNzczNX0.0w0geCHpghTMvQF8wEKveDsTLfq-5WXYZpE_wH9X_uc',
//       //     // UtilsData.kHeaderType: UtilsData.kHeaderValue,
//       //     // UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
//       //   },
//       // );
//       var responseData = jsonDecode(response.body);
//       print(
//           'response of meeting list $responseData and status code ${response.statusCode}');
//       if (response.statusCode == 200) {
//         return MeetingListModel.fromJson(jsonDecode(response.body));
//       } else if (response.statusCode == 401) {
//         AwesomeDialog(
//           context: context,
//           dialogType: DialogType.WARNING,
//           animType: AnimType.BOTTOMSLIDE,
//           title: UtilsData.kOops,
//           desc: UtilsData.kMultiLoginMsg,
//           btnCancel: null,
//           dismissOnBackKeyPress: false,
//           dismissOnTouchOutside: false,
//           btnOkOnPress: () {
//             preferences.clear();
//             exit(0);
//           },
//         )..show();
//       } else {
//         AwesomeDialog(
//           context: context,
//           dialogType: DialogType.ERROR,
//           animType: AnimType.BOTTOMSLIDE,
//           title: 'No Data',
//           desc: responseData[UtilsData.kResponseErrorMessage],
//           btnCancelOnPress: () {
//             Navigator.of(context).pop();
//           },
//           btnOkOnPress: () {
//             Navigator.of(context).pop();
//           },
//         )..show();
//       }
//     } catch (exception) {
//       return throw Exception(exception.toString());
//     }
//   }
// }
