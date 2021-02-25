import 'package:contactus/contactus.dart';
import 'package:flutter/material.dart';
import 'package:virtual_dukan/utils_data/app_theme.dart';
import 'package:virtual_dukan/utils_data/utilsData.dart';

import 'navigation_home_screen.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UtilsData.kWhite,
      bottomNavigationBar: ContactUsBottomAppBar(
        companyName: UtilsData.kAppName,
        textColor: Colors.white,
        backgroundColor: Colors.teal.shade300,
        email: 'virtualdukan@gmail.com',
      ),
      body: ContactInfo(),
    );
  }
}

class ContactInfo extends StatefulWidget {
  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => NavigationHomeScreen()));
      },
      child: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
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
                          onPressed: () => Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) =>
                                      NavigationHomeScreen()))),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          UtilsData.kAboutUs,
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
                          borderRadius: BorderRadius.circular(
                              AppBar().preferredSize.height),
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
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                child: ContactUs(
                  cardColor: Colors.white,
                  textColor: Colors.teal.shade900,
//                logo: AssetImage(UtilsData.kLogo),
                  image: Image.asset(
                    UtilsData.kPlayStore,
                    width: 100,
                    height: 150,
                  ),
                  email: 'virtualdukan@gmail.com.com',
                  emailText: 'virtualdukan@gmail.com',
                  companyName: '',
                  companyColor: Colors.white,
                  companyFontSize: 18,
                  phoneNumber: '+918980808118',
                  phoneNumberText: '+918980808118',
                  website: 'http://www.nursery2career.com/',
                  websiteText: 'http://www.nursery2career.com/',
//                tagLine: 'Flutter Developer',
                  taglineColor: Colors.teal.shade100,
//                twitterHandle: 'Vir',
//                instagram: '_abhishek_doshi',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
