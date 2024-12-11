import 'package:start5_2/const/colors.dart'; // 색상 상수를 가져옴
import 'package:flutter/material.dart'; // Flutter UI 요소를 사용하기 위한 패키지

// 설정 화면을 위한 StatelessWidget 클래스
class SettingsScreen extends StatelessWidget {
  final double threshold; // 민감도 값
  final ValueChanged<double> onThresholdChange; // 민감도 값 변경 시 호출되는 콜백 함수

  // 생성자: threshold와 onThresholdChange를 필수로 받음
  const SettingsScreen({
    Key? key,
    required this.threshold, // 필수 인자로 민감도 값
    required this.onThresholdChange, // 필수 인자로 값 변경 콜백
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0), // 왼쪽 여백 설정
          child: Row(
            children: [
              Text(
                '민감도', // 민감도 레이블 텍스트
                style: TextStyle(
                  color: secondaryColor, // 글자 색상
                  fontSize: 20.0, // 글자 크기
                  fontWeight: FontWeight.w700, // 글자 두께
                ),
              ),
            ],
          ),
        ),
        Slider(
          min: 0.1, // ➊ 슬라이더 최솟값
          max: 10.0, // ➋ 슬라이더 최댓값
          divisions: 101, // ➌ 슬라이더 최솟값과 최댓값 사이의 구간 개수
          value: threshold, // ➍ 현재 슬라이더의 선택값
          onChanged: onThresholdChange, // ➎ 값 변경 시 실행되는 콜백 함수
          label: threshold.toStringAsFixed(1), // ➏ 슬라이더의 표싯값 (소수점 한 자리)
        ),
      ],
    );
  }
}
