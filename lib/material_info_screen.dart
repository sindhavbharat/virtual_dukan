import 'dart:convert';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'design_course/design_course_app_theme.dart';
import 'design_course/models/material_details.dart';

class MaterialInfoScreen extends StatefulWidget {
  final AsyncSnapshot<MaterialDetailList> snapshot;
  final int index;

  MaterialInfoScreen(this.snapshot, this.index);

  @override
  _MaterialInfoScreenState createState() => _MaterialInfoScreenState();
}

class _MaterialInfoScreenState extends State<MaterialInfoScreen>
    with TickerProviderStateMixin {
  VideoPlayerController videoPlayerController;
  ChewieController chewieController;
  final videoInfo = FlutterVideoInfo();
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  final DateFormat formatter = DateFormat('dd-MMM-yyyy hh:mm a');
  String videoId = '';
  double aspectRatio;
  bool isVisibleInfo;

//  static Random rnd = new Random();
//  static var lst = [Alignment.bottomLeft,Alignment.centerLeft,Alignment.center,Alignment.topRight,Alignment.topLeft,Alignment.topCenter,Alignment.bottomCenter,Alignment.bottomRight,Alignment.centerRight];
//  static var element;

  String useName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  YoutubePlayerController _controller;
  TextEditingController _idController;
  TextEditingController _seekToController;

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if (!videoId.contains('103.20.212.53')) {
      _controller.dispose();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
//      _idController.dispose();
//      _seekToController.dispose();
    } else {
      videoPlayerController.dispose();
      chewieController.dispose();
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  Future<void> secureScreen() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      useName = preferences.getString(UtilsData.kPrefNameKey);
    });

    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void initState() {
//    element=lst[rnd.nextInt(lst.length)];
//    print('index ${widget.index}');
//    print('random align $element');
    aspectRatio = 1.2;
    isVisibleInfo = true;
    print(
        'video link ${widget.snapshot.data.course.videos[widget.index].videoUrl}');
    if (widget.snapshot.data.course.videos[widget.index].videoUrl
        .contains('103.20.212.53')) {
      videoId = widget.snapshot.data.course.videos[widget.index].videoUrl;
    } else {
      videoId = YoutubePlayer.convertUrlToId(
          widget.snapshot.data.course.videos[widget.index].videoUrl);
    }
    print('video url $videoId');
    secureScreen();
    if (videoId.contains('103.20.212.53')) {
      videoPlayerController = VideoPlayerController.network(
        widget.snapshot.data.course.videos[widget.index].videoUrl,);
      chewieController = ChewieController(
        videoPlayerController: videoPlayerController,
        allowedScreenSleep: false,
        allowFullScreen: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        aspectRatio: 3 / 2,
        autoInitialize: true,
        autoPlay: true,
        showControls: true,
        looping: true,
      );
      chewieController.addListener(() {
        if (chewieController.isFullScreen) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
          ]);
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        }
      });
    } else {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: true,
          isLive: false,
          forceHD: false,
          enableCaption: true,
        ),
      );

      _videoMetaData = const YoutubeMetaData();
      _playerState = PlayerState.unknown;
    }

    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    getData();
    super.initState();
  }

  Future<void> getData() async {
//    _progressDialog.setMessage(UtilsData.kLoadingMsg);
//    _progressDialog.show();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    print('token ${preferences.getString(UtilsData.kToken)}');
    final response = await http.post(
      UtilsData.kBaseUrl + UtilsData.kVisitorMethod,
      headers: <String, String>{
        UtilsData.kHeaderType: UtilsData.kHeaderValue,
        UtilsData.kAuthorization: preferences.getString(UtilsData.kToken),
      },
      body: jsonEncode(
        <String, String>{
          'type': 'video',
          'visited_id': widget.snapshot.data.course.videos[widget.index].id
              .toString(),
          'institute_id': widget.snapshot.data.course.instituteId.toString(),
        },
      ),
    );

    var _responseData = jsonDecode(response.body);
    print('response of visitor $_responseData');
//      _progressDialog.hide();
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    if (!videoId.contains('103.20.212.53')) {
      _controller.pause();
    }

    super.deactivate();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double tempHeight = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).size.width / 1.2) +
        24.0;
    double different = double.parse(widget.snapshot.data.course.mrpPrice) -
        double.parse(widget.snapshot.data.course.salePrice);
    different =
        different * 100 / double.parse(widget.snapshot.data.course.mrpPrice);
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Flexible(
                  child: AspectRatio(
                    aspectRatio: aspectRatio,
                    child: videoId.contains('103.20.212.53')
                        ? Chewie(
                      controller: chewieController,
                    )
                        : Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: YoutubePlayerBuilder(
                        onExitFullScreen: () {
                          setState(() {
                            isVisibleInfo = true;
                            aspectRatio = 1.2;
                          });
                          // The player forces portraitUp after exiting fullscreen. This overrides the behaviour.
                          SystemChrome.setPreferredOrientations(
                              DeviceOrientation.values);
                        },
                        onEnterFullScreen: () {
                          setState(() {
                            isVisibleInfo = false;
                            aspectRatio = 16 / 9;
                          });
                          SystemChrome.setPreferredOrientations([
                            DeviceOrientation.landscapeRight,
                            DeviceOrientation.landscapeLeft,
                          ]);
                        },
                        player: YoutubePlayer(
                          controller: _controller,
                          aspectRatio: 3 / 2,
                          actionsPadding: EdgeInsets.all(10.0),
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.blueAccent,
//                            topActions: <Widget>[
//                              Expanded(
//                                child: Text(
//                                  _controller.metadata.title,
//                                  style: const TextStyle(
//                                    color: Colors.white,
//                                    fontSize: 18.0,
//                                  ),
//                                  overflow: TextOverflow.ellipsis,
//                                  maxLines: 1,
//                                ),
//                              ),
//                            ],
                          onReady: () {
                            _controller.addListener(listener);
                          },
                        ),
                        builder: (context, player) =>
                            Scaffold(
                              key: _scaffoldKey,
                            ),
                      ),
                    ),
                  ),
                ),
