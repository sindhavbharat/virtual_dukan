import 'package:flutter/material.dart';
import 'package:virtual_dukan/screens/navigation_home_screen.dart';
import 'package:virtual_dukan/screens/select_board.dart';
import 'package:virtual_dukan/utils_data/codeinput.dart';
import 'package:virtual_dukan/utils_data/progressdialog.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';

class VerificationScreen extends StatefulWidget {
  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  ProgressDialog pr;
  @override
  Widget build(BuildContext context) {
    pr = new ProgressDialog(context, ProgressDialogType.Normal);
    pr.setMessage(UtilsData.kVerifyingAccount);
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 96.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Text(UtilsData.kEmailVerification,
                      style: Theme.of(context).textTheme.title),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 48.0),
                  child: Text(
                    UtilsData.kEnterYourOtpHere,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 64.0),
                  child: CodeInput(
                    length: 4,
                    keyboardType: TextInputType.number,
                    builder: CodeInputBuilders.darkCircle(),
                    onFilled: (value) async {
                      print('Your input is $value.');
                      pr.show();
                      Future.delayed(const Duration(milliseconds: 1500), () {
                        setState(() {
                          pr.hide();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
                          );
                        });
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    UtilsData.kNotReceiveOtp,
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ),
                GestureDetector(
                  onTap: () => {
//                    Navigator.pushReplacement(
//                      context,
//                      MaterialPageRoute(builder: (context) => Home()),
//                    ),
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      UtilsData.kResendNewOtp,
                      style: TextStyle(
                        fontSize: 19,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
