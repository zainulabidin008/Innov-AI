import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

import '../../constants/app_assets.dart';

class IntroController extends GetxController {
  RxInt carouselIndex = 0.obs;
  CarouselController carouselController = CarouselController();
  var sliderItems = [
    AppAssets.intro1_img,
    AppAssets.intro2_img,
    AppAssets.intro3_video,
  ];
}
