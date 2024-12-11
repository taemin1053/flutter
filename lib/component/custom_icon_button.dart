import 'package:flutter/material.dart'; // Flutter의 Material Design 위젯 패키지 임포트
import 'package:video_player/video_player.dart'; // 비디오 재생 기능을 위한 패키지 임포트
import 'dart:io'; // 파일 시스템 작업을 위한 패키지 임포트
import 'package:image_picker/image_picker.dart'; // 이미지 및 비디오 선택을 위한 패키지 임포트
import 'package:start6_1/screen/home_screen.dart'; // HomeScreen 위젯 임포트

// 커스텀 아이콘 버튼 위젯
class CustomIconButton extends StatelessWidget {
  final GestureTapCallback onPressed; // 클릭 시 호출될 콜백 함수
  final IconData iconData; // 아이콘 데이터

  const CustomIconButton({
    required this.onPressed,
    required this.iconData,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed, // 클릭 시 콜백 함수 호출
      iconSize: 30.0, // 아이콘 크기
      color: Colors.white, // 아이콘 색상
      icon: Icon(iconData), // 아이콘 표시
    );
  }
}

// 커스텀 비디오 플레이어 위젯
class CustomVideoPlayer extends StatefulWidget {
  final XFile video; // 재생할 비디오 파일
  final GestureTapCallback onNewVideoPressed; // 새로운 비디오 선택 시 호출될 콜백 함수

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    Key? key,
  }) : super(key: key);

  @override
  _CustomVideoPlayerState createState() => _CustomVideoPlayerState(); // 상태 관리 클래스 생성
}

// CustomVideoPlayer의 상태를 관리하는 클래스
class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController; // 비디오 컨트롤러
  bool showControls = false; // 재생 컨트롤 표시 여부

  @override
  void initState() {
    super.initState();
    initializeController(); // 비디오 컨트롤러 초기화
  }

  // 비디오 컨트롤러 초기화 함수
  initializeController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path), // 선택된 비디오 파일 경로로 컨트롤러 생성
    );
    await videoController.initialize(); // 비디오 초기화
    videoController.addListener(videoControllerListener); // 리스너 추가
    setState(() {
      this.videoController = videoController; // 상태 업데이트
    });
  }

  // 비디오 상태 변경 리스너
  void videoControllerListener() {
    setState(() {}); // 상태 업데이트
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 비디오 경로가 변경되면 컨트롤러 초기화
    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  @override
  void dispose() {
    videoController?.removeListener(videoControllerListener); // 리스너 제거
    videoController?.dispose(); // 비디오 컨트롤러 해제
    super.dispose();
  }

  // 비디오를 3초 되감는 함수
  void onReversePressed() {
    final currentPosition = videoController!.value.position; // 현재 재생 위치
    Duration position = Duration(seconds: 0); // 초기 위치

    // 현재 위치가 3초보다 크면 되감기
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }
    videoController!.seekTo(position); // 새 위치로 이동
  }

  // 비디오를 3초 앞으로 감는 함수
  void onForwardPressed() {
    final maxPosition = videoController!.value.duration; // 비디오 최대 길이
    final currentPosition = videoController!.value.position; // 현재 재생 위치
    Duration position = maxPosition; // 초기 위치를 최대 길이로 설정

    // 현재 위치가 최대 길이에서 3초 이내이면 앞으로 감기
    if ((maxPosition - Duration(seconds: 3)).inSeconds > currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }
    videoController!.seekTo(position); // 새 위치로 이동
  }

  // 재생 또는 일시 정지 토글 함수
  void onPlayPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause(); // 현재 재생 중이면 일시 정지
    } else {
      videoController!.play(); // 현재 일시 정지 상태이면 재생
    }
  }

  @override
  Widget build(BuildContext context) {
    // 비디오가 초기화되지 않았으면 로딩 인디케이터 표시
    if (videoController == null || !videoController!.value.isInitialized) {
      return CircularProgressIndicator();
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls; // 클릭 시 컨트롤 표시 여부 토글
        });
      },
      child: Stack(
        children: [
          AspectRatio(
            aspectRatio: videoController!.value.aspectRatio, // 비디오 비율에 맞게 조정
            child: VideoPlayer(videoController!), // 비디오 플레이어 표시
          ),
          if (showControls) // 컨트롤이 표시되는 경우
            Align(
              alignment: Alignment.center, // 중앙 정렬
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 간격 균등 배치
                children: [
                  CustomIconButton(
                    onPressed: onReversePressed, // 되감기 버튼
                    iconData: Icons.rotate_left, // 아이콘
                  ),
                  CustomIconButton(
                    onPressed: onPlayPressed, // 재생/일시정지 버튼
                    iconData: videoController!.value.isPlaying
                        ? Icons.pause // 재생 중이면 일시정지 아이콘
                        : Icons.play_arrow, // 일시정지 상태면 재생 아이콘
                  ),
                  CustomIconButton(
                    onPressed: onForwardPressed, // 빨리감기 버튼
                    iconData: Icons.rotate_right, // 아이콘
                  ),
                ],
              ),
            ),
          Align(
            alignment: Alignment.topRight, // 오른쪽 상단 정렬
            child: CustomIconButton(
              onPressed: widget.onNewVideoPressed, // 새로운 비디오 선택 버튼
              iconData: Icons.photo_camera_back, // 아이콘
            ),
          ),
        ],
      ),
    );
  }
}
