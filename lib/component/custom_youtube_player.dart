import 'package:flutter/material.dart';
import 'package:start8_2_1/Model/video_model.dart';
// 유튜브 재생기를 사용하기 위해 패키지 불러오기
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// 유튜브 동영상 재생기로 사용할 위젯 정의
class CustomYoutubePlayer extends StatefulWidget {

  // 상위 위젯에서 입력받을 동영상 정보
  final VideoModel videoModel;

  // CustomYoutubePlayer에 고유 키값하고, videoModel 매개변수 받는 거 설정
  const CustomYoutubePlayer({
    required this.videoModel,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomYoutubePlayer> createState() => _CustomYoutubePlayerState();
}

// 유튜브 플레이어 위젯을 조정하려면 유튜브 플레이어 컨트롤러 위젯을 사용하고
// initState 함수로 유튜브 플레이어를 초기화하고 dispose 함수로 폐기
// Column 위젯을 사용해서 유튜브 플레이어 위젯과 Text 위젯을 세로로 배치해서
// 동영상 아래의 동영상 제목을 만들 수 있게 UI 설계
class _CustomYoutubePlayerState extends State<CustomYoutubePlayer> {
  YoutubePlayerController? controller;

  @override
  void initState() {
    super.initState();

    controller = YoutubePlayerController(  // ➊ 컨트롤러 선언
      initialVideoId: widget.videoModel.id,  // 처음 실행할 동영상의 ID
      flags: YoutubePlayerFlags(  // YoutubePlayer 플러그인 설정하기
        autoPlay: false,  // 자동 실행 사용하지 않기
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      // CrossAxisAlignment.stretch를 사용하면 Column에서는 자식 위젯이 가로로 꽉 차게,
      // Row에서는 자식 위젯이 세로로 꽉 차게 정렬
      children: [
        YoutubePlayer(  // ➋ 유튜브 동영상을 재생할 수 있는 위젯
          controller: controller!,  // controller 매개변수를 필수로 입력해줘야 하고 YoutubePlayerController 타입을 입력하면 된다.
          showVideoProgressIndicator: true,  // 재생바 트루
        ),
        const SizedBox(height: 16.0),  // 여백 만들기
        Padding(  // 안쪽에 여백 추가하기
          padding: const EdgeInsets.symmetric(horizontal: 8.0),  // 좌우 8포인트 여백 만들기
          child: Text(
            widget.videoModel.title,  // 비디오 모델에서 제목 가져오기
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 16.0),  // 여백 만들기
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();

    controller!.dispose();  // ➌ State 폐기 시 컨트롤러도 폐기하기
  }
}