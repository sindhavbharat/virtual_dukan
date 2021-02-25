import 'package:virtual_dukan/utils_data/utilsData.dart';

class Category {
  Category({
    this.title = '',
    this.thumbnail = '',
    this.subTitle = '',
    this.description = '',
  });

  String title;
  String thumbnail;
  String subTitle;
  String description;

  static List<Category> categoryList = <Category>[
    Category(
      thumbnail: '${UtilsData.kImageDir}/interFace1.png',
      title: 'User interface Design',
//      lessonCount: 24,
//      money: 250,
//      rating: 4.3,
    ),
    Category(
//      imagePath: '${UtilsData.kImageDir}/interFace2.png',
      title: 'User interface Design',
//      lessonCount: 22,
//      money: 180,
//      rating: 4.6,
    ),
    Category(
//      imagePath: '${UtilsData.kImageDir}/interFace1.png',
      title: 'User interface Design',
//      lessonCount: 24,
//      money: 200,
//      rating: 4.3,
    ),
    Category(
//      imagePath: '${UtilsData.kImageDir}/interFace2.png',
      title: 'User interface Design',
//      lessonCount: 22,
//      money: 180,
//      rating: 4.6,
    ),
  ];

  static List<Category> popularCourseList = <Category>[
    Category(
//      imagePath: '${UtilsData.kImageDir}/interFace3.png',
      title: 'App Design Course',
//      lessonCount: 12,
//      money: 25,
//      rating: 4.8,
    ),
    Category(
//      imagePath: '${UtilsData.kImageDir}/interFace4.png',
      title: 'Web Design Course',
//      lessonCount: 28,
//      money: 208,
//      rating: 4.9,
    ),
    Category(
//      imagePath: '${UtilsData.kImageDir}/interFace3.png',
      title: 'App Design Course',
//      lessonCount: 12,
//      money: 25,
//      rating: 4.8,
    ),
    Category(
//      imagePath: '${UtilsData.kImageDir}/interFace4.png',
      title: 'Web Design Course',
//      lessonCount: 28,
//      money: 208,
//      rating: 4.9,
    ),
  ];
}
