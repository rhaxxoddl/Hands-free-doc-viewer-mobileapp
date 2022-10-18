import 'package:flutter/material.dart';

class PreferenceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: null, // 여기에 설정 페이지로 이동하는 이벤트 붙이기
      icon: const Icon(Icons.settings),
    );
  }
}
