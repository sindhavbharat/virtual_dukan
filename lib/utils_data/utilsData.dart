import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'app_theme.dart';

class UtilsData {
  // BaseUrl and methods

  static const kBaseUrl = 'http://teachers.virtualabhyas.com/api/auth/';
  static const kLoginMethod = 'login';
  static const kRegisterMethod = 'register';
  // static const kFilterDataMethod = 'filter-data';
  static const kFilterDataMethod = 'filter-product-data';
  static const kSocialLoginMethod = 'social-login';
  static const kSocialGoogleProvide = 'google';
  static const kSocialFacebookProvide = 'facebook';
  static const kRegisterOtpConfirmationMethod = 'otp-confirmation';
  static const kLoggedUserInformationMethod = 'user';
  static const kForgotPasswordMethod = 'forgot-password';
  static const kChangePasswordMethod = 'change-password';
  static const kForPassword = 'Forgot Password';
  static const kChangePassword = 'Change Password';
  static const kResetPasswordMethod = 'reset-password';
  static const kUpdateProfileMethod = 'update-profile';
  static const kGetCourseListMethod = 'course-lists';
  static const kGetUserInformationMethod = 'user';
  static const kGetStreamDataMethod = 'streams-lists';
  static const kGetMeetingListMethod = 'zoom-meetings';
  static const kGetMediumMethod = 'mediums-lists';
  static const kGetStandardDataMethod = 'standards-lists';
  static const kGetBoardDataMethod = 'boards-lists';
  static const kCartTitleName = 'My Cart';
  static const kGetInstitutesListMethod = 'institute-lists';
  static const kGetMaterialListMethod = 'material-lists';
  static const kGetStationaryListMethod = 'stationary-lists';
  static const kGetGSEBListMethod = 'gseb-products-lists';
  static const kGetEnglishMediumListMethod = 'english-medium-products-lists';
  static const kGetGujaratiMediumListMethod = 'gujarati-medium-products-lists';
  static const kGetCommonListMethod = 'common-products-lists';
  static const kGetCBSEListMethod = 'cbse-products-lists';
  static const kGetVideoListMethod = 'course-video-lists';
  static const kMaterialDetailsMethod = 'material-detail';
  static const kVisitorMethod = 'visitor';
  static const kAdvertisementMethod = 'advertisement-lists';
  static const kPlaceOrderMethod = 'place-order';
  static const kMyOrderMethod = 'my-order';
  static const kPublisherMethod = 'publisher-lists';
  static const kCourseDetailsMethod = 'course-detail';
  static const kAddCartMethod = 'add-to-cart/';
  static const kGetCartItemMethod = 'cart-items';
  static const kRemoveCartItemMethod = 'remove-to-cart/';
  static const kGetChargesMethod = 'cart-setting';
  static const kIncrementMethod = 'cart-item-increment';
  static const kDeIncrementMethod = 'cart-item-decrement';
  static const kInstitutesDetailsMethod = 'institute-detail';
  static const kGetProductListMethod='products-lists';
  static const kStationaryDetailsMethod = 'stationary-detail';
  static const kProductDetailsMethod = 'product-detail';
  static const kHeaderType = 'Content-Type';
  static const kHeaderValue = 'application/json';
  static const kAuthorization = 'Authorization';
  static const kResponseErrorMessage = 'message';
  static const kToken = 'token';
  static const kPrefMobileKey = 'mobile';
  static const kStationary = 'Stationary';
  static const kPrefNameKey = 'name';
  static const kPrefEmailKey = 'email';
  static const kPrefProfileKey = 'profile_image';
  static const kPrefFacebookKey = 'facebook_key';
  static const kPrefProvider = 'provider';
  static int kCount = 0;

  // Secure data

  static const kMerchantId = '6536519';
  static const kMerchantKey = 'nOOPiuYR';
  static const kSaltKey = 'ujstoEekBB';

  // Images
  static const kImageDir = 'assets/images';
  static const kAdv1 = '$kImageDir/adv_1.png';
  static const kAdv2 = '$kImageDir/adv_2.png';
  static const kAdv3 = '$kImageDir/adv_3.png';
  static const kImageLiveClass = '$kImageDir/live_class.png';
  static const kEmptyImageDir = '$kImageDir/empty_cart.png';
  static const kImageOne = '$kImageDir/image_01.png';
  static const kImageTwo = '$kImageDir/image_02.png';
  static const kLogo = '$kImageDir/app_icon.png';
  static const kRemoveCart = '$kImageDir/remove_cart.png';
  static const kDeleteCart = '$kImageDir/delete.png';
  static const kPlayStore = '$kImageDir/playstore.png';
  static const kNoDataImageDir = '$kImageDir/download.png';

  // Fonts
  static const kCustomIconsFonts = 'CustomIcons';
  static const kPoppinsBoldFonts = 'Poppins-Bold';
  static const kPoppinsMediumFonts = 'Poppins-Medium';

