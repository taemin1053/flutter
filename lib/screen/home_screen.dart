import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:start6_1/component/custom_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video; // 선택한 비디오 파일을 저장하는 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: video == null ? renderEmpty() : renderVideo(), // 비디오가 없으면 빈 화면 보여주고, 있으면 비디오 재생
    );
  }

  Widget renderEmpty() {
    // 비디오 선택 전 보여줄 화면
    return Container(
      width: MediaQuery.of(context).size.width, // 화면 가득 차게 하기
      decoration: getBoxDecoration(), // 배경 스타일 적용
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 위젯들을 가운데 정렬
        children: [
          _Logo(onTap: onNewVideoPressed), // 로고 클릭 시 비디오 선택 함수 호출
          SizedBox(height: 30.0), // 로고와 앱 이름 사이의 간격
          _AppName(), // 앱 이름
        ],
      ),
    );
  }

  void onNewVideoPressed() async {
    // 갤러리에서 비디오 선택하는 함수
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery, // 갤러리에서 비디오 선택
    );

    if (video != null) {
      setState(() {
        this.video = video; // 선택한 비디오를 상태에 저장
      });
    }
  }

  Widget renderVideo() {
    // 선택한 비디오를 재생하는 화면
    return Center(
      child: CustomVideoPlayer(
        video: video!, // 선택한 비디오를 전달
        onNewVideoPressed: onNewVideoPressed, // 비디오 새로 선택하는 함수 전달
      ),
    );
  }

  BoxDecoration getBoxDecoration() {
    // 배경에 그라디언트 색상 적용
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2A3A7C), // 상단 색상
          Color(0xFF000118), // 하단 색상
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final GestureTapCallback onTap; // 로고 클릭 시 호출할 함수

  const _Logo({required this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 로고를 클릭하면 새 비디오 선택 함수 호출
      child: Image.asset(
        'asset/img/logo.png', // 로고 이미지 경로
      ),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300, // 일반 굵기
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('VIDEO', style: textStyle), // VIDEO 텍스트
        Text(
          'PLAYER',
          style: textStyle.copyWith(fontWeight: FontWeight.w700), // PLAYER는 두껍게
        ),
      ],
    );
  }
}

class CustomVideoPlayer extends StatefulWidget {
  final XFile video; // 상위에서 선택한 비디오
  final GestureTapCallback onNewVideoPressed; // 새 비디오 선택 함수

  const CustomVideoPlayer({
    required this.video, // 선택한 비디오 파일
    required this.onNewVideoPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController; // 비디오 플레이어 컨트롤러
  bool showControls = false; // 비디오 재생 컨트롤러 표시 여부

  @override
  void initState() {
    super.initState();
    initializeController(); // 비디오 컨트롤러 초기화
  }

  void initializeController() async {
    // 비디오 파일로 비디오 컨트롤러 초기화
    videoController = VideoPlayerController.file(
      File(widget.video.path), // 선택한 비디오 파일 경로
    );
    await videoController!.initialize(); // 비디오 초기화
    setState(() {}); // 상태 갱신
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 비디오 파일이 변경된 경우 초기화
    if (oldWidget.video.path != widget.video.path) {
      initializeController(); // 새로운 비디오로 초기화
    }
  }

  @override
  void dispose() {
    videoController?.dispose(); // 비디오 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoController == null || !videoController!.value.isInitialized) {
      return CircularProgressIndicator(); // 비디오 로딩 중일 때 로딩 인디케이터 표시
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls; // 비디오 화면 클릭 시 컨트롤러 표시/숨기기
        });
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: videoController!.value.aspectRatio, // 비디오 비율에 맞추어 화면 설정
            child: VideoPlayer(videoController!), // 비디오 재생
          ),
          if (showControls) // 컨트롤러를 표시할지 여부에 따라
            Container(
              color: Colors.black.withOpacity(0.5), // 반투명 배경
            ),
        ],
      ),
    );
  }
}
