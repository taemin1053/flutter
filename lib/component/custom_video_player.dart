import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart'; // 갤러리에서 비디오를 가져오는 라이브러리
import 'dart:io';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video; // 선택한 비디오 파일
  final GestureTapCallback onNewVideoPressed; // 새 비디오 선택 시 호출되는 콜백

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoController; // 비디오 플레이어 컨트롤러
  bool showControls = true; // 비디오 컨트롤의 표시 여부

  @override
  void initState() {
    super.initState();
    initializeController(); // 비디오 컨트롤러 초기화
  }

  // 비디오 컨트롤러를 초기화하는 메서드
  void initializeController() async {
    videoController = VideoPlayerController.file(File(widget.video.path)); // 파일 경로를 기반으로 컨트롤러 생성
    await videoController!.initialize(); // 비디오 초기화
    setState(() {}); // 상태를 업데이트하여 화면을 다시 그리도록 함
  }

  @override
  void dispose() {
    videoController?.dispose(); // 컨트롤러 해제
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 비디오가 초기화되지 않은 경우 로딩 인디케이터 표시
    if (videoController == null || !videoController!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: videoController!.value.aspectRatio, // 비디오 비율에 맞춰 화면 비율 설정
          child: VideoPlayer(videoController!), // 비디오 재생
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Slider(
            onChanged: (double val) {
              videoController!.seekTo(Duration(seconds: val.toInt())); // 슬라이더 위치에 따라 비디오 위치 변경
            },
            value: videoController!.value.position.inSeconds.toDouble(), // 현재 재생 중인 위치
            min: 0,
            max: videoController!.value.duration.inSeconds.toDouble(), // 비디오 총 길이
          ),
        ),
        if (showControls)
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: onReversePressed, // 3초 뒤로 이동
                  icon: Icon(Icons.rotate_left, color: Colors.white, size: 30.0),
                ),
                IconButton(
                  onPressed: onPlayPressed, // 재생/일시정지 토글
                  icon: Icon(
                    videoController!.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
                IconButton(
                  onPressed: onForwardPressed, // 3초 앞으로 이동
                  icon: Icon(Icons.rotate_right, color: Colors.white, size: 30.0),
                ),
              ],
            ),
          ),
        if (showControls)
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: widget.onNewVideoPressed, // 새 비디오 선택 버튼
              icon: Icon(Icons.photo_camera_back, color: Colors.white),
            ),
          ),
      ],
    );
  }

  // 3초 뒤로 이동하는 메서드
  void onReversePressed() {
    final currentPosition = videoController!.value.position;
    Duration position = Duration();
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3); // 현재 위치에서 3초 감소
    }
    videoController!.seekTo(position); // 새로운 위치로 이동
  }

  // 3초 앞으로 이동하는 메서드
  void onForwardPressed() {
    final maxPosition = videoController!.value.duration; // 비디오의 총 길이
    final currentPosition = videoController!.value.position; // 현재 위치
    Duration position = maxPosition;
    if ((maxPosition - Duration(seconds: 3)).inSeconds > currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3); // 현재 위치에서 3초 증가
    }
    videoController!.seekTo(position); // 새로운 위치로 이동
  }

  // 재생 또는 일시정지하는 메서드
  void onPlayPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause(); // 재생 중이면 일시정지
    } else {
      videoController!.play(); // 일시정지 중이면 재생
    }
    setState(() {}); // 상태 업데이트
  }
}