//                Positioned(
//                  top: 50,
//                  child: Text('Bharat Sindhav',style: TextStyle(color: Colors.green,fontWeight: FontWeight.w900),),
//                )
              ],
            ),
            Positioned(
                top: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    useName ?? '',
                    style: TextStyle(color: Colors.blue),
                  ),
                )),
//            AspectRatio(
//              aspectRatio: aspectRatio,
//              child: Align(
//                alignment: element,
//                child: Padding(
//                  padding: const EdgeInsets.all(10.0),
//                  child: Text(
//                    useName ?? '',
//                    style: TextStyle(color: Colors.blue),
//                  ),
//                ),
//              ),
//            ),
            Visibility(
              visible: isVisibleInfo,
              child: Positioned(
                top: (MediaQuery
                    .of(context)
                    .size
                    .width / 1.2) - 24.0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: DesignCourseAppTheme.nearlyWhite,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(32.0),
                        topRight: Radius.circular(32.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: DesignCourseAppTheme.grey.withOpacity(0.2),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Container(
                      constraints: BoxConstraints(
                          minHeight: infoHeight,
                          maxHeight: tempHeight > infoHeight
                              ? tempHeight
                              : infoHeight),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 32.0, left: 18, right: 16),
                              child: Text(
                                widget.snapshot.data.course.videos[widget.index]
                                    .title,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 22,
                                  letterSpacing: 0.27,
                                  color: DesignCourseAppTheme.darkerText,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 16, right: 16, bottom: 8, top: 16),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        widget.snapshot.data.course
                                            .typeOfCourse ==
                                            'free'
                                            ? ''
                                            : '\₹${widget.snapshot.data.course
                                            .mrpPrice}',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 16,
                                          letterSpacing: 0.27,
                                          color: DesignCourseAppTheme.grey,
                                          decoration:
                                          TextDecoration.lineThrough,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        widget.snapshot.data.course
                                            .typeOfCourse ==
                                            'free'
                                            ? 'Free'
                                            : '\₹${widget.snapshot.data.course
                                            .salePrice}(${different
                                            .toStringAsFixed(2)}%)',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 22,
                                          letterSpacing: 0.27,
                                          color:
                                          DesignCourseAppTheme.nearlyBlue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          '4.3',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w200,
                                            fontSize: 22,
                                            letterSpacing: 0.27,
                                            color: DesignCourseAppTheme.grey,
                                          ),
                                        ),
                                        Icon(
                                          Icons.star,
                                          color:
                                          DesignCourseAppTheme.nearlyBlue,
                                          size: 24,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
//                          Padding(
//                            padding: const EdgeInsets.only(
//                                left: 16, right: 16, bottom: 8, top: 16),
//                            child: Row(
//                              mainAxisAlignment: MainAxisAlignment.start,
//                              children: <Widget>[
//                                Icon(
//                                  Icons.access_time,
//                                  color: FintnessAppTheme.grey.withOpacity(0.5),
//                                  size: 16,
//                                ),
//                                Padding(
//                                  padding: const EdgeInsets.only(left: 4.0),
//                                  child: Text(
//                                    formatter.format(DateTime.parse(
//                                        widget.snapshot.data.course.createdAt)),
//                                    textAlign: TextAlign.center,
//                                    style: TextStyle(
//                                      fontFamily: FintnessAppTheme.fontName,
//                                      fontWeight: FontWeight.w500,
//                                      fontSize: 14,
//                                      letterSpacing: 0.0,
//                                      color: FintnessAppTheme.grey
//                                          .withOpacity(0.5),
//                                    ),
//                                  ),
//                                ),
//                              ],
//                            ),
//                          ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity1,
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Wrap(
                                  children: <Widget>[
                                    getTimeBoxUI(
                                      widget.snapshot.data.course.standardName,
                                      'Std',
                                    ),
                                    getTimeBoxUI(
                                      widget.snapshot.data.course.boardName,
                                      'Board',
                                    ),
                                    getTimeBoxUI(
                                      widget.snapshot.data.course.mediumName,
                                      'Medium',
                                    ),
                                    getTimeBoxUI(
                                      widget.snapshot.data.course.streamName,
                                      'Stream',
                                    ),
                                    getTimeBoxUI(
                                      widget.snapshot.data.course.videos.length
                                          .toString(),
                                      'Videos',
                                    )
                                  ],
                                ),
                              ),
                            ),
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 500),
                              opacity: opacity2,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, top: 8, bottom: 8),
                                child: Text(
                                  widget.snapshot.data.course.description,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w200,
                                    fontSize: 14,
                                    letterSpacing: 0.27,
                                    color: DesignCourseAppTheme.grey,
                                  ),
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 500),
                                opacity: opacity3,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, bottom: 16, right: 16),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width: 48,
                                        height: 48,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: DesignCourseAppTheme
                                                .nearlyWhite,
                                            borderRadius:
                                            const BorderRadius.all(
                                              Radius.circular(16.0),
                                            ),
                                            border: Border.all(
                                                color: DesignCourseAppTheme.grey
                                                    .withOpacity(0.2)),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color:
                                            DesignCourseAppTheme.nearlyBlue,
                                            size: 28,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 16,
                                      ),
                                      Expanded(
                                        child: Container(
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color:
                                            DesignCourseAppTheme.nearlyBlue,
                                            borderRadius:
                                            const BorderRadius.all(
                                              Radius.circular(16.0),
                                            ),
                                            boxShadow: <BoxShadow>[
                                              BoxShadow(
                                                  color: DesignCourseAppTheme
                                                      .nearlyBlue
                                                      .withOpacity(0.5),
                                                  offset:
                                                  const Offset(1.1, 1.1),
                                                  blurRadius: 10.0),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Purchase Course',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                letterSpacing: 0.0,
                                                color: DesignCourseAppTheme
                                                    .nearlyWhite,
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
                            SizedBox(
                              height: MediaQuery
                                  .of(context)
                                  .padding
                                  .bottom,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: Positioned(
                top: (MediaQuery.of(context).size.width / 1.2) - 24.0 - 35,
                right: 35,
                child: ScaleTransition(
                  alignment: Alignment.center,
                  scale: CurvedAnimation(
                      parent: animationController, curve: Curves.fastOutSlowIn),
                  child: Card(
                    color: DesignCourseAppTheme.nearlyBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0)),
                    elevation: 10.0,
                    child: Container(
                      width: 60,
                      height: 60,
                      child: Center(
                        child: Icon(
                          Icons.favorite,
                          color: DesignCourseAppTheme.nearlyWhite,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
//            Padding(
//              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
//              child: SizedBox(
//                width: AppBar().preferredSize.height,
//                height: AppBar().preferredSize.height,
//                child: Material(
//                  color: Colors.transparent,
//                  child: InkWell(
//                    borderRadius:
//                        BorderRadius.circular(AppBar().preferredSize.height),
//                    child: Icon(
//                      Icons.arrow_back_ios,
//                      color: DesignCourseAppTheme.nearlyBlack,
//                    ),
//                    onTap: () {
//                      Navigator.pop(context);
//                    },
//                  ),
//                ),
//              ),
//            )
          ],
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: DesignCourseAppTheme.nearlyWhite,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: DesignCourseAppTheme.grey.withOpacity(0.2),
                offset: const Offset(1.1, 1.1),
                blurRadius: 8.0),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                text1,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.nearlyBlue,
                ),
              ),
              Text(
                txt2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w200,
                  fontSize: 14,
                  letterSpacing: 0.27,
                  color: DesignCourseAppTheme.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
