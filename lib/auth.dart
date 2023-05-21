import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';
import 'package:googleapis/youtube/v3.dart';

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
