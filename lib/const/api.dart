const API_KEY = 'AIzaSyAmFYrJlJSBpxL352utSMcVBaapdXBcE78';
// Youtube Data API V3 URL
const YOUTUBE_API_BASE_URL = 'https://youtube.googleapis.com/youtube/v3/search';
// 설명:
// key: 구글 클라우드 콘솔에서 발급받은 키값입니다.
// part: 어떤 정보를 불러올지 정의 -> Search:list API에서는 snippet(재사용 가능한 코드)만 사용할 수 있습니다.
//       동영상 정보를 불러올 때 썸네일과 ID 등 다양한 정보를 추가로 가져옵니다.
// channelId: 동영상을 불러올 대상 채널의 ID입니다.
// maxResults: 최대로 가져올 결과값의 개수를 정의합니다.

const CF_CHANNEL_ID = 'UCxZ2AlaT0hOmxzZVbF_j_Sw'; // 코드 팩토리 채널 ID