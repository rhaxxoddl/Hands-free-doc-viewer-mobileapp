import 'package:flutter/material.dart';

class PreferenceProvider with ChangeNotifier {
  int _page_scroll_speed = 400;
  int _eye_tracking_delay = 1000;
  int get PAGE_SCROLL_SPEED => _page_scroll_speed;
  int get EYE_TRACKING_DELAY => _eye_tracking_delay;

  void changePageScrollSpeed(int value) {
    _page_scroll_speed = value;
    debugPrint("Change Page Scroll Speed: ${_page_scroll_speed}");
    notifyListeners();
  }

  void changeEyeTrackingDelay(int value) {
    _eye_tracking_delay = value;
    notifyListeners();
  }
}