  // Strings
  static const kAppName = 'Nursery2career EduTech Pvt Ltd';
  static const kLogin = 'Login';
  static const kEmail = 'Email';
  static const kAboutUs = 'About Us';
  static const kUserNameHint = 'username';
  static const kPasswordHint = 'password';
  static const kPassword = 'Password';
  static const kNewPassword = 'New Password';
  static const kConfirmPassword = 'Confirm Password';
  static const kForgotPassword = 'Forgot Password?';
  static const kNewUser = 'New User? ';
  static const kSignUp = 'SignUp';
  static const kSignOut = 'Sign Out';
  static const kOops = 'Oops...';
  static const kMultiLoginMsg = 'Your Login is used in another device..';
  static const kExit = 'Exit?';
  static const kExitMsg = 'Do you want to exit an app?';
  static const kSocialLogin = 'Social Login';
  static const kRememberMe = 'Remember me';
  static const kSignIn = 'SIGNIN';
  static const kLoginLoadingMsg = 'Logging in...';
  static const kLogoutLoadingMsg = 'Logging out...';
  static const kLoadingMsg = 'Loading...';
  static const kVerifyingOtp = 'Verify Otp...';
  static const kVerifyingAccount = 'Verifying account...';
  static const kSuccess = 'Success';
  static const kInvalidCredentials = 'Please Enter Valid Credentials';
  static const kEmailVerification = 'Email Verification';
  static const kEnterYourOtpHere = 'Enter your otp here';
  static const kNotReceiveOtp = 'Didn\'t you received any otp?';
  static const kResendNewOtp = 'Resend new otp';
  static const kSignOutMsg = 'Are you sure want exit?';
  static const kAddToCart = 'Add To Cart';
  static const kDashboard = 'Your Learning Buddy';
  static const kUserRegistration = 'User Registration';
  static const kUpdateProfile = 'Update Profile';
  static const kName = 'Name';
  static const kPinCode = 'Pin Code';
  static const kHomeAddress = 'Full Address With Area';
  static const kAddress2 = 'Address2';
  static const kDob = 'Date Of Birth';
  static const kAddress = 'Address';
  static const kCity = 'City';
  static const kMobile = 'Mobile';
  static const kSelectBoard = 'Select Board';
  static const kSelectGrade = 'Select Grade';
  static const kBoardTitle = 'Help us find classroom of you';
  static const kPunchLine = 'Punch Line';
  static const kBoard = 'Board';
  static const kStandard = 'Standard';
  static const kStream = 'Stream';
  static const kMedium = 'Medium';
  static const kRegister = 'REGISTRATION';
  static const kError = 'Error';
  static const kErrorHey = 'Hey';
  static const kErrorPurchaseCourse = 'Purchase & Start Learning';
  static const kEnterOtp = 'Enter OTP';
  static const kOtpSentMsg = 'OTP Send Your MailId';
  static const kSuccessRegistration = 'Student Registration Successfully';

  // ErrorMsg
  static const kUserNameErrorMsg = 'Please Enter Username';
  static const kPasswordErrorMsg = 'Please Enter Password';
  static const kValidateName = 'Please Enter Name';
  static const kValidateAddress = 'Please Enter Home Address';
  static const kValidateAddress1 = 'Please Enter Address1';
  static const kValidatePinCode = 'Please Enter PinCode';
  static const kValidateMobile = 'Please Enter Mobile';
  static const kValidateCity = 'Please Enter City';
  static const kValidateEmail = 'Please Enter Email';
  static const kValidateEmailAddress = 'Please Enter Valid Email';
  static const kValidatePassword = 'Please Enter Password';
  static const kValidateConfirmPassword = 'Please Enter Confirm Password';
  static const kValidSamePassword = 'Both Password Must Be Same';
  static const String kProximaFontName = 'Proxima';

  // Colors
  static const kBlue = Colors.blue;
  static const kGrey = Colors.grey;
  static const kWhite = Colors.white;
  static const kBlack12 = Colors.black12;
  static const kDarkBlue = Color(0xff00008b);

  //Common Methods
  static AwesomeDialog kErrorDialog({BuildContext context, String errorMsg}) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.ERROR,
      animType: AnimType.BOTTOMSLIDE,
      title: kError,
      desc: errorMsg,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    )..show();
  }

  static InputDecoration kTextDecoration({String filedName}) {
    return InputDecoration(
        labelText: filedName,
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ));
  }

  static Widget kAppBar({BuildContext context, String title}) {
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
                  title,
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

  static AwesomeDialog kSuccessDialog(
      {BuildContext context, String successMsg}) {
    return AwesomeDialog(
      context: context,
      dialogType: DialogType.SUCCES,
      animType: AnimType.BOTTOMSLIDE,
      title: kSuccess,
      desc: successMsg,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    )..show();
  }

  static focusChange(
      {BuildContext context, FocusNode currentFocus, FocusNode nextFocus}) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
