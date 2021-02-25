import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';

import 'navigation_home_screen.dart';

class SelectBoard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UtilsData.kWhite,
      body: BoardData(),
    );
  }
}

class BoardData extends StatefulWidget {
  @override
  _BoardDataState createState() => _BoardDataState();
}

class _BoardDataState extends State<BoardData> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _appBar(),
          Expanded(child: _body()),
        ],
      ),
    );
  }

  Widget _body() {
    return Container(
      color: AppTheme.notWhite,
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '1. ${UtilsData.kSelectGrade}',
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              _choiceChip(selection: _selected, text: '12th'),
              _choiceChip(selection: _selected, text: '11th'),
              _choiceChip(selection: _selected, text: '10th'),
              _choiceChip(selection: _selected, text: '09th'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _choiceChip(selection: _selected, text: '08th'),
              _choiceChip(selection: _selected, text: '07th'),
              _choiceChip(selection: _selected, text: '06th'),
              _choiceChip(selection: _selected, text: '05th'),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _choiceChip(selection: _selected, text: '04th'),
              _choiceChip(selection: _selected, text: '03th'),
              _choiceChip(selection: _selected, text: '02th'),
              _choiceChip(selection: _selected, text: '01th'),
            ],
          )
        ],
      ),
    );
  }

  Widget _choiceChip({String text, bool selection}) {
    return FilterChip(
      selected: selection,
      selectedColor: Theme.of(context).accentColor,
      label: Text(text),
      labelStyle: TextStyle(
          color: Colors.black, letterSpacing: 2.0, fontWeight: FontWeight.w500),
      backgroundColor: Colors.white,
      shadowColor: AppTheme.notWhite,
      padding: EdgeInsets.all(8.0),
      elevation: 10.0,
      onSelected: (bool selected) {
        print('select');
        setState(() {
          selection = !selection;
        });
      },
    );
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
                    color: AppTheme.white,
                  ),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => NavigationHomeScreen()))),
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  UtilsData.kBoardTitle,
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
}
