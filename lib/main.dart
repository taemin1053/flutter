import 'package:flutter/material.dart'; // Flutter UI 요소 사용을 위한 패키지
import 'package:start5_2/const/colors.dart'; // 색상 상수 가져오기
import 'package:start5_2/screen/root_screen.dart'; // 루트 화면 가져오기

// 앱의 진입점
void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 숨기기
      theme: ThemeData(
        scaffoldBackgroundColor: backgroundColor, // 전체 배경 색상 설정
        sliderTheme: SliderThemeData(
          thumbColor: primaryColor, // 슬라이더의 thumb 색상
          activeTrackColor: primaryColor, // 활성화된 슬라이더 트랙 색상
          inactiveTrackColor: primaryColor.withOpacity(0.3), // 비활성화된 슬라이더 트랙 색상 (투명도 적용)
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: primaryColor, // 선택된 아이템 색상
          unselectedItemColor: secondaryColor, // 선택되지 않은 아이템 색상
          backgroundColor: backgroundColor, // 하단 내비게이션 바의 배경 색상
        ),
      ),
      home: RootScreen(), // 앱의 첫 번째 화면으로 RootScreen 설정
    ),
  );
}
