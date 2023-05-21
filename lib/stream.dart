import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

Future<void> startYoutubeStream(AutoRefreshingAuthClient client) async {
  try {
    final api = YouTubeApi(client);

    final stream = await api.liveStreams.insert(
      LiveStream(
        contentDetails: LiveStreamContentDetails(isReusable: true),
        snippet: LiveStreamSnippet(title: 'Test Stream'),
        cdn: CdnSettings(
          ingestionType: 'rtmp',
          resolution: 'variable',
        ),
      ),
      ['snippet', 'cdn'],
    );

    print('Stream ID: ${stream.toJson()}');

    final streamId = stream.id;
    final streamUrl = stream.cdn?.ingestionInfo?.streamName;
    final serverUrl = stream.cdn?.ingestionInfo?.ingestionAddress;

    if (streamId != null && streamUrl != null && serverUrl != null) {
      final rtmpUrl = 'rtmp://$serverUrl/app/$streamUrl';
      print('RTMP URL: $rtmpUrl');
    } else {
      print('Unable to retrieve stream information.');
    }
  } catch (e) {
    print(e);
  }
}
