import 'package:flutter/material.dart';
import '../page/preference_page.dart';

class PreferenceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PreferencePage()))
      }, // 여기에 설정 페이지로 이동하는 이벤트 붙이기
      icon: const Icon(Icons.settings),
    );
  }
}
