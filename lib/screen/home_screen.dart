import 'package:start5_2/const/colors.dart'; // 색상 상수를 가져옴
import 'package:flutter/material.dart'; // Flutter UI 요소를 사용하기 위한 패키지

// 홈 화면을 위한 StatelessWidget 클래스
class HomeScreen extends StatelessWidget {
  final int number; // 주사위 숫자 처리
  // 주사위 숫자는 RootScreen에서 생성됨
  const HomeScreen(
      {required this.number, Key? key,}) : super(key: key); // 주사위 숫자를 인자로 받는 생성자

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
      children: [
        Center( // ➊ 주사위 이미지
          child: Image.asset('asset/Img/$number.png'), // 주사위 숫자에 해당하는 이미지 표시
        ),
        SizedBox(height: 32.0), // 위쪽 여백
        Text(
          '행운의 숫자', // 행운의 숫자 텍스트
          style: TextStyle(
            color: secondaryColor, // 글자 색상
            fontSize: 20.0, // 글자 크기
            fontWeight: FontWeight.w700, // 글자 두께
          ),
        ),
        SizedBox(height: 12.0), // 아래쪽 여백
        Text(
          number.toString(), // ➋ 주사위 값에 해당되는 숫자
          style: TextStyle(
            color: primaryColor, // 글자 색상
            fontSize: 60.0, // 글자 크기
            fontWeight: FontWeight.w200, // 글자 두께
          ),
        ),
      ],
    );
  }
}
