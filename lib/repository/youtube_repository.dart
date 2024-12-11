import 'package:start8_2_1/const/api.dart';
import 'package:dio/dio.dart';
import 'package:start8_2_1/Model/video_model.dart';

class YoutubeRepository {
  static Future<List<VideoModel>> getVideos() async {
    final resp = await Dio().get(  // GET 메서드 보내기
      YOUTUBE_API_BASE_URL,  // 요청을 보낼 URL
      queryParameters: {     // 요청에 포함할 쿼리 변수들
        'channelId': CF_CHANNEL_ID,
        'maxResults': 50,
        'key': API_KEY,       // API 키 값
        'part': 'snippet',    // 어떤 정보를 불러올지 정의, 'snippet' 사용
        'order': 'date',      // 최신순으로 정렬
      },
    );

    final listWithData = resp.data['items'].where(
          (item) =>
      item?['id']?['videoId'] != null && item?['snippet']?['title'] != null,
    );  // videoId와 title이 null이 아닌 값들만 필터링

    return listWithData
        .map<VideoModel>(
          (item) => VideoModel(
        id: item['id']['videoId'],           // VideoModel의 ID 필드에 videoId 할당
        title: item['snippet']['title'],      // VideoModel의 title 필드에 제목 할당
      ),
    )
        .toList();  // 필터링된 값들을 기반으로 VideoModel 생성
  }
}