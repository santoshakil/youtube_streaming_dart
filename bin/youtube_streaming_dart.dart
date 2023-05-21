import 'dart:io';

import 'package:googleapis/youtube/v3.dart';
import 'package:googleapis_auth/auth_io.dart';

void main(List<String> arguments) async {
  final client = await oAuthAuthintication();
  if (client == null) return;
  await startYoutubeStream(client);
}

Future<AutoRefreshingAuthClient?> oAuthAuthintication() async {
  try {
    final credentials = ServiceAccountCredentials.fromJson(File('youtube-api-key.json').readAsStringSync());

    final client = await clientViaServiceAccount(
      credentials,
      [
        YouTubeApi.youtubeReadonlyScope,
        YouTubeApi.youtubeUploadScope,
        YouTubeApi.youtubeScope,
      ],
    );
    print('\nAuthinticated: ${client.credentials.toJson()}\n');

    return client;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<void> startYoutubeStream(AutoRefreshingAuthClient client) async {
  try {
    final api = YouTubeApi(client);

    final stream = await api.liveStreams.insert(
      LiveStream(
        snippet: LiveStreamSnippet(title: 'Test Upload', isDefaultStream: true),
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
