import 'package:flutter/material.dart'; // Flutter UI 요소를 사용하기 위한 패키지
import 'package:start5_2/screen/home_screen.dart'; // 홈 화면 가져오기
import 'package:start5_2/screen/setting_screen.dart'; // 설정 화면 가져오기
import 'dart:math'; // 수학 관련 기능을 사용하기 위한 패키지
// ShakeDetector 패키지 임포트 (주석으로 포함, 사용하지 않음)

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  State<RootScreen> createState() => _RootScreenState();
}

// RootScreen의 상태를 관리하는 클래스
class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller; // 사용할 TabController 선언
  double threshold = 2.7; // 민감도 초기값
  int number = 1; // 주사위 숫자 초기값

  @override
  void initState() {
    super.initState();
    // TabController 초기화: 2개의 탭을 위한 설정
    controller = TabController(length: 2, vsync: this);
    controller!.addListener(tabListener); // 탭 변경 리스너 추가
  }

  // 주사위를 굴리는 함수
  void rollDice() {
    final rand = Random(); // Random 객체 생성
    setState(() {
      number = rand.nextInt(6) + 1; // 1부터 6까지의 랜덤 숫자 생성
    });
  }

  // 탭 변경 시 호출되는 리스너
  tabListener() {
    setState(() {}); // 상태 변경으로 UI 업데이트
  }

  @override
  dispose() {
    controller!.removeListener(tabListener); // 리스너 제거
    super.dispose(); // 부모 클래스의 dispose 호출
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: controller, // 탭 컨트롤러 연결
        children: renderChildren(), // 자식 위젯 렌더링
      ),
      bottomNavigationBar: renderBottomNavigation(), // 하단 내비게이션 바 렌더링
    );
  }

  // 자식 위젯들을 렌더링하는 함수
  List<Widget> renderChildren() {
    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
        children: [
          HomeScreen(number: number), // 홈 화면 위젯
          SizedBox(height: 20), // 여백 추가
          ElevatedButton(
            onPressed: rollDice, // 버튼 클릭 시 주사위 굴리기
            child: Text('주사위 굴리기'), // 버튼 텍스트
          ),
        ],
      ),
      SettingsScreen(
        threshold: threshold, // 민감도 값 전달
        onThresholdChange: onThresholdChange, // 민감도 변경 콜백 전달
      ),
    ];
  }

  // 민감도 값 변경 시 호출되는 함수
  void onThresholdChange(double val) {
    setState(() {
      threshold = val; // 민감도 값 업데이트
    });
  }

  // 하단 내비게이션 바 렌더링 함수
  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: controller!.index, // 현재 선택된 탭 인덱스
      onTap: (int index) { // 탭 클릭 시 호출
        setState(() {
          controller!.animateTo(index); // 선택된 탭으로 애니메이션
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.edgesensor_high_outlined, // 주사위 아이콘
          ),
          label: '주사위', // 주사위 탭 레이블
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings, // 설정 아이콘
          ),
          label: '설정', // 설정 탭 레이블
        ),
      ],
    );
  }
}
